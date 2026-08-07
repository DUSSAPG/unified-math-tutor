"""Command-line entry point and pipeline orchestration.

``run_build`` is the pure orchestration function (discover → decode →
trim → pack → metadata → validate → flutter_catalog → report) — it
writes every artifact into whatever ``target_dir`` it's given, with no
opinion about atomicity. ``main`` is what makes the *published* output
safe: it always builds into a fresh temporary directory created **as a
sibling of the real output directory** (same filesystem, so the final
``os.replace`` per file is a true atomic rename, not a cross-volume
copy), and only moves files into the real output directory once the
whole build has succeeded and passed validation. A failure at any stage
propagates out of the ``with tempfile.TemporaryDirectory()`` block,
which cleans the temp directory up automatically — the real output
directory is never touched.
"""

from __future__ import annotations

import argparse
import os
import sys
import tempfile
from pathlib import Path

from PIL import Image

from . import discovery, flutter_catalog, image_io, metadata, packing, reporting, trimming, validation
from .models import (
    AssetPipelineError,
    BuildReport,
    DecodedFrame,
    FrameReportEntry,
    LoopMode,
    PipelineConfig,
    TrimResult,
)


def run_build(config: PipelineConfig, *, target_dir: Path) -> BuildReport:
    """Runs the full pipeline and writes every artifact into
    ``target_dir``. Raises [AssetPipelineError] subclasses on any of the
    "fail safely" conditions (duplicate ids, unreadable/blank frames,
    atlas too large). Geometry/schema problems are instead collected into
    the returned [BuildReport]'s ``errors`` — those are still failures
    (``report.ok`` is `False`), but ones with enough context to report in
    full rather than aborting at the first one.
    """
    groups = discovery.discover_and_group(config)
    if not groups:
        raise AssetPipelineError(f"No source images found under '{config.source}'.")

    entries: list[FrameReportEntry] = []
    decoded_and_trims: list[tuple[DecodedFrame, TrimResult]] = []
    for group in groups:
        for image in group.images:
            frame = image_io.load_frame(image)
            trim = trimming.maybe_trim(frame, trim=config.trim)
            decoded_and_trims.append((frame, trim))
            entries.append(
                FrameReportEntry(
                    asset_id=image.id, source_file=str(image.path), status="ok"
                )
            )

    atlas_pixels, packed_frames = packing.pack_frames(
        decoded_and_trims,
        padding=config.padding,
        extrusion=config.extrusion,
        max_atlas_size=config.max_atlas_size,
    )
    packed_by_id = {frame.source.id: frame for frame in packed_frames}
    atlas_height, atlas_width = atlas_pixels.shape[:2]

    errors: list[str] = []
    errors.extend(validation.check_no_overlaps(packed_frames))
    errors.extend(validation.check_within_atlas_bounds(atlas_width, atlas_height, packed_frames))
    errors.extend(validation.check_max_size(atlas_width, atlas_height, config.max_atlas_size))
    geometry_ok = not errors

    atlas_filename = f"{config.atlas_id}.png"
    manifest_filename = f"{config.atlas_id}.json"

    records = metadata.build_animation_records(
        groups, packed_by_id, atlas_file=atlas_filename, config=config
    )
    records = metadata.mark_verified(records, verified=geometry_ok)

    manifest = metadata.atlas_to_json(
        atlas_id=config.atlas_id,
        atlas_file=atlas_filename,
        atlas_width=atlas_width,
        atlas_height=atlas_height,
        content_version=config.content_version,
        animations=records,
    )
    errors.extend(validation.validate_manifest_schema(manifest))

    warnings = reporting.check_size_warning(atlas_width, atlas_height, config.max_atlas_size)

    report = BuildReport(
        atlas_id=config.atlas_id,
        frame_count=len(decoded_and_trims),
        animation_count=len(records),
        atlas_width=atlas_width,
        atlas_height=atlas_height,
        peak_memory_bytes=reporting.estimate_peak_memory_bytes(atlas_width, atlas_height),
        max_atlas_size=config.max_atlas_size,
        warnings=warnings,
        errors=errors,
        entries=entries,
    )

    if not report.ok:
        return report

    target_dir.mkdir(parents=True, exist_ok=True)
    Image.fromarray(atlas_pixels, mode="RGBA").save(target_dir / atlas_filename)
    (target_dir / manifest_filename).write_text(
        metadata.atlas_to_json_string(
            atlas_id=config.atlas_id,
            atlas_file=atlas_filename,
            atlas_width=atlas_width,
            atlas_height=atlas_height,
            content_version=config.content_version,
            animations=records,
        ),
        encoding="utf-8",
    )
    dart_filename = f"{config.atlas_id}_atlas.dart"
    (target_dir / dart_filename).write_text(
        flutter_catalog.generate_dart_catalog(
            atlas_id=config.atlas_id,
            atlas_file=atlas_filename,
            manifest_file=manifest_filename,
            animations=records,
        ),
        encoding="utf-8",
    )
    (target_dir / f"{config.atlas_id}_report.csv").write_text(
        reporting.report_to_csv_string(report), encoding="utf-8", newline=""
    )
    (target_dir / f"{config.atlas_id}_report.json").write_text(
        reporting.report_to_json_string(report), encoding="utf-8"
    )

    return report


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="python -m scripts.asset_pipeline",
        description="Offline, deterministic sprite-atlas + Flutter-manifest builder.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    defaults = PipelineConfig(source=Path("."), output=Path("."), atlas_id="_")

    build = subparsers.add_parser("build", help="Build one sprite atlas + manifest.")
    build.add_argument("--source", required=True, help="Source image directory.")
    build.add_argument("--output", required=True, help="Output directory for the built atlas.")
    build.add_argument("--atlas-id", required=True, help="Stable id for this atlas.")
    build.add_argument("--max-atlas-size", type=int, default=defaults.max_atlas_size)
    build.add_argument("--padding", type=int, default=defaults.padding)
    build.add_argument("--extrusion", type=int, default=defaults.extrusion)
    build.add_argument(
        "--trim", action=argparse.BooleanOptionalAction, default=defaults.trim
    )
    build.add_argument("--overwrite", action="store_true", default=defaults.overwrite)
    build.add_argument("--frame-duration-ms", type=int, default=defaults.frame_duration_ms)
    build.add_argument(
        "--loop", choices=[mode.value for mode in LoopMode], default=defaults.loop.value
    )
    build.add_argument("--content-version", type=int, default=defaults.content_version)
    build.add_argument("--anchor-x", type=float, default=defaults.anchor_x)
    build.add_argument("--anchor-y", type=float, default=defaults.anchor_y)
    return parser


