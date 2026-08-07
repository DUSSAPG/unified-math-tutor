"""Independent, pure validation checks over packed frames and manifests.

Every check returns a ``list[str]`` of human-readable violation messages
(empty means "passed") rather than raising directly — callers (``cli.py``,
tests) decide whether a violation is fatal. This keeps each check a small,
independently testable function (research principle 3).
"""

from __future__ import annotations

from collections.abc import Sequence
from typing import Any

from .models import PackedFrame


def check_no_overlaps(packed: Sequence[PackedFrame]) -> list[str]:
    """Sweep-line overlap check (O(n log n), not O(n^2)): sorts by atlas x,
    keeps an "active" set of frames whose x-extent still spans the sweep
    position, and checks only those for a y-overlap."""
    indexed = list(enumerate(packed))
    indexed.sort(key=lambda pair: pair[1].atlas_x)

    active: list[tuple[int, PackedFrame]] = []
    violations: list[str] = []
    for index, frame in indexed:
        active = [
            (i, f) for i, f in active if f.atlas_x + f.atlas_width > frame.atlas_x
        ]
        for other_index, other in active:
            y_overlaps = not (
                frame.atlas_y + frame.atlas_height <= other.atlas_y
                or other.atlas_y + other.atlas_height <= frame.atlas_y
            )
            if y_overlaps:
                violations.append(
                    f"Atlas frames '{other.source.id}' and '{frame.source.id}' overlap."
                )
        active.append((index, frame))
    return violations


def check_within_atlas_bounds(
    atlas_width: int, atlas_height: int, packed: Sequence[PackedFrame]
) -> list[str]:
    violations = []
    for frame in packed:
        if (
            frame.atlas_x < 0
            or frame.atlas_y < 0
            or frame.atlas_x + frame.atlas_width > atlas_width
            or frame.atlas_y + frame.atlas_height > atlas_height
        ):
            violations.append(
                f"Frame '{frame.source.id}' at "
                f"({frame.atlas_x}, {frame.atlas_y}, {frame.atlas_width}, "
                f"{frame.atlas_height}) falls outside the "
                f"{atlas_width}x{atlas_height}px atlas."
            )
    return violations


def check_max_size(
    atlas_width: int, atlas_height: int, max_atlas_size: int
) -> list[str]:
    violations = []
    if atlas_width > max_atlas_size:
        violations.append(
            f"Atlas width {atlas_width}px exceeds the configured max of "
            f"{max_atlas_size}px."
        )
    if atlas_height > max_atlas_size:
        violations.append(
            f"Atlas height {atlas_height}px exceeds the configured max of "
            f"{max_atlas_size}px."
        )
    return violations


_REQUIRED_TOP_LEVEL: dict[str, type] = {
    "schemaVersion": int,
    "atlasId": str,
    "atlasFile": str,
    "atlasWidth": int,
    "atlasHeight": int,
    "contentVersion": int,
    "animations": list,
}

_REQUIRED_ANIMATION: dict[str, type] = {
    "assetId": str,
    "sourceFiles": list,
    "sourceHashes": list,
    "atlasFile": str,
    "anchor": dict,
    "frameDurationMs": int,
    "loop": str,
    "reducedMotionFallbackFrame": int,
    "contentVersion": int,
    "verified": bool,
    "frames": list,
}

_REQUIRED_FRAME: dict[str, type] = {
    "sourceFile": str,
    "sourceHash": str,
    "x": int,
    "y": int,
    "width": int,
    "height": int,
    "originalWidth": int,
    "originalHeight": int,
    "trimmedOffsetX": int,
    "trimmedOffsetY": int,
}


def _check_fields(obj: Any, required: dict[str, type], where: str) -> list[str]:
    violations = []
    if not isinstance(obj, dict):
        return [f"{where} must be an object."]
    for key, expected_type in required.items():
        if key not in obj:
            violations.append(f"{where} is missing required field '{key}'.")
            continue
        value = obj[key]
        # bool is a subclass of int in Python — only accept it where the
        # schema actually wants a bool.
        if expected_type is int and isinstance(value, bool):
            violations.append(f"{where} field '{key}' must be an int, got bool.")
        elif not isinstance(value, expected_type):
            violations.append(
                f"{where} field '{key}' must be {expected_type.__name__}, "
                f"got {type(value).__name__}."
            )
    return violations


def validate_manifest_schema(data: Any) -> list[str]:
    """Hand-rolled required-field/type validation against the atlas JSON
    schema — mirrors the fail-fast style already used by
    ``lib/models/visual_asset.dart``'s ``fromJson`` rather than adding a
    ``jsonschema`` dependency for one schema."""
    violations = _check_fields(data, _REQUIRED_TOP_LEVEL, "manifest")
    if violations:
        return violations

    for i, animation in enumerate(data["animations"]):
        where = f"animations[{i}]"
        violations.extend(_check_fields(animation, _REQUIRED_ANIMATION, where))
        if not isinstance(animation, dict):
            continue
        frames = animation.get("frames")
        if isinstance(frames, list):
            for j, frame in enumerate(frames):
                violations.extend(
                    _check_fields(frame, _REQUIRED_FRAME, f"{where}.frames[{j}]")
                )
    return violations
