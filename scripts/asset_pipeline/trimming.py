"""Vectorized transparent-border trimming.

The bounding box of visible (alpha > 0) pixels is found with two
reductions (``np.any`` along each axis) instead of a per-pixel Python
loop — research principle 1.
"""

from __future__ import annotations

import numpy as np

from .models import DecodedFrame, TrimResult


def trim_transparent_border(frame: DecodedFrame) -> TrimResult:
    """Trims fully-transparent rows/columns from the edges of ``frame``.

    Callers reject fully-blank frames upstream
    (``image_io.load_frame`` → ``BlankFrameError``), so this never has to
    handle "no visible pixels at all" itself.
    """
    alpha = frame.pixels[..., 3]
    rows = np.any(alpha, axis=1)
    cols = np.any(alpha, axis=0)

    row_indices = np.flatnonzero(rows)
    col_indices = np.flatnonzero(cols)
    top, bottom = int(row_indices[0]), int(row_indices[-1])
    left, right = int(col_indices[0]), int(col_indices[-1])

    trimmed = frame.pixels[top : bottom + 1, left : right + 1, :]
    height, width = trimmed.shape[:2]
    return TrimResult(
        pixels=trimmed, offset_x=left, offset_y=top, width=width, height=height
    )


def maybe_trim(frame: DecodedFrame, *, trim: bool) -> TrimResult:
    """Applies [trim_transparent_border] when ``trim`` is true; otherwise
    returns a [TrimResult] wrapping the untouched original frame (offset
    ``0, 0``) — downstream callers never need their own ``if trim:``
    branch."""
    if not trim:
        height, width = frame.pixels.shape[:2]
        return TrimResult(
            pixels=frame.pixels, offset_x=0, offset_y=0, width=width, height=height
        )
    return trim_transparent_border(frame)


def anchor_in_trimmed(
    *,
    original_width: int,
    original_height: int,
    anchor_x: float,
    anchor_y: float,
    trim: TrimResult,
) -> tuple[float, float]:
    """The anchor point's pixel position *within the trimmed frame*.

    Recovered from the trim-invariant anchor fraction stored against the
    *original* frame size (see the anchor convention documented in
    ``models.py``): ``anchor_px_original - trim_offset``.
    """
    anchor_px_x = anchor_x * original_width
    anchor_px_y = anchor_y * original_height
    return anchor_px_x - trim.offset_x, anchor_px_y - trim.offset_y
