"""Deterministic sprite packing.

Uses **shelf packing**: frames are placed left-to-right filling
horizontal "shelves" of a working canvas bounded by ``max_atlas_size``,
wrapping to a new shelf when the current one is full. It is not the most
space-efficient algorithm possible (MaxRects/skyline pack tighter), but
it is simple, easy to reason about, and — critically — trivially
deterministic: frames are sorted by a fixed, total key
(``-height, -width, asset_id``) before placement, so identical input
always produces an identical layout, satisfying the pipeline's
determinism guarantee.

The atlas pixel buffer is **allocated exactly once** (research principle
2): a dry-run layout pass first computes the exact required size, then
``np.zeros((height, width, 4), uint8)`` is created a single time and
every frame is blitted directly into it — no repeated concatenation or
resizing.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np

from .models import AtlasSizeExceededError, DecodedFrame, PackedFrame, TrimResult


@dataclass(frozen=True, slots=True)
class _ShelfLayout:
    atlas_width: int
    atlas_height: int
    placements: tuple[tuple[int, int], ...]  # (x, y) per frame, input order


def _sort_key(pair: tuple[DecodedFrame, TrimResult]) -> tuple[int, int, str]:
    frame, trim = pair
    return -trim.height, -trim.width, frame.source.id


def _check_single_frame_fits(
    trim: TrimResult, *, padding: int, max_atlas_size: int, asset_id: str
) -> None:
    if trim.width + 2 * padding > max_atlas_size or trim.height + 2 * padding > max_atlas_size:
        raise AtlasSizeExceededError(
            f"Frame '{asset_id}' is {trim.width}x{trim.height}px "
            f"(plus {padding}px padding on each side) — larger than the "
            f"configured max atlas size of {max_atlas_size}px on its own."
        )


def _shelf_layout(
    ordered: list[tuple[DecodedFrame, TrimResult]], *, padding: int, max_atlas_size: int
) -> _ShelfLayout:
    x = padding
    y = padding
    shelf_height = 0
    max_x = 0
    placements: list[tuple[int, int]] = []

    for frame, trim in ordered:
        _check_single_frame_fits(
            trim, padding=padding, max_atlas_size=max_atlas_size, asset_id=frame.source.id
        )
        advance = trim.width + padding
        if x > padding and x + trim.width + padding > max_atlas_size:
            # This shelf is full — wrap to a new one below it.
            x = padding
            y += shelf_height + padding
            shelf_height = 0

        placements.append((x, y))
        max_x = max(max_x, x + trim.width + padding)
        shelf_height = max(shelf_height, trim.height)
        x += advance

    atlas_height = y + shelf_height + padding
    return _ShelfLayout(
        atlas_width=max_x, atlas_height=atlas_height, placements=tuple(placements)
    )


def _blit(atlas: np.ndarray, pixels: np.ndarray, x: int, y: int, *, extrusion: int) -> None:
    """Copies ``pixels`` into ``atlas`` at ``(x, y)``, then replicates its
    edge pixels outward into the padding by ``extrusion`` rings (reduces
    texture-sampling bleed at frame borders) — vectorized numpy slice
    assignments, one per extrusion ring, not a per-pixel loop."""
    height, width = pixels.shape[:2]
    atlas[y : y + height, x : x + width, :] = pixels

    for ring in range(1, extrusion + 1):
        if y - ring >= 0:
            atlas[y - ring, x : x + width, :] = pixels[0, :, :]
        if y + height - 1 + ring < atlas.shape[0]:
            atlas[y + height - 1 + ring, x : x + width, :] = pixels[-1, :, :]
        if x - ring >= 0:
            atlas[y : y + height, x - ring, :] = pixels[:, 0, :]
        if x + width - 1 + ring < atlas.shape[1]:
            atlas[y : y + height, x + width - 1 + ring, :] = pixels[:, -1, :]


def pack_frames(
    frames: list[tuple[DecodedFrame, TrimResult]],
    *,
    padding: int,
    extrusion: int,
    max_atlas_size: int,
) -> tuple[np.ndarray, list[PackedFrame]]:
    """Packs every ``(DecodedFrame, TrimResult)`` pair into one atlas.

    Returns the preallocated atlas pixel buffer and one [PackedFrame] per
    input frame, in the *original input order* (not the internal packing
    order) so callers can zip results back against their own frame lists.
    """
    if not frames:
        return np.zeros((0, 0, 4), dtype=np.uint8), []

    ordered = sorted(frames, key=_sort_key)
    layout = _shelf_layout(ordered, padding=padding, max_atlas_size=max_atlas_size)

    if layout.atlas_height > max_atlas_size:
        raise AtlasSizeExceededError(
            f"Packed atlas would be {layout.atlas_width}x{layout.atlas_height}px, "
            f"exceeding the configured max of {max_atlas_size}px."
        )

    atlas = np.zeros((layout.atlas_height, layout.atlas_width, 4), dtype=np.uint8)

    packed_by_id: dict[str, PackedFrame] = {}
    for (frame, trim), (x, y) in zip(ordered, layout.placements, strict=True):
        _blit(atlas, trim.pixels, x, y, extrusion=extrusion)
        packed_by_id[frame.source.id] = PackedFrame(
            source=frame.source,
            atlas_x=x,
            atlas_y=y,
            atlas_width=trim.width,
            atlas_height=trim.height,
            original_width=frame.original_width,
            original_height=frame.original_height,
            trimmed_offset_x=trim.offset_x,
            trimmed_offset_y=trim.offset_y,
        )

    return atlas, [packed_by_id[frame.source.id] for frame, _ in frames]
