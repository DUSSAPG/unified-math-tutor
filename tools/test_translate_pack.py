#!/usr/bin/env python3
"""
Unit + integration tests for translate_pack_jsonl.py

Run from repo root:
    python tools/test_translate_pack.py -v
"""

import argparse
import csv
import hashlib
import json
import pathlib
import sys
import tempfile
import unittest
from unittest.mock import patch

# Allow importing the sibling module without installing the package.
sys.path.insert(0, str(pathlib.Path(__file__).parent))
import translate_pack_jsonl as tpj

# ---------------------------------------------------------------------------
# Shared test data
# ---------------------------------------------------------------------------

_KS2 = [
    {
        "id": "q1", "lang": "en-GB", "stage": "KS2", "skill": "add",
        "difficulty": 1, "type": "mcq", "stem": "Calculate: 10 + 5",
        "options": ["15", "20"], "answer_index": 0, "answer_value": "15",
        "hint": "", "rationale": "",
        "check_type": "expr", "check_expr": "10+5", "check_answer": "15",
        "params": {},
    },
    {
        "id": "q2", "lang": "en-GB", "stage": "KS2", "skill": "add",
        "difficulty": 2, "type": "mcq", "stem": "Calculate: 20 + 7",
        "options": ["27", "28"], "answer_index": 0, "answer_value": "27",
        "hint": "Add units first.", "rationale": "",
        "check_type": "expr", "check_expr": "20+7", "check_answer": "27",
        "params": {},
    },
    # q3 is a deliberate duplicate of q1's stem (different id, same question text).
    {
        "id": "q3", "lang": "en-GB", "stage": "KS2", "skill": "add",
        "difficulty": 1, "type": "mcq", "stem": "Calculate: 10 + 5",
        "options": ["15", "14"], "answer_index": 0, "answer_value": "15",
        "hint": "", "rationale": "",
        "check_type": "expr", "check_expr": "10+5", "check_answer": "15",
        "params": {},
    },
]

_KS4 = [
    {
        "stage": "KS4", "strand": "Geometry", "skill": "Angles",
        "difficulty": 3,
        "question": "Two parallel lines are cut by a transversal. "
                    "A corresponding angle is 70°. "
                    "What is the matching corresponding angle?",
        "options": ["110", "80", "60", "70"],
        "answer_index": 3,
        "rationale": "Corresponding angles are equal.",
        "check_type": "angles", "check_expr": "70", "check_sub_value": None,
        "id": "ks4_angles_abc123",
    },
]


def _make_jsonl(records: list[dict]) -> str:
    return "\n".join(json.dumps(r, ensure_ascii=False) for r in records) + "\n"


# ---------------------------------------------------------------------------
# Helper: temp-dir fixture that patches REPO_ROOT and PACKS
# ---------------------------------------------------------------------------

