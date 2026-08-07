"""Tests for scripts.asset_pipeline.packing."""

from __future__ import annotations

import unittest
from pathlib import Path

import numpy as np

from scripts.asset_pipeline import packing
from scripts.asset_pipeline.models import AtlasSizeExceededError, DecodedFrame, SourceImage, TrimResult


def _pair(asset_id: str, width: int, height: int, color=(1, 2, 3, 255)):
    pixels = np.full((height, width, 4), color, dtype=np.uint8)
    source = SourceImage(id=asset_id, path=Path(f"{asset_id}.png"), sha256=f"hash-{asset_id}")
    frame = DecodedFrame(
        source=source, pixels=pixels, original_width=width, original_height=height
    )
    trim = TrimResult(pixels=pixels, offset_x=0, offset_y=0, width=width, height=height)
    return frame, trim


def _rects(packed_frames) -> list[tuple[int, int, int, int]]:
    return [
        (f.atlas_x, f.atlas_y, f.atlas_width, f.atlas_height) for f in packed_frames
    ]


def _overlaps(a, b) -> bool:
    ax, ay, aw, ah = a
    bx, by, bw, bh = b
    return not (ax + aw <= bx or bx + bw <= ax or ay + ah <= by or by + bh <= ay)


class PackFramesTests(unittest.TestCase):
    def test_empty_input_returns_empty_atlas(self):
        atlas, packed = packing.pack_frames([], padding=2, extrusion=0, max_atlas_size=256)
        self.assertEqual(atlas.shape, (0, 0, 4))
        self.assertEqual(packed, [])

    def test_atlas_buffer_is_allocated_to_the_exact_required_size(self):
        frames = [_pair("a", 10, 10), _pair("b", 10, 10)]
        atlas, packed = packing.pack_frames(frames, padding=0, extrusion=0, max_atlas_size=64)
        # Both 10x10 fit on one shelf: width 20, height 10 (no padding).
        self.assertEqual(atlas.shape, (10, 20, 4))

    def test_no_two_packed_frames_overlap(self):
        frames = [_pair(f"f{i}", 5 + i, 7, color=(i, i, i, 255)) for i in range(12)]
        _, packed = packing.pack_frames(frames, padding=1, extrusion=0, max_atlas_size=64)
        rects = _rects(packed)
        for i in range(len(rects)):
            for j in range(i + 1, len(rects)):
                self.assertFalse(
                    _overlaps(rects[i], rects[j]),
                    f"rects overlap: {rects[i]} vs {rects[j]}",
                )

    def test_results_are_returned_in_original_input_order(self):
        frames = [_pair("zebra", 4, 4), _pair("alpha", 20, 20), _pair("mango", 8, 8)]
        _, packed = packing.pack_frames(frames, padding=1, extrusion=0, max_atlas_size=64)
        self.assertEqual([p.source.id for p in packed], ["zebra", "alpha", "mango"])

    def test_identical_input_produces_identical_layout_and_pixels(self):
        frames = [_pair(f"f{i}", 6, 4 + i % 3) for i in range(9)]
        atlas1, packed1 = packing.pack_frames(
            frames, padding=2, extrusion=1, max_atlas_size=128
        )
        atlas2, packed2 = packing.pack_frames(
            frames, padding=2, extrusion=1, max_atlas_size=128
        )
        np.testing.assert_array_equal(atlas1, atlas2)
        self.assertEqual(_rects(packed1), _rects(packed2))

    def test_padding_is_respected_between_shelves(self):
        # Each 9px-wide frame comfortably fits alone (9 + 2*2 = 13 <= 20),
        # but two side by side (24) don't, forcing a wrap to a new shelf.
        frames = [_pair("a", 9, 5), _pair("b", 9, 5)]
        _, packed = packing.pack_frames(frames, padding=2, extrusion=0, max_atlas_size=20)
        a, b = packed
        self.assertGreaterEqual(b.atlas_y, a.atlas_y + a.atlas_height + 2)

    def test_extrusion_replicates_edge_pixels_into_padding(self):
        frame, trim = _pair("solo", 4, 4, color=(9, 8, 7, 255))
        atlas, packed = packing.pack_frames(
            [(frame, trim)], padding=2, extrusion=1, max_atlas_size=64
        )
        p = packed[0]
        # One pixel directly left of the frame should carry the frame's
        # left-edge colour, not the zeroed background.
        extruded_pixel = atlas[p.atlas_y, p.atlas_x - 1]
        self.assertTrue(np.array_equal(extruded_pixel, [9, 8, 7, 255]))

    def test_single_frame_larger_than_max_size_fails(self):
        frames = [_pair("huge", 300, 300)]
        with self.assertRaises(AtlasSizeExceededError):
            packing.pack_frames(frames, padding=2, extrusion=0, max_atlas_size=256)

    def test_too_many_frames_to_fit_within_max_size_fails(self):
        frames = [_pair(f"f{i}", 30, 30) for i in range(200)]
        with self.assertRaises(AtlasSizeExceededError):
            packing.pack_frames(frames, padding=1, extrusion=0, max_atlas_size=64)


if __name__ == "__main__":
    unittest.main()
