#!/usr/bin/env python3
"""Tests for authoritative CH locale template splitting."""

from __future__ import annotations

import csv
import tempfile
import unittest
from pathlib import Path

import split_ch_translation_template as split


class SplitTemplateTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.template = self.root / "ch_translation_template.csv"
        with self.template.open("w", newline="", encoding="utf-8-sig") as handle:
            writer = csv.DictWriter(handle, fieldnames=split.FIELDS)
            writer.writeheader()
            for locale in split.LOCALES:
                writer.writerow(
                    {
                        "locale": locale,
                        "segment_hash": f"{locale}-1",
                        "source_text": "Calculate: 2 + 2",
                        "translated_text": "",
                        "occurrences": "1",
                        "sample_locations": "pack.jsonl:q1:stem",
                    }
                )

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def test_writes_full_schema_and_preserves_locale_order(self) -> None:
        outputs = split.split_template(self.template)
        self.assertEqual(len(outputs), 3)
        for locale, output in zip(split.LOCALES, outputs):
            with output.open(newline="", encoding="utf-8-sig") as handle:
                reader = csv.DictReader(handle)
                self.assertEqual(tuple(reader.fieldnames or ()), split.FIELDS)
                rows = list(reader)
            self.assertEqual([row["locale"] for row in rows], [locale])
            self.assertEqual(rows[0]["source_text"], "Calculate: 2 + 2")

    def test_existing_valid_file_is_not_overwritten(self) -> None:
        outputs = split.split_template(self.template)
        outputs[0].write_text("reviewer work", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "expected columns"):
            split.split_template(self.template)
        self.assertEqual(outputs[0].read_text(encoding="utf-8"), "reviewer work")

    def test_force_repairs_existing_invalid_file(self) -> None:
        outputs = split.split_template(self.template)
        outputs[0].write_text("reviewer work", encoding="utf-8")
        split.split_template(self.template, force=True)
        with outputs[0].open(newline="", encoding="utf-8-sig") as handle:
            rows = list(csv.DictReader(handle))
        self.assertEqual([row["locale"] for row in rows], ["de-CH"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
