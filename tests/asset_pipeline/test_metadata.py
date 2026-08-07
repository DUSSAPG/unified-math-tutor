"""Tests for scripts.asset_pipeline.metadata."""

from __future__ import annotations

import unittest
from pathlib import Path

from scripts.asset_pipeline import metadata, validation
from scripts.asset_pipeline.models import AssetGroup, LoopMode, PackedFrame, PipelineConfig, SourceImage


def _config(source: Path) -> PipelineConfig:
    return PipelineConfig(
        source=source,
        output=source.parent / "out",
        atlas_id="test_atlas",
        frame_duration_ms=80,
        loop=LoopMode.PING_PONG,
        content_version=3,
        anchor_x=0.25,
        anchor_y=0.75,
    )


def _packed(image: SourceImage, x: int) -> PackedFrame:
    return PackedFrame(
        source=image,
        atlas_x=x,
        atlas_y=0,
        atlas_width=4,
        atlas_height=4,
        original_width=6,
        original_height=6,
        trimmed_offset_x=1,
        trimmed_offset_y=1,
    )


class BuildAnimationRecordsTests(unittest.TestCase):
    def setUp(self):
        self.source_root = Path("/fake/src")
        self.image1 = SourceImage(
            id="kick_01",
            path=self.source_root / "kick_01.png",
            sha256="hash1",
        )
        self.image2 = SourceImage(
            id="kick_02",
            path=self.source_root / "kick_02.png",
            sha256="hash2",
        )
        self.groups = [AssetGroup(asset_id="kick", images=(self.image1, self.image2))]
        self.packed_by_id = {
            "kick_01": _packed(self.image1, x=0),
            "kick_02": _packed(self.image2, x=10),
        }

    def test_one_record_per_group_with_frames_in_group_order(self):
        records = metadata.build_animation_records(
            self.groups,
            self.packed_by_id,
            atlas_file="test_atlas.png",
            config=_config(self.source_root),
        )
        self.assertEqual(len(records), 1)
        record = records[0]
        self.assertEqual(record.asset_id, "kick")
        self.assertEqual(len(record.frames), 2)
        self.assertEqual(record.frames[0].source_file, "kick_01.png")
        self.assertEqual(record.frames[1].source_file, "kick_02.png")

    def test_config_values_flow_into_the_record(self):
        records = metadata.build_animation_records(
            self.groups,
            self.packed_by_id,
            atlas_file="test_atlas.png",
            config=_config(self.source_root),
        )
        record = records[0]
        self.assertEqual(record.frame_duration_ms, 80)
        self.assertEqual(record.loop, LoopMode.PING_PONG)
        self.assertEqual(record.content_version, 3)
        self.assertEqual((record.anchor_x, record.anchor_y), (0.25, 0.75))
        self.assertFalse(record.verified)

    def test_source_files_and_hashes_properties(self):
        records = metadata.build_animation_records(
            self.groups,
            self.packed_by_id,
            atlas_file="test_atlas.png",
            config=_config(self.source_root),
        )
        record = records[0]
        self.assertEqual(record.source_files, ("kick_01.png", "kick_02.png"))
        self.assertEqual(record.source_hashes, ("hash1", "hash2"))


class MarkVerifiedTests(unittest.TestCase):
    def test_does_not_mutate_the_original_list(self):
        source_root = Path("/fake/src")
        image = SourceImage(id="ball", path=source_root / "ball.png", sha256="h")
        groups = [AssetGroup(asset_id="ball", images=(image,))]
        packed = {"ball": _packed(image, x=0)}
        records = metadata.build_animation_records(
            groups, packed, atlas_file="a.png", config=_config(source_root)
        )
        verified_records = metadata.mark_verified(records, verified=True)

        self.assertFalse(records[0].verified)
        self.assertTrue(verified_records[0].verified)


class AtlasToJsonTests(unittest.TestCase):
    def setUp(self):
        source_root = Path("/fake/src")
        image = SourceImage(id="ball", path=source_root / "ball.png", sha256="h")
        groups = [AssetGroup(asset_id="ball", images=(image,))]
        packed = {"ball": _packed(image, x=0)}
        self.records = metadata.mark_verified(
            metadata.build_animation_records(
                groups, packed, atlas_file="a.png", config=_config(source_root)
            ),
            verified=True,
        )

    def test_produces_a_schema_valid_manifest(self):
        data = metadata.atlas_to_json(
            atlas_id="test_atlas",
            atlas_file="a.png",
            atlas_width=32,
            atlas_height=32,
            content_version=1,
            animations=self.records,
        )
        self.assertEqual(validation.validate_manifest_schema(data), [])

    def test_json_string_is_deterministic(self):
        kwargs = dict(
            atlas_id="test_atlas",
            atlas_file="a.png",
            atlas_width=32,
            atlas_height=32,
            content_version=1,
            animations=self.records,
        )
        first = metadata.atlas_to_json_string(**kwargs)
        second = metadata.atlas_to_json_string(**kwargs)
        self.assertEqual(first, second)


if __name__ == "__main__":
    unittest.main()
