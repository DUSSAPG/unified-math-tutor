#!/usr/bin/env python3
"""Focused tests for the offline CH translation pipeline."""

from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("translate_ch_packs.py")
SPEC = importlib.util.spec_from_file_location("translate_ch_packs", SCRIPT)
assert SPEC and SPEC.loader
PIPELINE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(PIPELINE)


class TranslationPipelineTest(unittest.TestCase):
    def test_math_tokens_and_placeholders_are_preserved(self) -> None:
        PIPELINE.validate_tokens(
            "Find {amount}: solve $x^2 + 2 = 6$.",
            "Berechne {amount}: löse $x^2 + 2 = 6$.",
        )

    def test_changed_math_token_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            PIPELINE.validate_tokens("Find 1/4 of 76.", "Calcule 1/3 de 76.")

    def test_machine_fields_are_not_translatable(self) -> None:
        row = {
            "id": "fixed-id",
            "stem": "Find 1/4 of 76.",
            "check_expr": "(76*1)/4",
            "skill": "fractions_of_amount",
        }
        fields = {field for field, _ in PIPELINE.iter_translatable(row)}
        self.assertEqual(fields, {"stem"})

    def test_segment_hash_normalizes_spacing(self) -> None:
        self.assertEqual(
            PIPELINE.segment_hash("Find   1/4 of 76."),
            PIPELINE.segment_hash(" Find 1/4 of 76. "),
        )


if __name__ == "__main__":
    unittest.main()
