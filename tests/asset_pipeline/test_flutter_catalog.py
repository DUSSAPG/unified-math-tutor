"""Tests for scripts.asset_pipeline.flutter_catalog."""

from __future__ import annotations

import unittest
from pathlib import Path

from scripts.asset_pipeline import flutter_catalog, metadata
from scripts.asset_pipeline.models import AssetGroup, LoopMode, PackedFrame, PipelineConfig, SourceImage


def _config(source: Path) -> PipelineConfig:
    return PipelineConfig(source=source, output=source.parent / "out", atlas_id="football_core")


def _sample_animations() -> list:
    source_root = Path("/fake/src")
    image1 = SourceImage(id="kick_01", path=source_root / "kick_01.png", sha256="hash1")
    image2 = SourceImage(id="kick_02", path=source_root / "kick_02.png", sha256="hash2")
    groups = [AssetGroup(asset_id="kick", images=(image1, image2))]
    packed = {
        "kick_01": PackedFrame(
            source=image1, atlas_x=0, atlas_y=0, atlas_width=4, atlas_height=4,
            original_width=6, original_height=6, trimmed_offset_x=1, trimmed_offset_y=1,
        ),
        "kick_02": PackedFrame(
            source=image2, atlas_x=10, atlas_y=0, atlas_width=4, atlas_height=4,
            original_width=6, original_height=6, trimmed_offset_x=1, trimmed_offset_y=1,
        ),
    }
    return metadata.mark_verified(
        metadata.build_animation_records(
            groups, packed, atlas_file="football_core.png", config=_config(source_root)
        ),
        verified=True,
    )


class DartConstNameTests(unittest.TestCase):
    def test_snake_case_becomes_lower_camel_case_plus_atlas(self):
        self.assertEqual(flutter_catalog.dart_const_name("football_core"), "footballCoreAtlas")

    def test_single_word_ids(self):
        self.assertEqual(flutter_catalog.dart_const_name("football"), "footballAtlas")


class GenerateDartCatalogTests(unittest.TestCase):
    def setUp(self):
        self.animations = _sample_animations()

    def _generate(self) -> str:
        return flutter_catalog.generate_dart_catalog(
            atlas_id="football_core",
            atlas_file="assets/generated/football/football_core.png",
            manifest_file="assets/generated/football/football_core.json",
            animations=self.animations,
        )

    def test_output_is_deterministic(self):
        first = self._generate()
        second = self._generate()
        self.assertEqual(first, second)

    def test_contains_the_generated_file_marker(self):
        dart = self._generate()
        self.assertIn("GENERATED FILE - DO NOT EDIT BY HAND", dart)

    def test_imports_the_shared_seam_types_not_redeclaring_them(self):
        dart = self._generate()
        self.assertIn(
            "import 'package:unified_math_tutor/models/sprite_atlas.dart';", dart
        )
        self.assertNotIn("class SpriteAtlas", dart)

    def test_declares_the_expected_const_name(self):
        dart = self._generate()
        self.assertIn("const footballCoreAtlas = SpriteAtlas(", dart)

    def test_includes_every_frame_and_asset_id(self):
        dart = self._generate()
        self.assertIn("assetId: 'kick'", dart)
        self.assertIn("sourceFile: 'kick_01.png'", dart)
        self.assertIn("sourceFile: 'kick_02.png'", dart)

    def test_single_quotes_in_ids_are_escaped(self):
        source_root = Path("/fake/src")
        image = SourceImage(id="tom's_hat", path=source_root / "tom's_hat.png", sha256="h")
        groups = [AssetGroup(asset_id="tom's_hat", images=(image,))]
        packed = {
            "tom's_hat": PackedFrame(
                source=image, atlas_x=0, atlas_y=0, atlas_width=2, atlas_height=2,
                original_width=2, original_height=2, trimmed_offset_x=0, trimmed_offset_y=0,
            )
        }
        animations = metadata.build_animation_records(
            groups, packed, atlas_file="a.png", config=_config(source_root)
        )
        dart = flutter_catalog.generate_dart_catalog(
            atlas_id="a", atlas_file="a.png", manifest_file="a.json", animations=animations
        )
        self.assertIn("tom\\'s_hat", dart)

    def test_empty_animations_still_produces_valid_shaped_output(self):
        dart = flutter_catalog.generate_dart_catalog(
            atlas_id="empty", atlas_file="e.png", manifest_file="e.json", animations=[]
        )
        self.assertIn("const emptyAtlas = SpriteAtlas(", dart)
        self.assertIn("animations: [\n  ],", dart)


if __name__ == "__main__":
    unittest.main()
