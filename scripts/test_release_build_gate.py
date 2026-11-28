#!/usr/bin/env python3
"""Tests for the production release-build gate (release_build_gate.py and build_release.ps1).

Every test runs the gate inside a throwaway git repository with mocked `flutter`
and `dart` commands placed first on PATH. No real Flutter build runs and no APK
or AAB is created. The approval records written here are synthetic test
fixtures in a temporary folder, never real linguistic approvals.
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import l10n_approval_gate as gate

REPO = Path(__file__).resolve().parent.parent
SCRIPTS = ("release_build_gate.py", "build_release.ps1", "check_enabled_l10n.py", "l10n_approval_gate.py")
AAB = Path("build/app/outputs/bundle/release/app-release.aab")
POWERSHELL = shutil.which("powershell") or shutil.which("pwsh")

LOCALE_SERVICE = """class LocaleService {
  static const List<Locale> productionLocales = [
    Locale('en'),
    Locale('en', 'GB'),
    Locale('de', 'CH'),
    Locale('fr', 'CH'),
    Locale('it', 'CH'),
  ];
}
"""
SWISS = {"de_CH": "Grüezi", "fr_CH": "Salut", "it_CH": "Ciao"}
DRAFT = {"description": "Draft. PENDING LINGUISTIC REVIEW: not approved."}

MOCK_TOOL = r'''
import json, os, sys
from pathlib import Path
tool, args = sys.argv[1], sys.argv[2:]
with open(os.environ["MOCK_LOG"], "a", encoding="utf-8") as f:
    f.write(json.dumps([tool, *args]) + "\n")
root = Path.cwd()
if tool == "flutter" and args[:2] == ["--version", "--machine"]:
    print(json.dumps({"frameworkVersion": "0.0.0-mock", "channel": "mock", "dartSdkVersion": "0.0.0"}))
elif tool == "flutter" and args[:1] == ["gen-l10n"]:
    (root / "untranslated_messages.txt").write_text('{\n  "en_GB": []\n}\n', encoding="utf-8")
    if os.environ.get("MOCK_GENL10N_STALE") == "1":
        with open(root / "lib/l10n/app_localizations.dart", "a", encoding="utf-8") as g:
            g.write("// regenerated\n")
elif tool == "flutter" and args[:2] == ["pub", "get"]:
    (root / "windows/flutter/generated_plugins.cmake").write_text("# regenerated\n", encoding="utf-8")
elif tool == "flutter" and args[:1] == ["build"]:
    if os.environ.get("MOCK_BUILD_FAIL") == "1":
        sys.exit(1)
    if args[1] == "appbundle":
        out = root / "build/app/outputs/bundle/release/app-release.aab"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"MOCK-AAB " + " ".join(args).encode())
    else:
        out = root / "build/web"
        out.mkdir(parents=True, exist_ok=True)
        (out / "index.html").write_text("mock", encoding="utf-8")
elif tool == "dart" and os.environ.get("MOCK_PACKS_FAIL") == "1":
    sys.exit(1)
'''


class Fixture:
    """A minimal releasable repository: every required key has a synthetic approval."""

    def __init__(self, root: Path) -> None:
        self.root = root
        self.bin = root.parent / "mockbin"
        self.log = root.parent / "mock_log.jsonl"
        for d in ("lib/l10n", "lib/services", "docs/l10n_approvals/records", "scripts", "tools",
                  "windows/flutter"):
            (root / d).mkdir(parents=True, exist_ok=True)
        for name in SCRIPTS:
            shutil.copy2(REPO / "scripts" / name, root / "scripts" / name)
        self.write("lib/services/locale_service.dart", LOCALE_SERVICE)
        self.write("pubspec.yaml", "name: fixture\nversion: 1.2.3+45\n")
        self.write("tools/validate_packs.dart", "void main() {}\n")
        self.write("scripts/validate_content_quality.py",
                   "import os, sys\nsys.exit(1 if os.environ.get('MOCK_CQ_FAIL') == '1' else 0)\n")
        self.write("untranslated_messages.txt", '{\n  "en_GB": []\n}\n')
        self.write("windows/flutter/generated_plugins.cmake", "# committed\n")
        self.write("lib/l10n/app_localizations.dart", "// generated\n")
        self.write(".gitignore", "build/\n")
        self.arb("en", {"hello": "Hello", "@hello": {"description": "Greeting"}, "bye": "Bye"})
        self.arb("en_GB", {"hello": "Hello"})
        for lang, word in (("de", "Hallo"), ("fr", "Bonjour"), ("it", "Buongiorno")):
            self.arb(lang, {"hello": word, "bye": word})
        for loc, word in SWISS.items():
            self.arb(loc, {"hello": word})
        self.write_json("docs/l10n_approvals/required_keys.json", {
            "schema": gate.REQUIRED_SCHEMA, "locales": {loc: ["hello"] for loc in SWISS}})
        for loc, word in SWISS.items():
            self.approve(loc, word)
        self.bin.mkdir(exist_ok=True)
        (self.bin / "mock_tool.py").write_text(MOCK_TOOL, encoding="utf-8")
        for tool in ("flutter", "dart"):
            (self.bin / f"{tool}.bat").write_text(
                f'@"{sys.executable}" -B "%~dp0mock_tool.py" {tool} %*\r\n', encoding="utf-8")
        self.git("init", "-q")
        self.git("config", "core.autocrlf", "false")
        self.commit()

    # -- editing -------------------------------------------------------------
    def write(self, rel: str, text: str) -> None:
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8", newline="\n")

    def write_json(self, rel: str, data: object) -> None:
        self.write(rel, json.dumps(data, ensure_ascii=False, indent=2) + "\n")

    def arb(self, locale: str, data: dict) -> None:
        self.write_json(f"lib/l10n/app_{locale}.arb", {"@@locale": locale, **data})

    def approve(self, locale: str, text: str) -> None:
        self.write_json(f"docs/l10n_approvals/records/{locale}_synthetic.json", {
            "schema": gate.RECORD_SCHEMA, "locale": locale,
            "reviewer": "SYNTHETIC TEST FIXTURE", "review_date": "2026-01-01",
            "arb_file": f"lib/l10n/app_{locale}.arb", "approved_arb_sha256": "0" * 64,
            "entries": [{"key": "hello", "outcome": "approved",
                         "approved_text_sha256": gate.text_sha256(text)}]})

    def git(self, *args: str) -> str:
        return subprocess.run(["git", *args], cwd=self.root, check=True, capture_output=True,
                              text=True).stdout

    def commit(self, message: str = "fixture") -> None:
        self.git("add", "-A")
        self.git("-c", "user.name=fixture", "-c", "user.email=fixture@example.invalid",
                 "commit", "-q", "--allow-empty", "-m", message)

    # -- running -------------------------------------------------------------
    def env(self, **extra: str) -> dict:
        env = dict(os.environ)
        env["PATH"] = str(self.bin) + os.pathsep + env.get("PATH", "")
        env["MOCK_LOG"] = str(self.log)
        env.update(extra)
        return env

    def run(self, *args: str, **mock: str) -> subprocess.CompletedProcess:
        return subprocess.run([sys.executable, "-B", str(self.root / "scripts/release_build_gate.py"), *args],
                              cwd=self.root, env=self.env(**mock), capture_output=True, text=True,
                              encoding="utf-8", errors="replace")

    def run_ps1(self, *args: str, **mock: str) -> subprocess.CompletedProcess:
        return subprocess.run([POWERSHELL, "-NoProfile", "-NonInteractive", "-File",
                               str(self.root / "scripts/build_release.ps1"), *args],
                              cwd=self.root, env=self.env(**mock), capture_output=True, text=True,
                              encoding="utf-8", errors="replace")

    def calls(self) -> list[list[str]]:
        if not self.log.exists():
            return []
        return [json.loads(l) for l in self.log.read_text(encoding="utf-8").splitlines() if l]

    def build_calls(self) -> list[list[str]]:
        return [c for c in self.calls() if c[:2] == ["flutter", "build"]]

    def provenance(self) -> list[dict]:
        d = self.root / "build/release_provenance"
        return [json.loads(p.read_text(encoding="utf-8")) for p in sorted(d.glob("*.json"))] if d.exists() else []


class ReleaseBuildGateTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.fx = Fixture(Path(self.tmp.name) / "repo")

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def assertBlockedBeforeBuild(self, proc, step: str) -> dict:
        self.assertEqual(proc.returncode, 1, proc.stdout + proc.stderr)
        self.assertIn("No production build was started", proc.stdout)
        self.assertEqual(self.fx.build_calls(), [])
        self.assertFalse((self.fx.root / AAB).exists(), "no release artefact may exist")
        record = self.fx.provenance()[-1]
        self.assertEqual(record["status"], "blocked")
        self.assertEqual(record["failed_step"], step, record.get("reason"))
        self.assertNotIn("artefact", record)
        return record

    # -- success -------------------------------------------------------------
    def test_successful_validation_pipeline_then_build(self) -> None:
        proc = self.fx.run("--env", "prod", "--target", "appbundle")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        calls = self.fx.calls()
        self.assertEqual(calls, [
            ["flutter", "--version", "--machine"],
            ["flutter", "pub", "get"],
            ["flutter", "gen-l10n"],
            ["dart", "run", "tools/validate_packs.dart"],
            ["flutter", "build", "appbundle", "--release", "--dart-define=ENV=prod"],
        ])
        self.assertTrue((self.fx.root / AAB).is_file())
        steps = [c["step"] for c in self.fx.provenance()[-1]["checks"]]
        self.assertEqual(steps, [
            "repository", "locale-configuration", "toolchain", "pub-get", "gen-l10n",
            "generated-localisations-current", "completeness-and-approval", "approval-gate",
            "packs", "tree-unchanged-before-build", "build"])

    def test_provenance_record(self) -> None:
        proc = self.fx.run("--env", "prod", "--target", "appbundle")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        records = self.fx.provenance()
        self.assertEqual(len(records), 1)
        r = records[0]
        self.assertEqual(r["schema"], "release-build-provenance/v1")
        self.assertEqual(r["status"], "built")
        self.assertEqual(r["git"]["commit"], self.fx.git("rev-parse", "HEAD").strip())
        self.assertTrue(r["git"]["clean_at_start"])
        self.assertEqual(r["configuration"], {
            "env": "prod", "target": "appbundle", "enable_ch_packs": False,
            "build_command": ["flutter", "build", "appbundle", "--release", "--dart-define=ENV=prod"],
            "pubspec_version": "1.2.3+45"})
        self.assertEqual(r["toolchain"]["flutter"], "0.0.0-mock")
        self.assertEqual(r["approval_gate"]["pending"], 0)
        self.assertEqual(r["approval_gate"]["approved"], 3)
        self.assertFalse(r["approval_gate"]["blocking"])
        completeness = next(c for c in r["checks"] if c["step"] == "completeness-and-approval")
        self.assertEqual(completeness["summary"], {"de_CH": 0, "fr_CH": 0, "it_CH": 0})
        data = (self.fx.root / AAB).read_bytes()
        import hashlib
        self.assertEqual(r["artefact"], {"path": AAB.as_posix(),
                                         "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)})
        text = json.dumps(r)
        for leak in (str(self.fx.root), str(self.fx.root).replace("\\", "/"), str(Path.home()),
                     sys.executable, "PATH", "MOCK_LOG", "password", "token", "keystore"):
            self.assertNotIn(leak, text)

    def test_ch_release_runs_strict_content_gate_and_ch_build(self) -> None:
        proc = self.fx.run("--env", "prod", "--target", "appbundle", "--enable-ch-packs")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertIn(["dart", "run", "tools/validate_packs.dart", "--enable-ch-packs"], self.fx.calls())
        self.assertEqual(self.fx.build_calls(), [["flutter", "build", "appbundle", "--release",
                                                  "--dart-define=ENV=prod",
                                                  "--dart-define=ENABLE_CH_PACKS=true"]])
        steps = [c["step"] for c in self.fx.provenance()[-1]["checks"]]
        self.assertIn("ch-content-quality", steps)

    def test_web_target(self) -> None:
        proc = self.fx.run("--env", "prod", "--target", "web")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertEqual(self.fx.provenance()[-1]["artefact"]["path"], "build/web")

    # -- translation failures ------------------------------------------------
    def test_pending_marker_blocks_before_build(self) -> None:
        self.fx.arb("de_CH", {"hello": SWISS["de_CH"], "@hello": DRAFT})
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "completeness-and-approval")
        self.assertEqual(r["approval_gate"]["pending_by_locale"], {"de_CH": 1})

    def test_changed_translation_without_fresh_approval_blocks(self) -> None:
        self.fx.arb("fr_CH", {"hello": "Salut tout le monde"})
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "completeness-and-approval")
        self.assertEqual(r["approval_gate"]["unapproved"], 1)

    def test_missing_approval_records_block(self) -> None:
        shutil.rmtree(self.fx.root / "docs/l10n_approvals/records")
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "completeness-and-approval")
        self.assertEqual(r["approval_gate"]["unapproved"], 3)
        self.assertEqual(r["approval_gate"]["approved"], 0)

    def test_untranslated_required_key_blocks(self) -> None:
        self.fx.arb("en", {"hello": "Hello", "bye": "Bye", "newKey": "New"})
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "completeness-and-approval")
        summary = next(c for c in r["checks"] if c["step"] == "completeness-and-approval")["summary"]
        self.assertEqual(summary, {"de_CH": 1, "fr_CH": 1, "it_CH": 1})

    def test_invalid_approval_record_blocks(self) -> None:
        self.fx.write("docs/l10n_approvals/records/it_CH_synthetic.json", "{not json")
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "completeness-and-approval")
        self.assertEqual(r["approval_gate"]["invalid_records"], 1)

    # -- configuration failures ----------------------------------------------
    def test_missing_production_arb_blocks(self) -> None:
        (self.fx.root / "lib/l10n/app_fr_CH.arb").unlink()
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "locale-configuration")
        self.assertIn("app_fr_CH.arb", r["reason"])
        self.assertEqual(self.fx.calls(), [], "no Flutter command may run")

    def test_malformed_production_arb_blocks(self) -> None:
        self.fx.write("lib/l10n/app_it_CH.arb", "{ broken")
        self.fx.commit()
        self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                      "locale-configuration")

    def test_missing_required_keys_manifest_blocks(self) -> None:
        (self.fx.root / "docs/l10n_approvals/required_keys.json").unlink()
        self.fx.commit()
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "locale-configuration")
        self.assertIn("required_keys.json is missing", r["reason"])

    def test_malformed_required_keys_manifest_blocks(self) -> None:
        for bad in ("{oops", json.dumps({"schema": "wrong/v0", "locales": {"de_CH": ["hello"]}}),
                    json.dumps({"schema": gate.REQUIRED_SCHEMA, "locales": {}}),
                    json.dumps({"schema": gate.REQUIRED_SCHEMA, "locales": {"xx_YY": ["hello"]}})):
            with self.subTest(manifest=bad[:30]):
                self.fx.write("docs/l10n_approvals/required_keys.json", bad)
                self.fx.commit()
                self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                              "locale-configuration")

    def test_unsupported_production_locale_configuration_blocks(self) -> None:
        cases = {
            "extra locale": LOCALE_SERVICE.replace("Locale('it', 'CH'),",
                                                   "Locale('it', 'CH'),\n    Locale('es', 'ES'),"),
            "missing locale": LOCALE_SERVICE.replace("    Locale('it', 'CH'),\n", ""),
            "no list": "class LocaleService {}\n",
        }
        for name, source in cases.items():
            with self.subTest(case=name):
                self.fx.write("lib/services/locale_service.dart", source)
                self.fx.commit()
                self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                              "locale-configuration")

    # -- repository and generated files --------------------------------------
    def test_dirty_working_tree_blocks(self) -> None:
        self.fx.write("lib/l10n/app_de_CH.arb", json.dumps({"@@locale": "de_CH", "hello": "Hoi"}))
        r = self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                          "repository")
        self.assertIn("lib/l10n/app_de_CH.arb", r["git"]["dirty_paths"])

    def test_untracked_file_blocks(self) -> None:
        self.fx.write("docs/l10n_approvals/records/extra.json", "{}")
        self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"), "repository")

    def test_stale_generated_localisations_block(self) -> None:
        r = self.assertBlockedBeforeBuild(
            self.fx.run("--env", "prod", "--target", "appbundle", MOCK_GENL10N_STALE="1"),
            "generated-localisations-current")
        self.assertIn("lib/l10n/app_localizations.dart", r["reason"])

    def test_pack_validation_failure_blocks(self) -> None:
        self.assertBlockedBeforeBuild(
            self.fx.run("--env", "prod", "--target", "appbundle", MOCK_PACKS_FAIL="1"), "packs")

    def test_ch_content_gate_failure_blocks(self) -> None:
        self.assertBlockedBeforeBuild(
            self.fx.run("--env", "prod", "--target", "appbundle", "--enable-ch-packs", MOCK_CQ_FAIL="1"),
            "ch-content-quality")

    def test_stale_artefact_is_removed_when_validation_fails(self) -> None:
        (self.fx.root / AAB).parent.mkdir(parents=True)
        (self.fx.root / AAB).write_bytes(b"old build")
        self.fx.arb("de_CH", {"hello": SWISS["de_CH"], "@hello": DRAFT})
        self.fx.commit()
        self.assertBlockedBeforeBuild(self.fx.run("--env", "prod", "--target", "appbundle"),
                                      "completeness-and-approval")

    def test_build_failure_is_reported(self) -> None:
        proc = self.fx.run("--env", "prod", "--target", "appbundle", MOCK_BUILD_FAIL="1")
        self.assertEqual(proc.returncode, 3, proc.stdout + proc.stderr)
        r = self.fx.provenance()[-1]
        self.assertEqual(r["status"], "build_failed")
        self.assertNotIn("artefact", r)

    # -- arguments -----------------------------------------------------------
    def test_invalid_arguments_are_rejected_before_anything_runs(self) -> None:
        for args in ([], ["--env", "uat", "--target", "appbundle"], ["--env", "dev", "--target", "web"],
                     ["--env", "prod"], ["--env", "prod", "--target", "apk"],
                     ["--env", "prod", "--target", "appbundle", "--force"],
                     ["--env", "prod", "--target", "appbundle", "--skip-gate"],
                     ["--env", "prod", "--target", "appbundle", "--", "--dart-define=ENV=dev"],
                     ["--env", "prod", "--target", "appbundle", "--enable"]):
            with self.subTest(args=args):
                proc = self.fx.run(*args)
                self.assertEqual(proc.returncode, 2, proc.stdout + proc.stderr)
        self.assertEqual(self.fx.calls(), [])
        self.assertEqual(self.fx.provenance(), [])

    def test_no_force_skip_or_bypass_option_exists(self) -> None:
        help_text = self.fx.run("--help").stdout
        options = sorted({w.rstrip(",") for w in help_text.split() if w.startswith("--")})
        self.assertEqual(options, ["--enable-ch-packs", "--env", "--help", "--target"])
        for path in ("scripts/release_build_gate.py", "scripts/build_release.ps1"):
            source = (REPO / path).read_text(encoding="utf-8").lower()
            for word in ("--force", "--skip", "--no-verify", "-force", "-skip", "bypass ="):
                self.assertNotIn(word, source.replace("no force, skip or bypass", ""), path)

    # -- PowerShell entry point ----------------------------------------------
    @unittest.skipUnless(POWERSHELL, "PowerShell not available")
    def test_ps1_wrapper_builds_after_validation(self) -> None:
        proc = self.fx.run_ps1("-Environment", "prod", "-Target", "appbundle")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertEqual(len(self.fx.build_calls()), 1)
        self.assertEqual(self.fx.provenance()[-1]["status"], "built")

    @unittest.skipUnless(POWERSHELL, "PowerShell not available")
    def test_ps1_wrapper_blocks_and_rejects_invalid_arguments(self) -> None:
        self.fx.arb("it_CH", {"hello": SWISS["it_CH"], "@hello": DRAFT})
        self.fx.commit()
        proc = self.fx.run_ps1("-Environment", "prod", "-Target", "appbundle")
        self.assertEqual(proc.returncode, 1, proc.stdout + proc.stderr)
        self.assertEqual(self.fx.build_calls(), [])
        before = len(self.fx.provenance())
        for args in (["-Environment", "uat", "-Target", "appbundle"],
                     ["-Environment", "prod", "-Target", "apk"],
                     ["-Environment", "prod", "-Target", "appbundle", "-Force"],
                     ["-Environment", "prod", "-Target", "appbundle", "extra"]):
            with self.subTest(args=args):
                self.assertNotEqual(self.fx.run_ps1(*args).returncode, 0)
        self.assertEqual(self.fx.build_calls(), [])
        self.assertEqual(len(self.fx.provenance()), before, "rejected arguments must not start the gate")


class CurrentRepositoryStateTest(unittest.TestCase):
    """The repository's current translations must block a production build.

    Pinned to the Swiss Phase 2 state (754 pending, 199/200/200 untranslated),
    like EXPECTED_PENDING in test_l10n_approval_gate.py. Update it when
    approvals or translations land.
    """

    def test_current_translations_block_before_any_build(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            fx = Fixture(Path(tmp) / "repo")
            for arb in (REPO / "lib/l10n").glob("*.arb"):
                shutil.copy2(arb, fx.root / "lib/l10n" / arb.name)
            shutil.copy2(REPO / "lib/services/locale_service.dart", fx.root / "lib/services/locale_service.dart")
            shutil.rmtree(fx.root / "docs/l10n_approvals")
            shutil.copytree(REPO / "docs/l10n_approvals", fx.root / "docs/l10n_approvals")
            fx.commit("current repository translations")
            proc = fx.run("--env", "prod", "--target", "appbundle")
            self.assertEqual(proc.returncode, 1, proc.stdout + proc.stderr)
            self.assertEqual(fx.build_calls(), [])
            self.assertFalse((fx.root / AAB).exists())
            r = fx.provenance()[-1]
            self.assertEqual(r["failed_step"], "completeness-and-approval")
            summary = next(c for c in r["checks"] if c["step"] == "completeness-and-approval")["summary"]
            self.assertEqual(summary, {"de_CH": 199, "fr_CH": 200, "it_CH": 200})
            self.assertEqual(r["approval_gate"]["pending_by_locale"],
                             {"de_CH": 267, "fr_CH": 256, "it_CH": 231})
            self.assertEqual(r["approval_gate"]["pending"], 754)
            self.assertEqual(r["approval_gate"]["approved"], 0)


if __name__ == "__main__":
    unittest.main()