class _TmpRepo(unittest.TestCase):
    """Base class: sets up a minimal in-memory repo tree in a temp directory."""

    PACKS_UNDER_TEST: list[str] = ["KS2_bank_ok_10000"]
    SOURCE_RECORDS: list[dict] = _KS2

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = pathlib.Path(self.tmp.name)
        src_dir = self.root / "assets" / "packs" / "en-GB"
        src_dir.mkdir(parents=True)
        (src_dir / "KS2_bank_ok_10000.jsonl").write_text(
            _make_jsonl(self.SOURCE_RECORDS), encoding="utf-8"
        )
        self._patches = [
            patch.object(tpj, "REPO_ROOT", self.root),
            patch.object(tpj, "PACKS", self.PACKS_UNDER_TEST),
        ]
        for p in self._patches:
            p.start()

    def tearDown(self):
        for p in self._patches:
            p.stop()
        self.tmp.cleanup()

    def _extract(self, locales=("de-CH",), packs=None):
        tpj.cmd_extract(
            argparse.Namespace(
                packs=packs or self.PACKS_UNDER_TEST,
                locales=list(locales),
            )
        )

    def _apply(self, locales=("de-CH",), packs=None):
        tpj.cmd_apply(
            argparse.Namespace(
                packs=packs or self.PACKS_UNDER_TEST,
                locales=list(locales),
            )
        )

    def _read_csv(self, locale="de-CH", pack="KS2_bank_ok_10000") -> list[dict]:
        p = self.root / "translations" / "csv" / locale / f"{pack}.csv"
        with p.open(newline="", encoding="utf-8") as fh:
            return list(csv.DictReader(fh))

    def _read_output(self, locale="de-CH", pack="KS2_bank_ok_10000") -> list[dict]:
        p = self.root / "translations" / "out" / locale / f"{pack}.jsonl"
        return [
            json.loads(line)
            for line in p.read_text(encoding="utf-8").splitlines()
            if line.strip()
        ]

    def _read_log(self, locale="de-CH", pack="KS2_bank_ok_10000") -> str:
        p = self.root / "translations" / "log" / locale / f"{pack}.log"
        return p.read_text(encoding="utf-8")

    def _write_csv(self, rows: list[dict], locale="de-CH", pack="KS2_bank_ok_10000"):
        p = self.root / "translations" / "csv" / locale / f"{pack}.csv"
        p.parent.mkdir(parents=True, exist_ok=True)
        with p.open("w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=tpj.CSV_FIELDS, quoting=csv.QUOTE_ALL)
            w.writeheader()
            w.writerows(rows)


# ===========================================================================
# Pure-function unit tests
# ===========================================================================

class TestSegId(unittest.TestCase):

    def test_deterministic(self):
        assert tpj.seg_id("hello") == tpj.seg_id("hello")

    def test_length_16(self):
        assert len(tpj.seg_id("anything")) == 16

    def test_hex_characters_only(self):
        sid = tpj.seg_id("abc")
        assert all(c in "0123456789abcdef" for c in sid)

    def test_distinct_texts_produce_distinct_ids(self):
        assert tpj.seg_id("Find 1/4 of 76.") != tpj.seg_id("Find 2/4 of 76.")

    def test_matches_sha256_prefix(self):
        text = "Calculate: 87 + 13"
        expected = hashlib.sha256(text.encode()).hexdigest()[:16]
        assert tpj.seg_id(text) == expected


class TestProtectedTokens(unittest.TestCase):

    def test_inline_math(self):
        assert "$x^2 + 1 = 0$" in tpj.protected_tokens("Solve $x^2 + 1 = 0$ for x.")

    def test_display_math(self):
        assert "$$\\frac{1}{2}$$" in tpj.protected_tokens(
            "Evaluate $$\\frac{1}{2}$$ exactly."
        )

    def test_placeholder(self):
        tokens = tpj.protected_tokens("Hello {name}, you have {count} items.")
        assert "{name}" in tokens
        assert "{count}" in tokens

    def test_latex_command(self):
        tokens = tpj.protected_tokens("Use \\frac and \\sqrt here.")
        assert "\\frac" in tokens
        assert "\\sqrt" in tokens

    def test_plain_text_has_no_tokens(self):
        assert tpj.protected_tokens("Find 1/4 of 76.") == frozenset()

    def test_does_not_match_numbers_as_tokens(self):
        # Pure numbers must not be treated as protected tokens.
        tokens = tpj.protected_tokens("Calculate 70 + 30.")
        assert not any(t.isdigit() for t in tokens)


class TestValidatePlaceholders(unittest.TestCase):

    def test_no_warnings_when_all_preserved(self):
        assert tpj.validate_placeholders(
            "Evaluate $x^2$ for x = 3.",
            "Évaluez $x^2$ pour x = 3.",
        ) == []

    def test_warns_when_math_block_dropped(self):
        warns = tpj.validate_placeholders(
            "Use $\\frac{1}{2}$ here.",
            "Verwende hier.",          # math entirely dropped
        )
        # repr() doubles backslashes in the warning text; test by distinctive fragment.
        assert len(warns) >= 1
        assert any("frac" in w for w in warns)

    def test_warns_when_placeholder_missing(self):
        warns = tpj.validate_placeholders(
            "Question {current} of {total}",
            "Frage {current} von",     # {total} missing
        )
        assert any("{total}" in w for w in warns)

    def test_no_warning_for_plain_numbers(self):
        # Degrees, plain arithmetic — no protected tokens in source.
        assert tpj.validate_placeholders(
            "A corresponding angle is 70°.",
            "Ein entsprechender Winkel ist 70°.",
        ) == []

    def test_warns_on_missing_latex_command(self):
        warns = tpj.validate_placeholders(
            "Apply \\int here.",
            "Wende hier an.",
        )
        assert any("\\int" in w for w in warns)


class TestHumanFieldsOf(unittest.TestCase):

    def test_ks2_stem_only(self):
        record = {"id": "q1", "stem": "Find 1/4 of 76.", "hint": "", "rationale": ""}
        assert tpj.human_fields_of(record) == [("stem", "Find 1/4 of 76.")]

    def test_ks2_stem_and_non_empty_hint(self):
        record = {
            "stem": "Solve x + 2 = 5.",
            "hint": "Subtract 2 from both sides.",
            "rationale": "",
        }
        result = tpj.human_fields_of(record)
        assert ("stem", "Solve x + 2 = 5.") in result
        assert ("hint", "Subtract 2 from both sides.") in result

    def test_ks4_question_and_rationale(self):
        record = {
            "question": "What is 70° alternate to?",
            "rationale": "Alternate angles are equal.",
        }
        result = tpj.human_fields_of(record)
        assert ("question", "What is 70° alternate to?") in result
        assert ("rationale", "Alternate angles are equal.") in result

    def test_empty_strings_are_skipped(self):
        record = {"stem": "  ", "hint": "  ", "rationale": ""}
        assert tpj.human_fields_of(record) == []

    def test_non_string_values_are_skipped(self):
        record = {"stem": 42, "question": None, "hint": ["list"]}
        assert tpj.human_fields_of(record) == []

    def test_stem_before_hint_before_rationale(self):
        record = {"stem": "A", "hint": "B", "rationale": "C"}
        fields = [f for f, _ in tpj.human_fields_of(record)]
        assert fields == ["stem", "hint", "rationale"]

    def test_question_preferred_over_missing_stem(self):
        record = {"question": "Q?", "rationale": "Because."}
        fields = [f for f, _ in tpj.human_fields_of(record)]
        assert "stem" not in fields
        assert "question" in fields


class TestIterJsonl(unittest.TestCase):

    def test_yields_all_valid_lines(self):
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".jsonl", delete=False, encoding="utf-8"
        ) as f:
            f.write('{"id": "a"}\n{"id": "b"}\n')
            name = pathlib.Path(f.name)
        records = list(tpj.iter_jsonl(name))
        assert len(records) == 2
        assert records[0] == (1, {"id": "a"})
        name.unlink()

    def test_skips_empty_lines(self):
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".jsonl", delete=False, encoding="utf-8"
        ) as f:
            f.write('\n{"id": "a"}\n\n{"id": "b"}\n\n')
            name = pathlib.Path(f.name)
        records = list(tpj.iter_jsonl(name))
        assert len(records) == 2
        name.unlink()

    def test_skips_malformed_lines_with_warning(self):
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".jsonl", delete=False, encoding="utf-8"
        ) as f:
            f.write('{"id": "ok"}\nnot json\n{"id": "also_ok"}\n')
            name = pathlib.Path(f.name)
        records = list(tpj.iter_jsonl(name))
        assert len(records) == 2          # malformed line silently skipped
        assert records[0][1]["id"] == "ok"
        assert records[1][1]["id"] == "also_ok"
        name.unlink()


