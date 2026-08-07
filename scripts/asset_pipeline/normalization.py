"""Pure-numpy image normalization helpers — no file I/O.

Kept separate from image_io.py so the array math itself (mode
conversion, blank-frame detection) is testable without touching disk,
per research principle 3 (small, independently testable functions) and
principle 1 (vectorized numpy over per-pixel Python loops).
"""

from __future__ import annotations

import numpy as np
from PIL import Image


def to_rgba_array(image: Image.Image) -> np.ndarray:
    """Normalizes any Pillow image mode to a ``(height, width, 4)`` uint8
    RGBA numpy array."""
    if image.mode != "RGBA":
        image = image.convert("RGBA")
    return np.asarray(image, dtype=np.uint8)


def is_blank(pixels: np.ndarray) -> bool:
    """True if every pixel is fully transparent (alpha 0 everywhere) — a
    single vectorized reduction, no per-pixel Python loop."""
    return bool(pixels[..., 3].max() == 0)
