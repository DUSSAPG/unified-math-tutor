#!/usr/bin/env python3
"""Tests for the production linguistic-approval gate (l10n_approval_gate)."""

from __future__ import annotations

import datetime as dt
import io
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

import l10n_approval_gate as gate

REPO = Path(__file__).resolve().parent.parent
TODAY = dt.date(2026, 11, 27)
LOCALE_SERVICE = """
class LocaleService {
  static const List<Locale> supported = [Locale('en'), Locale('sv')];
  static const List<Locale> productionLocales = [
    Locale('en'),
    Locale('en', 'GB'),
    Locale('de', 'CH'),
  ];
}
"""
DRAFT = {"description": "AS-1 draft translation. PENDING LINGUISTIC REVIEW: not approved."}


class SyntheticRepo:
    """A minimal repository layout the gate can evaluate."""

    def __init__(self, root: Path) -> None:
        self.root = root
        (root / "lib" / "l10n").mkdir(parents=True)
        (root / "lib" / "services").mkdir(parents=True)
        (root / "docs" / "l10n_approvals" / "records").mkdir(parents=True)
        (root / "lib" / "services" / "locale_service.dart").write_text(
            LOCALE_SERVICE, encoding="utf-8")
        self.write_arb("en", {"greeting": "Hello", "size": "Small"})
        self.write_arb("en_GB", {"greeting": "Hello"})
        self.write_arb("de_CH", {"greeting": "Hallo", "@greeting": DRAFT,
                                 "size": "Klein", "@size": DRAFT})
        self.write_json("docs/l10n_approvals/required_keys.json", {
            "schema": gate.REQUIRED_SCHEMA,
            "locales": {"de_CH": ["greeting", "size"]},
        })

    def write_json(self, rel: str, data: object) -> None:
        (self.root / rel).write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")

    def write_arb(self, locale: str, data: dict) -> None:
        self.write_json(f"lib/l10n/app_{locale}.arb", {"@@locale": locale, **data})

    def remove_markers(self) -> None:
        self.write_arb("de_CH", {"greeting": "Hallo", "size": "Klein"})

    def record(self, name: str = "de_CH_review.json", **overrides) -> dict:
        record = {
            "schema": gate.RECORD_SCHEMA,
            "locale": "de_CH",
            "reviewer": "Reviewer ref R-001",
            "review_date": "2026-11-20",
            "arb_file": "lib/l10n/app_de_CH.arb",
            "approved_arb_sha256": "a" * 64,
            "entries": [
                {"key": "greeting", "outcome": "approved",
                 "approved_text_sha256": gate.text_sha256("Hallo")},
                {"key": "size", "outcome": "approved_with_changes",
                 "approved_text_sha256": gate.text_sha256("Klein")},
            ],
        }
        record.update(overrides)
        self.write_json(f"docs/l10n_approvals/records/{name}", record)
        return record

    def evaluate(self, env: str = "prod") -> gate.Result:
        return gate.evaluate(self.root, env, today=TODAY)


class SyntheticGateTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.repo = SyntheticRepo(Path(self.tmp.name))

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def test_reads_production_locales_from_locale_service(self) -> None:
        self.assertEqual(gate.production_locales(gate.Paths(self.repo.root)),
                         ["en", "en_GB", "de_CH"])

    def test_pending_markers_block_production(self) -> None:
        result = self.repo.evaluate("prod")
        self.assertEqual(result.pending, [("de_CH", "greeting"), ("de_CH", "size")])
        self.assertTrue(result.blocking)

    def test_dev_and_uat_report_but_do_not_block(self) -> None:
        for env in ("dev", "uat"):
            result = self.repo.evaluate(env)
            self.assertEqual(len(result.pending), 2, env)
            self.assertFalse(result.blocking, env)

    def test_marker_removal_without_record_does_not_pass(self) -> None:
        self.repo.remove_markers()
        result = self.repo.evaluate("prod")
        self.assertEqual(result.pending, [])
        self.assertEqual([(l, k) for l, k, _ in result.unapproved],
                         [("de_CH", "greeting"), ("de_CH", "size")])
        self.assertTrue(all("no valid approval record" in why
                            for _, _, why in result.unapproved))
        self.assertTrue(result.blocking)

    def test_valid_record_is_recognised(self) -> None:
        self.repo.remove_markers()
        self.repo.record()
        result = self.repo.evaluate("prod")
        self.assertEqual(result.problems, 0)
        self.assertEqual(result.approved, [("de_CH", "greeting"), ("de_CH", "size")])
        self.assertFalse(result.blocking)

    def test_record_does_not_override_a_remaining_marker(self) -> None:
        self.repo.record()  # markers still present
        result = self.repo.evaluate("prod")
        self.assertEqual(len(result.pending), 2)
        self.assertTrue(result.blocking)

    def test_text_changed_after_approval_needs_a_new_review(self) -> None:
        self.repo.record()
        self.repo.write_arb("de_CH", {"greeting": "Grüezi", "size": "Klein"})
        result = self.repo.evaluate("prod")
        self.assertEqual(result.unapproved,
                         [("de_CH", "greeting",
                           "text changed after approval; needs a new review")])
        self.assertTrue(result.blocking)

    def test_rejected_text_blocks(self) -> None:
        self.repo.remove_markers()
        record = self.repo.record()
        record["entries"][0]["outcome"] = "rejected"
        self.repo.write_json("docs/l10n_approvals/records/de_CH_review.json", record)
        result = self.repo.evaluate("prod")
        self.assertIn(("de_CH", "greeting", "the current text was rejected"),
                      result.unapproved)
        self.assertTrue(result.blocking)

    def test_record_for_another_locale_does_not_approve(self) -> None:
        self.repo.remove_markers()
        self.repo.record(locale="en_GB", arb_file="lib/l10n/app_en_GB.arb")
        result = self.repo.evaluate("prod")
        self.assertEqual(len(result.unapproved), 2)
        self.assertTrue(result.blocking)

    def test_incomplete_records_are_rejected(self) -> None:
        cases = {
            "reviewer": {"reviewer": "TBD"},
            "reviewer missing": {"reviewer": ""},
            "date": {"review_date": "27/11/2026"},
            "future date": {"review_date": "2026-12-31"},
            "arb hash": {"approved_arb_sha256": "not-a-hash"},
            "file": {"arb_file": "lib/l10n/app_fr_CH.arb"},
            "schema": {"schema": "something-else"},
            "entries": {"entries": []},
            "outcome": {"entries": [{"key": "greeting", "outcome": "looks fine",
                                     "approved_text_sha256": gate.text_sha256("Hallo")}]},
            "text hash": {"entries": [{"key": "greeting", "outcome": "approved"}]},
        }
        for name, override in cases.items():
            with self.subTest(name):
                self.repo.remove_markers()
                for f in (self.repo.root / "docs/l10n_approvals/records").glob("*.json"):
                    f.unlink()
                self.repo.record(**override)
                result = self.repo.evaluate("prod")
                self.assertTrue(result.invalid_records, name)
                self.assertEqual(result.approved, [], name)
                self.assertTrue(result.blocking, name)

    def test_unparseable_record_blocks_production(self) -> None:
        self.repo.remove_markers()
        self.repo.record()
        (self.repo.root / "docs/l10n_approvals/records/broken.json").write_text(
            "{not json", encoding="utf-8")
        result = self.repo.evaluate("prod")
        self.assertEqual(result.invalid_records, [("broken.json", "not valid JSON")])
        self.assertTrue(result.blocking)

    def test_marker_outside_the_required_list_still_blocks(self) -> None:
        self.repo.write_arb("en_GB", {"greeting": "Hello", "@greeting": DRAFT})
        result = self.repo.evaluate("prod")
        self.assertIn(("en_GB", "greeting"), result.pending)

    def test_missing_or_malformed_required_keys_fails_closed(self) -> None:
        manifest = self.repo.root / "docs/l10n_approvals/required_keys.json"
        cases = {
            "missing": None,
            "not json": "{not json",
            "wrong schema": json.dumps({"schema": "x", "locales": {"de_CH": ["greeting"]}}),
            "no locales": json.dumps({"schema": gate.REQUIRED_SCHEMA, "locales": {}}),
            "locales absent": json.dumps({"schema": gate.REQUIRED_SCHEMA}),
            "empty key list": json.dumps({"schema": gate.REQUIRED_SCHEMA,
                                          "locales": {"de_CH": []}}),
            "non-production locale": json.dumps({"schema": gate.REQUIRED_SCHEMA,
                                                 "locales": {"de_CH": ["greeting", "size"],
                                                             "sv": ["greeting"]}}),
        }
        for name, content in cases.items():
            with self.subTest(name):
                self.repo.remove_markers()  # the case a missing manifest would hide
                if content is None:
                    manifest.unlink(missing_ok=True)
                else:
                    manifest.write_text(content, encoding="utf-8")
                result = self.repo.evaluate("prod")
                self.assertTrue(result.config_problems, name)
                self.assertTrue(result.blocking, name)
                for env in ("dev", "uat"):
                    self.assertFalse(self.repo.evaluate(env).blocking, (name, env))

    def test_report_names_keys_but_never_text_or_reviewer(self) -> None:
        self.repo.remove_markers()
        self.repo.record(entries=[{"key": "greeting", "outcome": "approved",
                                   "approved_text_sha256": gate.text_sha256("Hallo")}])
        out = io.StringIO()
        gate.report(self.repo.evaluate("prod"), out=out)
        text = out.getvalue()
        self.assertIn("de_CH  size", text)
        for secret in ("Hallo", "Klein", "Reviewer ref R-001"):
            self.assertNotIn(secret, text)


