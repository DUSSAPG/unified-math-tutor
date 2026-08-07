"""Tests for scripts.asset_pipeline.image_io and normalization."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

from scripts.asset_pipeline import image_io, normalization
from scripts.asset_pipeline.models import BlankFrameError, SourceImage, UnreadableImageError


class NormalizationTests(unittest.TestCase):
    def test_to_rgba_array_converts_rgb_to_rgba(self):
        image = Image.new("RGB", (3, 2), (10, 20, 30))
        array = normalization.to_rgba_array(image)
        self.assertEqual(array.shape, (2, 3, 4))
        self.assertTrue(np.all(array[..., 3] == 255))

    def test_to_rgba_array_leaves_alpha_untouched(self):
        image = Image.new("RGBA", (2, 2), (1, 2, 3, 128))
        array = normalization.to_rgba_array(image)
        self.assertTrue(np.all(array[..., 3] == 128))

    def test_is_blank_true_for_fully_transparent(self):
        array = np.zeros((4, 4, 4), dtype=np.uint8)
        self.assertTrue(normalization.is_blank(array))

    def test_is_blank_false_when_any_pixel_has_alpha(self):
        array = np.zeros((4, 4, 4), dtype=np.uint8)
        array[2, 2, 3] = 1
        self.assertFalse(normalization.is_blank(array))


class LoadFrameTests(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)

    def _source(self, name: str) -> SourceImage:
        return SourceImage(id=name, path=self.root / name, sha256="deadbeef")

    def test_decodes_a_valid_frame(self):
        path = self.root / "ok.png"
        Image.new("RGBA", (5, 3), (9, 9, 9, 255)).save(path)
        frame = image_io.load_frame(self._source("ok.png"))
        self.assertEqual(frame.original_width, 5)
        self.assertEqual(frame.original_height, 3)
        self.assertEqual(frame.pixels.shape, (3, 5, 4))

    def test_unreadable_file_raises(self):
        path = self.root / "bad.png"
        path.write_bytes(b"not a real png")
        with self.assertRaises(UnreadableImageError):
            image_io.load_frame(self._source("bad.png"))

    def test_missing_file_raises_unreadable(self):
        with self.assertRaises(UnreadableImageError):
            image_io.load_frame(self._source("missing.png"))

    def test_blank_frame_raises(self):
        path = self.root / "blank.png"
        Image.new("RGBA", (4, 4), (0, 0, 0, 0)).save(path)
        with self.assertRaises(BlankFrameError):
            image_io.load_frame(self._source("blank.png"))

    def test_iter_frames_yields_lazily_and_propagates_errors(self):
        Image.new("RGBA", (2, 2), (1, 1, 1, 255)).save(self.root / "good.png")
        (self.root / "bad.png").write_bytes(b"garbage")
        sources = [self._source("good.png"), self._source("bad.png")]

        results = image_io.iter_frames(sources)
        first = next(results)
        self.assertEqual(first.source.id, "good.png")
        with self.assertRaises(UnreadableImageError):
            next(results)


if __name__ == "__main__":
    unittest.main()