# ===========================================================================
# extract integration tests
# ===========================================================================

class TestExtract(_TmpRepo):

    def test_csv_file_is_created(self):
        self._extract()
        assert (
            self.root / "translations" / "csv" / "de-CH" / "KS2_bank_ok_10000.csv"
        ).exists()

    def test_duplicate_stem_deduplicated(self):
        # q1 and q3 share "Calculate: 10 + 5" — must appear only once.
        self._extract()
        rows = self._read_csv()
        texts = [r["source_text"] for r in rows]
        assert texts.count("Calculate: 10 + 5") == 1

    def test_unique_segment_count(self):
        # Unique segments: "Calculate: 10+5", "Calculate: 20+7", "Add units first."
        self._extract()
        rows = self._read_csv()
        assert len(rows) == 3

    def test_translation_column_empty_on_first_run(self):
        self._extract()
        rows = self._read_csv()
        assert all(r["translation"] == "" for r in rows)

    def test_locale_target_column_matches_requested_locale(self):
        self._extract(locales=["fr-CH"])
        rows = self._read_csv(locale="fr-CH")
        assert all(r["locale_target"] == "fr-CH" for r in rows)

    def test_existing_translations_preserved_on_rerun(self):
        self._extract()
        rows = self._read_csv()
        # Simulate a reviewer filling in one row.
        rows[0]["translation"] = "Berechne: 10 + 5"
        self._write_csv(rows)
        # Re-run should not wipe the reviewed translation.
        self._extract()
        rows2 = self._read_csv()
        by_src = {r["source_text"]: r["translation"] for r in rows2}
        assert by_src["Calculate: 10 + 5"] == "Berechne: 10 + 5"

    def test_context_ids_contain_both_duplicate_question_ids(self):
        # "Calculate: 10 + 5" appears in q1 and q3.
        self._extract()
        rows = self._read_csv()
        row = next(r for r in rows if r["source_text"] == "Calculate: 10 + 5")
        assert "q1" in row["context_ids"]
        assert "q3" in row["context_ids"]

    def test_all_three_locales_produced(self):
        self._extract(locales=["de-CH", "fr-CH", "it-CH"])
        for locale in ("de-CH", "fr-CH", "it-CH"):
            assert (
                self.root / "translations" / "csv" / locale / "KS2_bank_ok_10000.csv"
            ).exists()

    def test_seg_id_in_csv_matches_helper(self):
        self._extract()
        rows = self._read_csv()
        for row in rows:
            assert row["seg_id"] == tpj.seg_id(row["source_text"])