class RepositoryGateTest(unittest.TestCase):
    """The real repository: the AS-1 Swiss drafts are not approved."""

    def test_production_release_fails_with_the_99_as1_drafts(self) -> None:
        result = gate.evaluate(REPO, "prod")
        counts: dict[str, int] = {}
        for locale, _ in result.pending:
            counts[locale] = counts.get(locale, 0) + 1
        self.assertEqual(counts, {"de_CH": 33, "fr_CH": 33, "it_CH": 33})
        self.assertEqual(result.approved, [])
        self.assertTrue(result.blocking)

    def test_dev_and_uat_validation_remain_available(self) -> None:
        for env in ("dev", "uat"):
            result = gate.evaluate(REPO, env)
            self.assertEqual(len(result.pending), 99, env)
            self.assertFalse(result.blocking, env)

    def test_production_locales_match_locale_service(self) -> None:
        self.assertEqual(gate.production_locales(gate.Paths(REPO)),
                         ["en", "en_GB", "de_CH", "fr_CH", "it_CH"])

    def test_required_keys_cover_every_current_draft(self) -> None:
        required, config_problems = gate.load_required(gate.Paths(REPO))
        self.assertEqual(config_problems, [])
        pending = gate.evaluate(REPO, "prod").pending
        for locale, key in pending:
            self.assertIn(key, required.get(locale, []), f"{locale} {key}")
        self.assertEqual({l: len(k) for l, k in required.items()},
                         {"de_CH": 33, "fr_CH": 33, "it_CH": 33})

    def test_no_approval_records_exist(self) -> None:
        records = REPO / "docs" / "l10n_approvals" / "records"
        self.assertEqual(sorted(records.glob("*.json")) if records.exists() else [], [])

    def test_cli_exit_codes(self) -> None:
        script = Path(gate.__file__)
        for env, expected in (("prod", 1), ("uat", 0), ("dev", 0)):
            done = subprocess.run(
                [shutil.which("py") or "python", str(script), "--env", env,
                 "--root", str(REPO)],
                capture_output=True, text=True, encoding="utf-8")
            self.assertEqual(done.returncode, expected, done.stdout + done.stderr)


if __name__ == "__main__":
    unittest.main()