def _config_from_args(args: argparse.Namespace) -> PipelineConfig:
    return PipelineConfig(
        source=Path(args.source),
        output=Path(args.output),
        atlas_id=args.atlas_id,
        max_atlas_size=args.max_atlas_size,
        padding=args.padding,
        extrusion=args.extrusion,
        trim=args.trim,
        overwrite=args.overwrite,
        frame_duration_ms=args.frame_duration_ms,
        loop=LoopMode(args.loop),
        content_version=args.content_version,
        anchor_x=args.anchor_x,
        anchor_y=args.anchor_y,
    )


def _print_report(report: BuildReport) -> None:
    status = "OK" if report.ok else "FAILED"
    kib = report.peak_memory_bytes / 1024
    print(
        f"[{status}] atlas '{report.atlas_id}': {report.frame_count} frames, "
        f"{report.animation_count} animations, "
        f"{report.atlas_width}x{report.atlas_height}px, ~{kib:.1f} KiB peak."
    )
    for warning in report.warnings:
        print(f"  warning: {warning}")
    for error in report.errors:
        print(f"  error: {error}")


def build_command(config: PipelineConfig) -> BuildReport:
    """Runs a build with the full atomic-publish behaviour ``main()``
    uses, but returns the [BuildReport] instead of an exit code — the
    entry point ``main()`` and tests both call this."""
    if config.output.exists() and any(config.output.iterdir()) and not config.overwrite:
        raise AssetPipelineError(
            f"Output directory '{config.output}' already has content — "
            "pass --overwrite to replace it."
        )

    config.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(
        dir=config.output.parent, prefix=f".{config.atlas_id}-build-"
    ) as tmp_name:
        temp_dir = Path(tmp_name)
        report = run_build(config, target_dir=temp_dir)
        if not report.ok:
            return report

        config.output.mkdir(parents=True, exist_ok=True)
        for artifact in temp_dir.iterdir():
            os.replace(artifact, config.output / artifact.name)

    return report


def main(argv: list[str] | None = None) -> int:
    parser = _build_arg_parser()
    args = parser.parse_args(argv)
    config = _config_from_args(args)

    try:
        report = build_command(config)
    except AssetPipelineError as error:
        print(f"Build failed: {error}", file=sys.stderr)
        return 1

    _print_report(report)
    return 0 if report.ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
