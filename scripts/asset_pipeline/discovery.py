"""Recursive source-image discovery, stable asset-id derivation, content
hashing, and numbered-sequence grouping.

Every function here is pure with respect to program state: given the same
files on disk, they always return the same result, and none of them
depend on filesystem enumeration order (all outputs are explicitly
sorted) — research principles 3 and 4.
"""

from __future__ import annotations

import hashlib
import re
from pathlib import Path

from .models import (
    AssetGroup,
    DuplicateAssetIdError,
    PipelineConfig,
    SourceDirectoryNotFoundError,
    SourceImage,
)

_SEQUENCE_SUFFIX = re.compile(r"^(?P<base>.+?)_(?P<index>\d+)$")

_HASH_CHUNK_SIZE = 65536


def discover_source_files(config: PipelineConfig) -> list[Path]:
    """Recursively finds every supported image under ``config.source``,
    sorted for determinism — ``Path.rglob`` order is filesystem-dependent
    and must never leak into the pipeline's output."""
    if not config.source.is_dir():
        raise SourceDirectoryNotFoundError(
            f"Source directory does not exist: {config.source}"
        )
    paths = [
        path
        for path in config.source.rglob("*")
        if path.is_file() and path.suffix.lower() in config.supported_extensions
    ]
    return sorted(paths)


def hash_file(path: Path) -> str:
    """SHA-256 of a file's bytes, read in fixed-size chunks so hashing
    never loads a whole (potentially large) source file into memory."""
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(_HASH_CHUNK_SIZE), b""):
            digest.update(chunk)
    return digest.hexdigest()


def asset_id_for_path(path: Path, source_root: Path) -> str:
    """The stable, deterministic id for one source file: its path relative
    to the source root, extension stripped, forward-slash-normalized."""
    relative = path.relative_to(source_root).with_suffix("")
    return relative.as_posix()


def discover_source_images(config: PipelineConfig) -> list[SourceImage]:
    """Discovers, ids, and hashes every source file.

    Raises [DuplicateAssetIdError] immediately on the first collision —
    never silently keeps one file and drops the other.
    """
    seen: dict[str, Path] = {}
    images: list[SourceImage] = []
    for path in discover_source_files(config):
        asset_id = asset_id_for_path(path, config.source)
        if asset_id in seen:
            raise DuplicateAssetIdError(
                f"Duplicate asset id '{asset_id}': '{seen[asset_id]}' and "
                f"'{path}' both resolve to it."
            )
        seen[asset_id] = path
        images.append(
            SourceImage(id=asset_id, path=path, sha256=hash_file(path))
        )
    return images


def _sequence_key(image: SourceImage) -> tuple[str, int] | None:
    """If ``image``'s id ends in a numbered suffix (``kick_01``), returns
    ``(group_id, index)``; otherwise ``None`` (it stands alone)."""
    as_path = Path(image.id)
    match = _SEQUENCE_SUFFIX.match(as_path.name)
    if match is None:
        return None
    parent = as_path.parent.as_posix()
    base = match.group("base")
    group_id = base if parent in ("", ".") else f"{parent}/{base}"
    return group_id, int(match.group("index"))


def group_into_assets(images: list[SourceImage]) -> list[AssetGroup]:
    """Groups numbered sequences (``kick_01``, ``kick_02``, ...) into one
    [AssetGroup] each, frames ordered by their numeric suffix; every other
    image becomes its own single-frame group.

    Raises [DuplicateAssetIdError] if a sequence's group id collides with
    another asset's id (e.g. a lone ``kick.png`` alongside a
    ``kick_01.png``/``kick_02.png`` sequence) — this can't be caught by
    [discover_source_images]'s per-file check, since it only appears once
    frames are grouped.
    """
    grouped: dict[str, list[tuple[int, SourceImage]]] = {}
    singles: list[SourceImage] = []
    for image in images:
        key = _sequence_key(image)
        if key is None:
            singles.append(image)
            continue
        group_id, index = key
        grouped.setdefault(group_id, []).append((index, image))

    groups: list[AssetGroup] = []
    for group_id in sorted(grouped):
        ordered = tuple(
            img for _, img in sorted(grouped[group_id], key=lambda pair: pair[0])
        )
        groups.append(AssetGroup(asset_id=group_id, images=ordered))
    for image in singles:
        groups.append(AssetGroup(asset_id=image.id, images=(image,)))

    groups.sort(key=lambda group: group.asset_id)

    seen_ids: set[str] = set()
    for group in groups:
        if group.asset_id in seen_ids:
            raise DuplicateAssetIdError(
                f"Duplicate asset id '{group.asset_id}' after sequence "
                "grouping — check for a lone file colliding with a "
                "numbered sequence's base name."
            )
        seen_ids.add(group.asset_id)

    return groups


def discover_and_group(config: PipelineConfig) -> list[AssetGroup]:
    """The public entry point: discovery + hashing + grouping in one call."""
    images = discover_source_images(config)
    return group_into_assets(images)
