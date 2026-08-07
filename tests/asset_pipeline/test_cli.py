"""End-to-end tests for scripts.asset_pipeline.cli — the full
discover -> decode -> trim -> pack -> metadata -> validate ->
flutter_catalog -> report pipeline, driven through the public
``build_command``/``main`` entry points against real files on disk."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from PIL import Image

from scripts.asset_pipeline import cli, validation
from scripts.asset_pipeline.models import AssetPipelineError, PipelineConfig


def _write_png(path: Path, size=(6, 6), color=(255, 0, 0, 255)):
    path.parent.mkdir(parents=True, exist_ok=True)
    image = Image.new("RGBA", size, color)
    if path.suffix.lower() in (".jpg", ".jpeg"):
        image = image.convert("RGB")
    image.save(path)


class CliTestCase(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.root = Path(self._tmp.name)
        self.source = self.root / "src"
        self.output = self.root / "out"

    def _config(self, **overrides) -> PipelineConfig:
        defaults = dict(
            source=self.source, output=self.output, atlas_id="test_atlas"
        )
        defaults.update(overrides)
        return PipelineConfig(**defaults)

    def _populate_basic_source(self):
        _write_png(self.source / "ball.png", size=(8, 8), color=(200, 30, 30, 255))
        _write_png(self.source / "player" / "kick_01.png", size=(6, 6), color=(0, 200, 0, 255))
        _write_png(self.source / "player" / "kick_02.png", size=(6, 6), color=(0, 180, 0, 255))


class EndToEndBuildTests(CliTestCase):
    def test_build_produces_every_expected_artifact(self):
        self._populate_basic_source()
        report = cli.build_command(self._config())

        self.assertTrue(report.ok)
        produced = {p.name for p in self.output.iterdir()}
        self.assertEqual(
            produced,
            {
                "test_atlas.png",
                "test_atlas.json",
                "test_atlas_atlas.dart",
                "test_atlas_report.csv",
                "test_atlas_report.json",
            },
        )

    def test_manifest_json_is_schema_valid_and_matches_the_atlas_png(self):
        self._populate_basic_source()
        cli.build_command(self._config())

        data = json.loads((self.output / "test_atlas.json").read_text())
        self.assertEqual(validation.validate_manifest_schema(data), [])

        with Image.open(self.output / "test_atlas.png") as atlas_image:
            self.assertEqual(atlas_image.width, data["atlasWidth"])
            self.assertEqual(atlas_image.height, data["atlasHeight"])

        asset_ids = {animation["assetId"] for animation in data["animations"]}
        self.assertEqual(asset_ids, {"ball", "player/kick"})

    def test_kick_sequence_becomes_one_two_frame_animation(self):
        self._populate_basic_source()
        cli.build_command(self._config())
        data = json.loads((self.output / "test_atlas.json").read_text())
        kick = next(a for a in data["animations"] if a["assetId"] == "player/kick")
        self.assertEqual(len(kick["frames"]), 2)
        self.assertTrue(kick["frames"][0]["sourceFile"].endswith("kick_01.png"))
        self.assertTrue(kick["frames"][1]["sourceFile"].endswith("kick_02.png"))


class DeterminismTests(CliTestCase):
    def test_identical_input_produces_byte_identical_output(self):
        self._populate_basic_source()
        first_output = self.root / "out1"
        second_output = self.root / "out2"

        cli.build_command(self._config(output=first_output))
        cli.build_command(self._config(output=second_output))

        for name in ["test_atlas.png", "test_atlas.json", "test_atlas_atlas.dart"]:
            self.assertEqual(
                (first_output / name).read_bytes(),
                (second_output / name).read_bytes(),
                f"{name} differed between two identical builds",
            )


class FailureModeTests(CliTestCase):
    def test_duplicate_asset_id_fails_the_whole_build(self):
        _write_png(self.source / "ball.png")
        _write_png(self.source / "ball.jpg")
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config())
        self.assertFalse(self.output.exists())

    def test_blank_frame_fails_the_whole_build(self):
        _write_png(self.source / "ok.png", color=(1, 1, 1, 255))
        _write_png(self.source / "blank.png", color=(0, 0, 0, 0))
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config())
        self.assertFalse(self.output.exists())

    def test_corrupt_file_fails_the_whole_build(self):
        _write_png(self.source / "ok.png")
        bad = self.source / "bad.png"
        bad.parent.mkdir(parents=True, exist_ok=True)
        bad.write_bytes(b"not a real image")
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config())
        self.assertFalse(self.output.exists())

    def test_atlas_too_large_fails_the_whole_build(self):
        for i in range(30):
            _write_png(self.source / f"big_{i}.png", size=(40, 40))
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config(max_atlas_size=64))
        self.assertFalse(self.output.exists())

    def test_missing_source_directory_fails_safely(self):
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config())

    def test_temp_directory_is_cleaned_up_after_a_forced_failure(self):
        self._populate_basic_source()
        siblings_before = set(self.output.parent.iterdir()) if self.output.parent.exists() else set()

        with mock.patch(
            "scripts.asset_pipeline.cli.metadata.atlas_to_json_string",
            side_effect=RuntimeError("simulated late-stage failure"),
        ):
            with self.assertRaises(RuntimeError):
                cli.build_command(self._config())

        self.assertFalse(self.output.exists())
        siblings_after = set(self.output.parent.iterdir()) if self.output.parent.exists() else set()
        leftover = siblings_after - siblings_before
        temp_leftovers = [p for p in leftover if p.name.startswith(".test_atlas-build-")]
        self.assertEqual(temp_leftovers, [], f"leftover temp dirs: {temp_leftovers}")


class OverwriteBehaviourTests(CliTestCase):
    def test_second_build_without_overwrite_is_rejected(self):
        self._populate_basic_source()
        cli.build_command(self._config())
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config())

    def test_second_build_with_overwrite_replaces_the_output(self):
        self._populate_basic_source()
        cli.build_command(self._config())
        _write_png(self.source / "extra.png", color=(9, 9, 9, 255))
        report = cli.build_command(self._config(overwrite=True))
        self.assertTrue(report.ok)
        data = json.loads((self.output / "test_atlas.json").read_text())
        asset_ids = {a["assetId"] for a in data["animations"]}
        self.assertIn("extra", asset_ids)

    def test_build_never_touches_output_dir_before_success_is_confirmed(self):
        self._populate_basic_source()
        _write_png(self.source / "same_name_collision.png")
        _write_png(self.source / "same_name_collision.jpg")  # forces DuplicateAssetIdError
        self.assertFalse(self.output.exists())
        with self.assertRaises(AssetPipelineError):
            cli.build_command(self._config())
        self.assertFalse(self.output.exists())


class MainEntryPointTests(CliTestCase):
    def test_main_returns_zero_on_success(self):
        self._populate_basic_source()
        exit_code = cli.main(
            [
                "build",
                "--source",
                str(self.source),
                "--output",
                str(self.output),
                "--atlas-id",
                "test_atlas",
            ]
        )
        self.assertEqual(exit_code, 0)
        self.assertTrue((self.output / "test_atlas.png").exists())

    def test_main_returns_nonzero_on_failure(self):
        exit_code = cli.main(
            [
                "build",
                "--source",
                str(self.source),  # does not exist
                "--output",
                str(self.output),
                "--atlas-id",
                "test_atlas",
            ]
        )
        self.assertNotEqual(exit_code, 0)


if __name__ == "__main__":
    unittest.main()
