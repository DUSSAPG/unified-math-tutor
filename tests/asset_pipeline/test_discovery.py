"""Tests for scripts.asset_pipeline.discovery."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from PIL import Image

from scripts.asset_pipeline import discovery
from scripts.asset_pipeline.models import (
    DuplicateAssetIdError,
    PipelineConfig,
    SourceDirectoryNotFoundError,
)


def _write_png(path: Path, size: tuple[int, int] = (4, 4), color=(255, 0, 0, 255)):
    path.parent.mkdir(parents=True, exist_ok=True)
    image = Image.new("RGBA", size, color)
    if path.suffix.lower() in (".jpg", ".jpeg"):
        image = image.convert("RGB")
    image.save(path)


def _config(source: Path, output: Path) -> PipelineConfig:
    return PipelineConfig(source=source, output=output, atlas_id="test_atlas")


class DiscoverSourceFilesTests(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)
        self.source = self.root / "src"
        self.output = self.root / "out"

    def test_finds_supported_images_recursively_and_sorted(self):
        _write_png(self.source / "b.png")
        _write_png(self.source / "sub" / "a.png")
        _write_png(self.source / "c.jpg")
        (self.source / "notes.txt").parent.mkdir(parents=True, exist_ok=True)
        (self.source / "notes.txt").write_text("ignore me")

        found = discovery.discover_source_files(_config(self.source, self.output))

        self.assertEqual(
            [p.relative_to(self.source).as_posix() for p in found],
            ["b.png", "c.jpg", "sub/a.png"],
        )

    def test_missing_source_directory_raises(self):
        with self.assertRaises(SourceDirectoryNotFoundError):
            discovery.discover_source_files(
                _config(self.root / "does-not-exist", self.output)
            )


class HashFileTests(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)

    def test_identical_bytes_hash_identically(self):
        a = self.root / "a.png"
        b = self.root / "b.png"
        _write_png(a, color=(1, 2, 3, 255))
        _write_png(b, color=(1, 2, 3, 255))
        self.assertEqual(discovery.hash_file(a), discovery.hash_file(b))

    def test_different_bytes_hash_differently(self):
        a = self.root / "a.png"
        b = self.root / "b.png"
        _write_png(a, color=(1, 2, 3, 255))
        _write_png(b, color=(4, 5, 6, 255))
        self.assertNotEqual(discovery.hash_file(a), discovery.hash_file(b))


class DiscoverSourceImagesTests(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)
        self.source = self.root / "src"
        self.output = self.root / "out"

    def test_assigns_stable_extension_free_ids(self):
        _write_png(self.source / "player" / "idle.png")
        images = discovery.discover_source_images(_config(self.source, self.output))
        self.assertEqual([i.id for i in images], ["player/idle"])

    def test_duplicate_id_across_extensions_fails(self):
        _write_png(self.source / "ball.png")
        _write_png(self.source / "ball.jpg")
        with self.assertRaises(DuplicateAssetIdError):
            discovery.discover_source_images(_config(self.source, self.output))


class GroupIntoAssetsTests(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)
        self.source = self.root / "src"
        self.output = self.root / "out"

    def test_numbered_sequence_groups_in_numeric_order(self):
        _write_png(self.source / "player" / "kick_02.png")
        _write_png(self.source / "player" / "kick_01.png")
        _write_png(self.source / "player" / "kick_10.png")
        groups = discovery.discover_and_group(_config(self.source, self.output))

        self.assertEqual(len(groups), 1)
        group = groups[0]
        self.assertEqual(group.asset_id, "player/kick")
        self.assertEqual(
            [img.id for img in group.images],
            ["player/kick_01", "player/kick_02", "player/kick_10"],
        )

    def test_un_numbered_file_is_its_own_single_frame_group(self):
        _write_png(self.source / "ball.png")
        groups = discovery.discover_and_group(_config(self.source, self.output))
        self.assertEqual(len(groups), 1)
        self.assertEqual(groups[0].asset_id, "ball")
        self.assertEqual(len(groups[0].images), 1)

    def test_lone_file_colliding_with_a_sequence_base_name_fails(self):
        _write_png(self.source / "kick.png")
        _write_png(self.source / "kick_01.png")
        _write_png(self.source / "kick_02.png")
        with self.assertRaises(DuplicateAssetIdError):
            discovery.discover_and_group(_config(self.source, self.output))

    def test_grouping_is_deterministic_regardless_of_discovery_order(self):
        _write_png(self.source / "z_seq_02.png")
        _write_png(self.source / "z_seq_01.png")
        _write_png(self.source / "a_single.png")
        first = discovery.discover_and_group(_config(self.source, self.output))
        second = discovery.discover_and_group(_config(self.source, self.output))
        self.assertEqual(
            [g.asset_id for g in first], [g.asset_id for g in second]
        )
        self.assertEqual([g.asset_id for g in first], ["a_single", "z_seq"])


if __name__ == "__main__":
    unittest.main()
