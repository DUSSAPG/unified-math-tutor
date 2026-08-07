"""Tests for scripts.asset_pipeline.trimming."""

from __future__ import annotations

import unittest
from pathlib import Path

import numpy as np

from scripts.asset_pipeline import trimming
from scripts.asset_pipeline.models import DecodedFrame, SourceImage


def _frame(pixels: np.ndarray) -> DecodedFrame:
    height, width = pixels.shape[:2]
    source = SourceImage(id="x", path=Path("x.png"), sha256="hash")
    return DecodedFrame(
        source=source, pixels=pixels, original_width=width, original_height=height
    )


def _canvas(height: int, width: int) -> np.ndarray:
    return np.zeros((height, width, 4), dtype=np.uint8)


class TrimTransparentBorderTests(unittest.TestCase):
    def test_trims_a_symmetric_border(self):
        canvas = _canvas(10, 10)
        canvas[3:6, 4:7, :] = (255, 0, 0, 255)  # a 3x3 opaque block
        result = trimming.trim_transparent_border(_frame(canvas))

        self.assertEqual((result.height, result.width), (3, 3))
        self.assertEqual((result.offset_y, result.offset_x), (3, 4))
        self.assertTrue(np.all(result.pixels[..., 3] == 255))

    def test_no_transparent_border_returns_the_same_content_untouched(self):
        canvas = _canvas(4, 4)
        canvas[:, :, :] = (1, 2, 3, 255)
        result = trimming.trim_transparent_border(_frame(canvas))

        self.assertEqual((result.height, result.width), (4, 4))
        self.assertEqual((result.offset_y, result.offset_x), (0, 0))
        np.testing.assert_array_equal(result.pixels, canvas)

    def test_asymmetric_border_trims_correctly(self):
        canvas = _canvas(20, 30)
        canvas[1:2, 25:26, :] = (0, 255, 0, 255)  # a single opaque pixel
        result = trimming.trim_transparent_border(_frame(canvas))

        self.assertEqual((result.height, result.width), (1, 1))
        self.assertEqual((result.offset_y, result.offset_x), (1, 25))


class MaybeTrimTests(unittest.TestCase):
    def test_trim_false_returns_full_frame_with_zero_offset(self):
        canvas = _canvas(8, 8)
        canvas[3:5, 3:5, :] = (9, 9, 9, 255)
        result = trimming.maybe_trim(_frame(canvas), trim=False)

        self.assertEqual((result.height, result.width), (8, 8))
        self.assertEqual((result.offset_y, result.offset_x), (0, 0))

    def test_trim_true_delegates_to_trim_transparent_border(self):
        canvas = _canvas(8, 8)
        canvas[3:5, 3:5, :] = (9, 9, 9, 255)
        result = trimming.maybe_trim(_frame(canvas), trim=True)
        self.assertEqual((result.height, result.width), (2, 2))


class AnchorInTrimmedTests(unittest.TestCase):
    def test_centre_anchor_survives_trimming(self):
        canvas = _canvas(10, 10)
        canvas[2:8, 2:8, :] = (1, 1, 1, 255)  # 6x6 block, centred at (5,5)
        trim = trimming.trim_transparent_border(_frame(canvas))

        anchor_x, anchor_y = trimming.anchor_in_trimmed(
            original_width=10,
            original_height=10,
            anchor_x=0.5,
            anchor_y=0.5,
            trim=trim,
        )
        # Original centre (5, 5) minus the trim offset (2, 2).
        self.assertAlmostEqual(anchor_x, 3.0)
        self.assertAlmostEqual(anchor_y, 3.0)

    def test_untrimmed_frame_anchor_is_unchanged(self):
        canvas = _canvas(4, 4)
        canvas[:, :, :] = (1, 1, 1, 255)
        trim = trimming.maybe_trim(_frame(canvas), trim=False)

        anchor_x, anchor_y = trimming.anchor_in_trimmed(
            original_width=4, original_height=4, anchor_x=0.25, anchor_y=0.75, trim=trim
        )
        self.assertAlmostEqual(anchor_x, 1.0)
        self.assertAlmostEqual(anchor_y, 3.0)


if __name__ == "__main__":
    unittest.main()
