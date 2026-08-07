"""Tests for scripts.asset_pipeline.validation."""

from __future__ import annotations

import unittest
from pathlib import Path

from scripts.asset_pipeline import validation
from scripts.asset_pipeline.models import PackedFrame, SourceImage


def _frame(asset_id: str, x: int, y: int, w: int, h: int) -> PackedFrame:
    return PackedFrame(
        source=SourceImage(id=asset_id, path=Path(f"{asset_id}.png"), sha256="h"),
        atlas_x=x,
        atlas_y=y,
        atlas_width=w,
        atlas_height=h,
        original_width=w,
        original_height=h,
        trimmed_offset_x=0,
        trimmed_offset_y=0,
    )


class CheckNoOverlapsTests(unittest.TestCase):
    def test_non_overlapping_frames_pass(self):
        frames = [_frame("a", 0, 0, 10, 10), _frame("b", 10, 0, 10, 10)]
        self.assertEqual(validation.check_no_overlaps(frames), [])

    def test_x_overlap_with_y_overlap_is_detected(self):
        frames = [_frame("a", 0, 0, 10, 10), _frame("b", 5, 5, 10, 10)]
        violations = validation.check_no_overlaps(frames)
        self.assertEqual(len(violations), 1)
        self.assertIn("a", violations[0])
        self.assertIn("b", violations[0])

    def test_x_overlap_but_no_y_overlap_passes(self):
        frames = [_frame("a", 0, 0, 10, 10), _frame("b", 5, 10, 10, 10)]
        self.assertEqual(validation.check_no_overlaps(frames), [])

    def test_many_frames_no_false_positives(self):
        frames = [_frame(f"f{i}", i * 12, 0, 10, 10) for i in range(20)]
        self.assertEqual(validation.check_no_overlaps(frames), [])


class CheckWithinAtlasBoundsTests(unittest.TestCase):
    def test_frame_within_bounds_passes(self):
        frames = [_frame("a", 0, 0, 10, 10)]
        self.assertEqual(validation.check_within_atlas_bounds(20, 20, frames), [])

    def test_frame_exceeding_bounds_fails(self):
        frames = [_frame("a", 15, 0, 10, 10)]
        violations = validation.check_within_atlas_bounds(20, 20, frames)
        self.assertEqual(len(violations), 1)


class CheckMaxSizeTests(unittest.TestCase):
    def test_within_limit_passes(self):
        self.assertEqual(validation.check_max_size(100, 100, 200), [])

    def test_exceeding_width_fails(self):
        self.assertEqual(len(validation.check_max_size(300, 100, 200)), 1)

    def test_exceeding_both_dimensions_reports_both(self):
        self.assertEqual(len(validation.check_max_size(300, 300, 200)), 2)


_VALID_MANIFEST = {
    "schemaVersion": 1,
    "atlasId": "test",
    "atlasFile": "test.png",
    "atlasWidth": 10,
    "atlasHeight": 10,
    "contentVersion": 1,
    "animations": [
        {
            "assetId": "ball",
            "sourceFiles": ["ball.png"],
            "sourceHashes": ["abc"],
            "atlasFile": "test.png",
            "anchor": {"x": 0.5, "y": 0.5},
            "frameDurationMs": 100,
            "loop": "once",
            "reducedMotionFallbackFrame": 0,
            "contentVersion": 1,
            "verified": True,
            "frames": [
                {
                    "sourceFile": "ball.png",
                    "sourceHash": "abc",
                    "x": 0,
                    "y": 0,
                    "width": 4,
                    "height": 4,
                    "originalWidth": 4,
                    "originalHeight": 4,
                    "trimmedOffsetX": 0,
                    "trimmedOffsetY": 0,
                }
            ],
        }
    ],
}


class ValidateManifestSchemaTests(unittest.TestCase):
    def test_valid_manifest_has_no_violations(self):
        self.assertEqual(validation.validate_manifest_schema(_VALID_MANIFEST), [])

    def test_missing_top_level_field_is_reported(self):
        broken = {k: v for k, v in _VALID_MANIFEST.items() if k != "atlasWidth"}
        violations = validation.validate_manifest_schema(broken)
        self.assertTrue(any("atlasWidth" in v for v in violations))

    def test_wrong_type_is_reported(self):
        import copy

        broken = copy.deepcopy(_VALID_MANIFEST)
        broken["atlasWidth"] = "ten"
        violations = validation.validate_manifest_schema(broken)
        self.assertTrue(any("atlasWidth" in v for v in violations))

    def test_bool_is_not_accepted_as_int(self):
        import copy

        broken = copy.deepcopy(_VALID_MANIFEST)
        broken["atlasWidth"] = True
        violations = validation.validate_manifest_schema(broken)
        self.assertTrue(any("atlasWidth" in v for v in violations))

    def test_missing_frame_field_is_reported(self):
        import copy

        broken = copy.deepcopy(_VALID_MANIFEST)
        del broken["animations"][0]["frames"][0]["width"]
        violations = validation.validate_manifest_schema(broken)
        self.assertTrue(any("frames[0]" in v and "width" in v for v in violations))

    def test_non_dict_manifest_is_reported(self):
        self.assertNotEqual(validation.validate_manifest_schema("not a dict"), [])


if __name__ == "__main__":
    unittest.main()