# ===========================================================================
# apply integration tests
# ===========================================================================

class TestApply(_TmpRepo):

    def setUp(self):
        super().setUp()
        # Build a reviewed CSV: stems translated, hint left blank.
        self._extract()
        rows = self._read_csv()
        by_src = {r["source_text"]: r for r in rows}
        by_src["Calculate: 10 + 5"]["translation"] = "Berechne: 10 + 5"
        by_src["Calculate: 20 + 7"]["translation"] = "Berechne: 20 + 7"
        # "Add units first." left blank (untranslated)
        self._write_csv(list(by_src.values()))

    def test_output_jsonl_created(self):
        self._apply()
        assert (
            self.root / "translations" / "out" / "de-CH" / "KS2_bank_ok_10000.jsonl"
        ).exists()

    def test_translated_stems_replaced(self):
        self._apply()
        records = self._read_output()
        assert records[0]["stem"] == "Berechne: 10 + 5"
        assert records[1]["stem"] == "Berechne: 20 + 7"

    def test_duplicate_stem_translated_in_both_records(self):
        # q1 and q3 share a stem; both should be translated.
        self._apply()
        records = self._read_output()
        assert records[0]["stem"] == "Berechne: 10 + 5"
        assert records[2]["stem"] == "Berechne: 10 + 5"

    def test_untranslated_hint_kept_as_english(self):
        self._apply()
        records = self._read_output()
        # q2 (index 1) has hint = "Add units first." with no translation.
        assert records[1]["hint"] == "Add units first."

    def test_non_human_fields_preserved_exactly(self):
        self._apply()
        out = self._read_output()
        src = _KS2[0]
        for key in (
            "id", "check_type", "check_expr", "check_answer",
            "answer_index", "answer_value", "difficulty", "params",
        ):
            assert out[0][key] == src[key], f"field {key!r} was modified"

    def test_line_count_matches_source(self):
        self._apply()
        records = self._read_output()
        assert len(records) == len(_KS2)

    def test_log_records_untranslated_hint(self):
        self._apply()
        log = self._read_log()
        assert "UNTRANSLATED" in log
        assert "q2" in log
        assert "hint" in log

    def test_log_created(self):
        self._apply()
        assert (
            self.root / "translations" / "log" / "de-CH" / "KS2_bank_ok_10000.log"
        ).exists()

    def test_apply_without_csv_keeps_english_and_logs(self):
        # No CSV at all — all segments fall through as untranslated.
        self._apply()          # CSV exists but stems are translated
        # Now delete the CSV and re-apply to test the no-CSV path.
        (
            self.root / "translations" / "csv" / "de-CH" / "KS2_bank_ok_10000.csv"
        ).unlink()
        self._apply()
        records = self._read_output()
        assert records[0]["stem"] == "Calculate: 10 + 5"  # English kept

    def test_output_is_valid_jsonl(self):
        self._apply()
        p = self.root / "translations" / "out" / "de-CH" / "KS2_bank_ok_10000.jsonl"
        for line in p.read_text(encoding="utf-8").splitlines():
            if line.strip():
                json.loads(line)   # must not raise


