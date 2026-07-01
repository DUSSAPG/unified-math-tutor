#!/usr/bin/env python3
"""Tests for deterministic CH translation template mining and autofill."""

from __future__ import annotations

import csv
import json
import tempfile
import unittest
from pathlib import Path

import autofill_ch_translation_csv as autofill
import mine_translation_templates as mining


FIELDS = (
    "locale",
    "segment_hash",
    "source_text",
    "translated_text",
    "occurrences",
    "sample_locations",
)


class NormalizationTest(unittest.TestCase):
    def test_numbers_map_to_same_pattern(self) -> None:
        self.assertEqual(
            mining.normalize_source_text("Calculate: 12 + 7"),
            mining.normalize_source_text("Calculate: 900 + 0.5"),
        )

    def test_latex_and_literal_braces_are_preserved(self) -> None:
        normalized = mining.normalize_source_text(
            r"Given $x^2 + 4$ and {answer}, find 1/5 of 20."
        )
        self.assertEqual(
            normalized, "Given {latex} and {answer}, find {frac} of {n}."
        )
        rendered = mining.render_template(
            r"Given $x^2 + 4$ and {answer}, find 1/5 of 20.",
            "Avec {latex} et {answer}, trouve {frac} de {n}.",
        )
        self.assertEqual(
            rendered, r"Avec $x^2 + 4$ et {answer}, trouve 1/5 de 20."
        )


class EndToEndTest(unittest.TestCase):
    def test_mine_and_autofill_small_csv(self) -> None:
        with tempfile.TemporaryDirectory() as name:
            root = Path(name)
            source_csv = root / "review.csv"
            templates_csv = root / "templates.csv"
            stats_json = root / "stats.json"
            phrasebook_csv = root / "phrasebook.csv"
            output_csv = root / "autofilled.csv"
            residual_csv = root / "residual.csv"
            with source_csv.open("w", newline="", encoding="utf-8-sig") as handle:
                writer = csv.DictWriter(handle, fieldnames=FIELDS)
                writer.writeheader()
                for index, source in enumerate(
                    ("Calculate: 12 + 7", "Calculate: 8 + 9", "Unmatched 4")
                ):
                    writer.writerow(
                        {
                            "locale": "de-CH",
                            "segment_hash": f"seg-{index}",
                            "source_text": source,
                            "translated_text": "",
                            "occurrences": "1",
                            "sample_locations": "sample",
                        }
                    )

            stats = mining.mine_csv(source_csv, templates_csv, stats_json)
            self.assertEqual(stats["unique_segments"], 3)
            self.assertEqual(stats["unique_patterns"], 2)
            self.assertEqual(json.loads(stats_json.read_text())["unique_patterns"], 2)

            with phrasebook_csv.open("w", newline="", encoding="utf-8-sig") as handle:
                writer = csv.DictWriter(handle, fieldnames=autofill.PHRASEBOOK_FIELDS)
                writer.writeheader()
                normalized = mining.normalize_source_text("Calculate: 1 + 2")
                writer.writerow(
                    {
                        "pattern_id": mining.pattern_id(normalized),
                        "translated_template": "Berechne: {n} + {n}",
                    }
                )

            matched, total, residuals = autofill.autofill_csv(
                source_csv, phrasebook_csv, output_csv, residual_csv
            )
            self.assertEqual((matched, total), (2, 3))
            self.assertEqual(sum(residuals.values()), 1)
            with output_csv.open(newline="", encoding="utf-8-sig") as handle:
                rows = list(csv.DictReader(handle))
            self.assertEqual(rows[0]["translated_text"], "Berechne: 12 + 7")
            self.assertEqual(rows[1]["translated_text"], "Berechne: 8 + 9")
            with residual_csv.open(newline="", encoding="utf-8-sig") as handle:
                residual_rows = list(csv.DictReader(handle))
            self.assertEqual([row["source_text"] for row in residual_rows], ["Unmatched 4"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
