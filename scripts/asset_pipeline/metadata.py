"""Builds [AnimationRecord]s from packed frames and serializes the atlas
JSON manifest.

The JSON shape produced by [atlas_to_json] is exactly what
[validation.validate_manifest_schema] checks and what the (dormant)
Flutter seam (``lib/models/sprite_atlas.dart``) parses — the three are
kept in sync by construction, and the CLI's own build always validates
its own output before writing it (see ``cli.py``).
"""

from __future__ import annotations

import dataclasses
import json

from .models import AnimationRecord, AssetGroup, FrameRect, PackedFrame, PipelineConfig

SCHEMA_VERSION = 1


def build_animation_records(
    groups: list[AssetGroup],
    packed_by_source_id: dict[str, PackedFrame],
    *,
    atlas_file: str,
    config: PipelineConfig,
) -> list[AnimationRecord]:
    """One [AnimationRecord] per [AssetGroup] — a single-frame group
    becomes a record with one frame, a numbered sequence becomes a record
    with several, in the group's already-deterministic frame order.
    ``verified`` starts `False`; use [mark_verified] once
    ``validation.py``'s checks have actually run.
    """
    records: list[AnimationRecord] = []
    for group in groups:
        frame_rects: list[FrameRect] = []
        for image in group.images:
            packed = packed_by_source_id[image.id]
            frame_rects.append(
                FrameRect(
                    source_file=image.path.relative_to(config.source).as_posix(),
                    source_hash=image.sha256,
                    x=packed.atlas_x,
                    y=packed.atlas_y,
                    width=packed.atlas_width,
                    height=packed.atlas_height,
                    original_width=packed.original_width,
                    original_height=packed.original_height,
                    trimmed_offset_x=packed.trimmed_offset_x,
                    trimmed_offset_y=packed.trimmed_offset_y,
                )
            )
        records.append(
            AnimationRecord(
                asset_id=group.asset_id,
                frames=tuple(frame_rects),
                atlas_file=atlas_file,
                anchor_x=config.anchor_x,
                anchor_y=config.anchor_y,
                frame_duration_ms=config.frame_duration_ms,
                loop=config.loop,
                reduced_motion_fallback_frame=0,
                content_version=config.content_version,
                verified=False,
            )
        )
    return records


def mark_verified(
    records: list[AnimationRecord], *, verified: bool
) -> list[AnimationRecord]:
    """Returns a new list with every record's ``verified`` flag replaced —
    [AnimationRecord] is frozen, so this never mutates the input."""
    return [dataclasses.replace(record, verified=verified) for record in records]


def atlas_to_json(
    *,
    atlas_id: str,
    atlas_file: str,
    atlas_width: int,
    atlas_height: int,
    content_version: int,
    animations: list[AnimationRecord],
) -> dict:
    """Serializes the atlas manifest to a plain JSON-able dict, in a fixed
    key order (Python dicts preserve insertion order, so this is
    deterministic without needing ``sort_keys``)."""
    return {
        "schemaVersion": SCHEMA_VERSION,
        "atlasId": atlas_id,
        "atlasFile": atlas_file,
        "atlasWidth": atlas_width,
        "atlasHeight": atlas_height,
        "contentVersion": content_version,
        "animations": [
            {
                "assetId": animation.asset_id,
                "sourceFiles": list(animation.source_files),
                "sourceHashes": list(animation.source_hashes),
                "atlasFile": animation.atlas_file,
                "anchor": {"x": animation.anchor_x, "y": animation.anchor_y},
                "frameDurationMs": animation.frame_duration_ms,
                "loop": animation.loop.value,
                "reducedMotionFallbackFrame": animation.reduced_motion_fallback_frame,
                "contentVersion": animation.content_version,
                "verified": animation.verified,
                "frames": [
                    {
                        "sourceFile": frame.source_file,
                        "sourceHash": frame.source_hash,
                        "x": frame.x,
                        "y": frame.y,
                        "width": frame.width,
                        "height": frame.height,
                        "originalWidth": frame.original_width,
                        "originalHeight": frame.original_height,
                        "trimmedOffsetX": frame.trimmed_offset_x,
                        "trimmedOffsetY": frame.trimmed_offset_y,
                    }
                    for frame in animation.frames
                ],
            }
            for animation in animations
        ],
    }


def atlas_to_json_string(**kwargs) -> str:
    """[atlas_to_json] serialized with stable, deterministic formatting —
    fixed indentation, no key sorting (insertion order is already the
    intended, stable order)."""
    return json.dumps(atlas_to_json(**kwargs), indent=2) + "\n"