class TestApplyKS4(_TmpRepo):
    """Verify the question/rationale schema (KS4/KS5) is handled correctly."""

    SOURCE_RECORDS = _KS4

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = pathlib.Path(self.tmp.name)
        src_dir = self.root / "assets" / "packs" / "en-GB"
        src_dir.mkdir(parents=True)
        (src_dir / "KS2_bank_ok_10000.jsonl").write_text(
            _make_jsonl(_KS4), encoding="utf-8"
        )
        self._patches = [
            patch.object(tpj, "REPO_ROOT", self.root),
            patch.object(tpj, "PACKS", ["KS2_bank_ok_10000"]),
        ]
        for p in self._patches:
            p.start()
        # Build a reviewed CSV.
        self._extract()
        rows = self._read_csv()
        for row in rows:
            if row["source_text"] == "Corresponding angles are equal.":
                row["translation"] = "Entsprechende Winkel sind gleich."
            # question text left untranslated for this test
        self._write_csv(rows)

    def test_rationale_translated(self):
        self._apply()
        records = self._read_output()
        assert records[0]["rationale"] == "Entsprechende Winkel sind gleich."

    def test_non_human_fields_untouched(self):
        self._apply()
        out = self._read_output()[0]
        src = _KS4[0]
        for key in ("id", "check_type", "check_expr", "check_sub_value",
                    "answer_index", "options", "strand", "difficulty"):
            assert out[key] == src[key], f"field {key!r} was modified"

    def test_question_untranslated_stays_english(self):
        self._apply()
        records = self._read_output()
        assert records[0]["question"] == _KS4[0]["question"]


class TestApplyPlaceholderWarning(_TmpRepo):
    """A translation that drops a math token must be applied but also logged."""

    SOURCE_RECORDS = [
        {
            "id": "q_math", "lang": "en-GB", "stage": "KS2", "skill": "algebra",
            "difficulty": 2, "type": "mcq",
            "stem": "Solve $x^2 - 4 = 0$ for x.",
            "options": ["2", "-2", "Both 2 and -2", "0"],
            "answer_index": 2, "answer_value": "Both",
            "hint": "", "rationale": "",
            "check_type": "expr", "check_expr": "x^2-4", "check_answer": "2",
            "params": {},
        }
    ]

    def setUp(self):
        super().setUp()
        sid = tpj.seg_id("Solve $x^2 - 4 = 0$ for x.")
        self._write_csv(
            [
                {
                    "seg_id": sid,
                    "source_text": "Solve $x^2 - 4 = 0$ for x.",
                    "locale_target": "de-CH",
                    "translation": "Löse für x.",   # math block deliberately dropped
                    "context_ids": "q_math",
                }
            ]
        )

    def test_translation_still_applied_despite_warning(self):
        self._apply()
        records = self._read_output()
        assert records[0]["stem"] == "Löse für x."

    def test_placeholder_warning_written_to_log(self):
        self._apply()
        log = self._read_log()
        assert "PLACEHOLDER_WARNING" in log
        assert "$x^2 - 4 = 0$" in log


# ===========================================================================
# report smoke test
# ===========================================================================

class TestReport(_TmpRepo):

    def test_report_runs_without_error(self):
        self._extract()
        import io
        buf = io.StringIO()
        with patch("sys.stdout", buf):
            tpj.cmd_report(
                argparse.Namespace(
                    packs=self.PACKS_UNDER_TEST,
                    locales=["de-CH"],
                    samples=False,
                )
            )
        output = buf.getvalue()
        assert "de-CH" in output
        assert "KS2_bank_ok_10000" in output

    def test_report_shows_zero_coverage_before_review(self):
        self._extract()
        import io
        buf = io.StringIO()
        with patch("sys.stdout", buf):
            tpj.cmd_report(
                argparse.Namespace(
                    packs=self.PACKS_UNDER_TEST,
                    locales=["de-CH"],
                    samples=False,
                )
            )
        # All translations empty → 0.0%
        assert "0.0%" in buf.getvalue()

    def test_report_shows_full_coverage_after_review(self):
        self._extract()
        rows = self._read_csv()
        for row in rows:
            row["translation"] = "dummy translation"
        self._write_csv(rows)
        import io
        buf = io.StringIO()
        with patch("sys.stdout", buf):
            tpj.cmd_report(
                argparse.Namespace(
                    packs=self.PACKS_UNDER_TEST,
                    locales=["de-CH"],
                    samples=False,
                )
            )
        assert "100.0%" in buf.getvalue()

    def test_report_no_csv_shows_placeholder_message(self):
        import io
        buf = io.StringIO()
        with patch("sys.stdout", buf):
            tpj.cmd_report(
                argparse.Namespace(
                    packs=self.PACKS_UNDER_TEST,
                    locales=["de-CH"],
                    samples=False,
                )
            )
        assert "no CSV" in buf.getvalue()


if __name__ == "__main__":
    unittest.main(verbosity=2)
