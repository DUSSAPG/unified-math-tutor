#!/usr/bin/env python3
"""Integration tests for the release-facing CH translation workflow."""

from __future__ import annotations

import csv
import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch


TOOLS_DIR = Path(__file__).resolve().parent
REPO_ROOT = TOOLS_DIR.parent
sys.path.insert(0, str(TOOLS_DIR))

from merge_ch_translation_reviews import merge_reviews
from split_ch_translation_template import LOCALES, split_template


def _load_pipeline():
    script = REPO_ROOT / "scripts" / "translate_ch_packs.py"
    spec = importlib.util.spec_from_file_location("translate_ch_packs_workflow", script)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PIPELINE = _load_pipeline()


class SplitMergeTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.template = self.root / "ch_translation_template.csv"
        with self.template.open("w", newline="", encoding="utf-8-sig") as handle:
            writer = csv.DictWriter(
                handle,
                fieldnames=(
                    "locale",
                    "segment_hash",
                    "source_text",
                    "translated_text",
                    "occurrences",
                    "sample_locations",
                ),
            )
            writer.writeheader()
            for locale in LOCALES:
                writer.writerow(
                    {
                        "locale": locale,
                        "segment_hash": "seg-1",
                        "source_text": 'Find 1/4 of 76, then say "done".',
                        "translated_text": "",
                        "occurrences": "2",
                        "sample_locations": "pack.jsonl:q1:stem | pack.jsonl:q2:stem",
                    }
                )

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def _reviews(self) -> dict[str, Path]:
        return {
            locale: self.template.with_name(f"{self.template.stem}.{locale}.csv")
            for locale in LOCALES
        }

    def test_split_merge_round_trip_is_byte_for_byte_lossless(self) -> None:
        original = self.template.read_bytes()
        split_template(self.template)
        merge_reviews(self.template, self._reviews())
        self.assertEqual(self.template.read_bytes(), original)

    def test_merge_rejects_seg_id_mismatch(self) -> None:
        split_template(self.template)
        review = self._reviews()["fr-CH"]
        text = review.read_text(encoding="utf-8-sig").replace("seg-1", "wrong-id")
        review.write_text(text, encoding="utf-8-sig")
        with self.assertRaisesRegex(ValueError, "seg_id mismatch"):
            merge_reviews(self.template, self._reviews())


class ApplyPackSetTest(unittest.TestCase):
    def test_apply_writes_expected_ch_file_set(self) -> None:
        with tempfile.TemporaryDirectory() as name:
            root = Path(name)
            source_root = root / "assets" / "packs" / "en-GB"
            source_root.mkdir(parents=True)
            pack_names = ("KS2.jsonl", "KS3.jsonl", "KS4.jsonl", "KS5.jsonl")
            source = {
                "id": "q1",
                "lang": "en-GB",
                "stem": "Find 1/4 of 76.",
                "options": ["19", "20"],
                "check_expr": "(76*1)/4",
            }
            for pack in pack_names:
                (source_root / pack).write_text(
                    json.dumps(source) + "\n",
                    encoding="utf-8",
                )
            reviews = root / "reviewed.csv"
            with reviews.open("w", newline="", encoding="utf-8-sig") as handle:
                writer = csv.DictWriter(
                    handle,
                    fieldnames=(
                        "locale",
                        "segment_hash",
                        "source_text",
                        "translated_text",
                        "occurrences",
                        "sample_locations",
                    ),
                )
                writer.writeheader()
                for locale in LOCALES:
                    writer.writerow(
                        {
                            "locale": locale,
                            "segment_hash": PIPELINE.segment_hash(source["stem"]),
                            "source_text": source["stem"],
                            "translated_text": source["stem"],
                            "occurrences": "4",
                            "sample_locations": "",
                        }
                    )

            old_cwd = Path.cwd()
            try:
                os.chdir(root)
                with patch.object(PIPELINE, "SOURCE_ROOT", source_root), patch.object(
                    PIPELINE, "PACKS", pack_names
                ):
                    for locale in LOCALES:
                        PIPELINE.apply_translations(
                            locale,
                            reviews,
                            root / "translation_report.csv",
                        )
            finally:
                os.chdir(old_cwd)

            expected = {
                root / "assets" / "packs" / locale / pack
                for locale in LOCALES
                for pack in pack_names
            }
            self.assertEqual(
                set((root / "assets" / "packs").glob("*-CH/*.jsonl")),
                expected,
            )


class DartValidatorTest(unittest.TestCase):
    def setUp(self) -> None:
        self.dart = shutil.which("dart")
        if self.dart is None:
            self.skipTest("dart is not available")
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        packs = self.root / "assets" / "packs"
        for locale in ("en-GB", *LOCALES):
            folder = packs / locale
            folder.mkdir(parents=True)
            (folder / "KS2.jsonl").write_text('{"id":"q1"}\n', encoding="utf-8")
        (self.root / "assets" / "pack_registry.json").write_text(
            json.dumps(
                {
                    "packs": [{"filename": "KS2.jsonl", "count": 1}],
                    "translatedLocales": {
                        locale: {
                            "enabledByFlag": "ENABLE_CH_PACKS",
                            "packs": {
                                "ks2": {
                                    "path": f"assets/packs/{locale}/KS2.jsonl",
                                    "count": 1,
                                }
                            },
                        }
                        for locale in LOCALES
                    },
                }
            ),
            encoding="utf-8",
        )
        (self.root / "assets" / "market_registry.json").write_text(
            json.dumps(
                {
                    "version": 1,
                    "defaultMarket": "uk",
                    "markets": [
                        {"id": "uk", "defaultLocale": "en-GB", "locales": ["en-GB"]}
                    ],
                }
            ),
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        if hasattr(self, "tmp"):
            self.tmp.cleanup()

    def _run_validator(self) -> subprocess.CompletedProcess[str]:
        command = [
            self.dart,
            "run",
            str(REPO_ROOT / "tools" / "validate_packs.dart"),
            "--enable-ch-packs",
        ]
        if os.name == "nt" and Path(self.dart).suffix.lower() in {".bat", ".cmd"}:
            command = [os.environ.get("COMSPEC", "cmd.exe"), "/d", "/c", *command]
        return subprocess.run(
            command,
            cwd=self.root,
            capture_output=True,
            text=True,
            check=False,
        )

    def test_validator_passes_when_ch_packs_exist(self) -> None:
        result = self._run_validator()
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_validator_fails_clearly_when_ch_pack_is_missing(self) -> None:
        missing = self.root / "assets" / "packs" / "fr-CH" / "KS2.jsonl"
        missing.unlink()
        result = self._run_validator()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(
            "assets/packs/fr-CH/KS2.jsonl: referenced file is missing.",
            result.stderr,
        )


if __name__ == "__main__":
    unittest.main(verbosity=2)
