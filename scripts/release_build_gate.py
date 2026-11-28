#!/usr/bin/env python3
"""Production release-build gate: validate, then build. Entry point: scripts/build_release.ps1.

Runs the existing localisation checks before any production Flutter build and
refuses to build unless every check passes:

 1. arguments: production only (`--env prod`), an approved target, no extra options;
 2. repository: run from the repository root, with a clean working tree;
 3. locale configuration: `LocaleService.productionLocales` must match the locales
    the completeness check covers, and every production ARB, the template and
    `docs/l10n_approvals/required_keys.json` must exist and parse;
 4. `flutter pub get` and `flutter gen-l10n`; the committed generated
    localisation files must be unchanged afterwards;
 5. `scripts/check_enabled_l10n.py --env prod` (completeness and approval);
 6. `scripts/l10n_approval_gate.py --env prod` (linguistic approval);
 7. the pack validation for the chosen release path (strict CH content gate
    when `--enable-ch-packs` is given);
 8. only then the approved build command
    `flutter build <target> --release --dart-define=ENV=prod [--dart-define=ENABLE_CH_PACKS=true]`.

The gate stops at the first failure. There is deliberately no force, skip or
bypass option. Every run, passed or blocked, writes a provenance record to
`build/release_provenance/`. It holds the commit, configuration, check results
and artefact hash, and never environment variables, credentials or absolute
paths. A provenance record is evidence of what was checked, not a release approval.

Exit codes: 0 built; 1 blocked by a check; 2 invalid arguments; 3 build failed.
"""

from __future__ import annotations

import argparse
import datetime as _dt
import hashlib
import json
import platform
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parent
ROOT = SCRIPTS.parent
sys.path.insert(0, str(SCRIPTS))
import check_enabled_l10n  # noqa: E402
import l10n_approval_gate as gate  # noqa: E402

SCHEMA = "release-build-provenance/v1"
ENVIRONMENTS = ("prod",)
TARGETS = {
    "appbundle": Path("build/app/outputs/bundle/release/app-release.aab"),
    "web": Path("build/web"),
}
PROVENANCE_DIR = Path("build/release_provenance")
# Files that `flutter pub get`, `flutter gen-l10n` and `check_enabled_l10n.py`
# rewrite on every run on this host. Any other change during validation blocks.
ALLOWED_SIDE_EFFECTS = frozenset({
    "untranslated_messages.txt",
    "linux/flutter/generated_plugin_registrant.cc",
    "linux/flutter/generated_plugin_registrant.h",
    "linux/flutter/generated_plugins.cmake",
    "macos/Flutter/GeneratedPluginRegistrant.swift",
    "windows/flutter/generated_plugin_registrant.cc",
    "windows/flutter/generated_plugin_registrant.h",
    "windows/flutter/generated_plugins.cmake",
})

EXIT_BUILT, EXIT_BLOCKED, EXIT_USAGE, EXIT_BUILD_FAILED = 0, 1, 2, 3


class Blocked(Exception):
    """A check failed; the build must not run."""

    def __init__(self, step: str, reason: str):
        super().__init__(f"{step}: {reason}")
        self.step = step
        self.reason = reason


def _utc() -> str:
    return _dt.datetime.now(_dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _rel(path: Path) -> str:
    try:
        return path.resolve().relative_to(ROOT).as_posix()
    except ValueError:
        return path.name


def build_command(target: str, enable_ch_packs: bool) -> list[str]:
    cmd = ["flutter", "build", target, "--release", "--dart-define=ENV=prod"]
    if enable_ch_packs:
        cmd.append("--dart-define=ENABLE_CH_PACKS=true")
    return cmd


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="release_build_gate.py", allow_abbrev=False,
        description="Validate localisation and approval, then run the production build.")
    parser.add_argument("--env", required=True, choices=ENVIRONMENTS,
                        help="release environment; only prod is accepted")
    parser.add_argument("--target", required=True, choices=sorted(TARGETS),
                        help="approved production build target")
    parser.add_argument("--enable-ch-packs", action="store_true",
                        help="CH content release: also run the strict CH content gate "
                             "and build with ENABLE_CH_PACKS=true")
    return parser.parse_args(argv)


class Gate:
    def __init__(self, args: argparse.Namespace):
        self.args = args
        self.started = time.monotonic()
        self.record: dict = {
            "schema": SCHEMA,
            "notice": "Evidence of the checks run before a production build. "
                      "Not a linguistic approval and not a public-release approval.",
            "started_at": _utc(),
            "status": "running",
            "configuration": {
                "env": args.env,
                "target": args.target,
                "enable_ch_packs": bool(args.enable_ch_packs),
                "build_command": build_command(args.target, args.enable_ch_packs),
            },
            "checks": [],
        }

    # -- helpers -------------------------------------------------------------
    def _tool(self, name: str) -> str:
        path = shutil.which(name)
        if not path:
            raise Blocked("toolchain", f"'{name}' was not found on PATH")
        return path

    def _run(self, step: str, display: list[str], argv: list[str], *, summary=None) -> str:
        print(f"[release-gate] {step}: {' '.join(display)}", flush=True)
        t0 = time.monotonic()
        try:
            proc = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True,
                                  encoding="utf-8", errors="replace")
        except OSError as exc:
            raise Blocked(step, f"could not start {display[0]}: {type(exc).__name__}") from None
        output = (proc.stdout or "") + (proc.stderr or "")
        if output.strip():
            print(output.rstrip(), flush=True)
        entry = {"step": step, "command": display, "exit_code": proc.returncode,
                 "duration_s": round(time.monotonic() - t0, 1)}
        if summary:
            entry["summary"] = summary(output)
        self.record["checks"].append(entry)
        if proc.returncode != 0:
            raise Blocked(step, f"exited with code {proc.returncode}")
        return output

    def _flutter(self, step: str, *args: str, summary=None) -> str:
        return self._run(step, ["flutter", *args], [self._tool("flutter"), *args], summary=summary)

    def _python(self, step: str, script: str, *args: str, summary=None) -> str:
        return self._run(step, ["python", script, *args], [sys.executable, "-B", script, *args],
                         summary=summary)

    def _git(self, *args: str) -> str:
        try:
            proc = subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True,
                                  encoding="utf-8", errors="replace")
        except OSError:
            raise Blocked("repository", "git is not available") from None
        if proc.returncode != 0:
            raise Blocked("repository", f"git {' '.join(args)} failed")
        return proc.stdout

    def _changed_paths(self) -> set[str]:
        out = self._git("status", "--porcelain", "--untracked-files=all")
        return {line[3:].strip().strip('"') for line in out.splitlines() if line.strip()}

    def _pass(self, step: str, **details) -> None:
        self.record["checks"].append({"step": step, "exit_code": 0, **details})

    # -- checks --------------------------------------------------------------
    def check_repository(self) -> None:
        top = Path(self._git("rev-parse", "--show-toplevel").strip())
        if top.resolve() != ROOT.resolve():
            raise Blocked("repository", "the gate must run from the repository's own scripts folder")
        commit = self._git("rev-parse", "HEAD").strip()
        branch = self._git("rev-parse", "--abbrev-ref", "HEAD").strip()
        self.record["git"] = {"commit": commit, "branch": branch}
        changed = sorted(self._changed_paths())
        if changed:
            self.record["git"]["dirty_paths"] = changed[:50]
            raise Blocked("repository", f"working tree is not clean ({len(changed)} changed or "
                                        "untracked paths); commit or restore them first")
        self.record["git"]["clean_at_start"] = True
        self._pass("repository")

    def check_locale_configuration(self) -> None:
        step = "locale-configuration"
        paths = gate.Paths(ROOT)
        try:
            production = gate.production_locales(paths)
        except (OSError, ValueError) as exc:
            raise Blocked(step, f"production locales unreadable: {exc}") from None
        regional = sorted(loc for loc in production if not loc.startswith("en"))
        enabled = sorted(check_enabled_l10n.ENABLED)
        if regional != enabled:
            raise Blocked(step, f"production locales {regional} do not match the locales the "
                                f"completeness check covers {enabled}; this configuration is unsupported")
        arb_dir = ROOT / "lib" / "l10n"
        needed = {"app_en.arb"} | {f"app_{loc}.arb" for loc in production}
        needed |= {f"app_{loc.split('_', 1)[0]}.arb" for loc in production}
        for name in sorted(needed):
            path = arb_dir / name
            if not path.is_file():
                raise Blocked(step, f"production ARB missing: lib/l10n/{name}")
            try:
                data = json.loads(path.read_text(encoding="utf-8-sig"))
            except (OSError, ValueError):
                raise Blocked(step, f"production ARB unreadable: lib/l10n/{name}") from None
            if not isinstance(data, dict) or not data:
                raise Blocked(step, f"production ARB empty or malformed: lib/l10n/{name}")
        _, problems = gate.load_required(paths, production)
        if problems:
            raise Blocked(step, "approval manifest invalid: " + "; ".join(problems))
        self.record["locales"] = {"production": production, "completeness_checked": enabled}
        self._pass(step)

    def remove_stale_artefact(self) -> None:
        out = ROOT / TARGETS[self.args.target]
        if out.is_dir():
            shutil.rmtree(out)
        elif out.exists():
            out.unlink()

    def check_generated_current(self, step: str) -> None:
        unexpected = sorted(p for p in self._changed_paths() if p not in ALLOWED_SIDE_EFFECTS)
        if unexpected:
            raise Blocked(step, "files changed during validation (generated localisations out of "
                                "date or tree modified): " + ", ".join(unexpected[:20]))
        self._pass(step)

    @staticmethod
    def _completeness(output: str) -> dict:
        return {m.group(1): int(m.group(2))
                for m in re.finditer(r"^(\w+): untranslated=(\d+)", output, re.M)}

    @staticmethod
    def _gate_summary(output: str) -> str:
        lines = [l.strip() for l in output.splitlines() if "pending drafts:" in l or "RESULT:" in l]
        return " | ".join(lines)

    def record_gate_state(self) -> None:
        """Read-only gate evaluation for the provenance record (counts only)."""
        try:
            r = gate.evaluate(ROOT, "prod")
        except Exception as exc:  # unreadable configuration is already a failure
            self.record["approval_gate"] = {"error": type(exc).__name__}
            return
        by_locale: dict[str, int] = {}
        for loc, _ in r.pending:
            by_locale[loc] = by_locale.get(loc, 0) + 1
        self.record["approval_gate"] = {
            "pending": len(r.pending), "pending_by_locale": dict(sorted(by_locale.items())),
            "unapproved": len(r.unapproved), "invalid_records": len(r.invalid_records),
            "config_problems": len(r.config_problems), "approved": len(r.approved),
            "blocking": r.blocking,
        }

    def flutter_version(self) -> None:
        out = self._flutter("toolchain", "--version", "--machine")
        try:
            info = json.loads(out[out.index("{"):out.rindex("}") + 1])
            self.record["toolchain"] = {
                "flutter": info.get("frameworkVersion"), "dart": info.get("dartSdkVersion"),
                "channel": info.get("channel"), "python": platform.python_version()}
        except ValueError:
            self.record["toolchain"] = {"flutter": "unknown", "python": platform.python_version()}

    def pubspec_version(self) -> None:
        text = (ROOT / "pubspec.yaml").read_text(encoding="utf-8")
        m = re.search(r"^version:\s*(\S+)", text, re.M)
        self.record["configuration"]["pubspec_version"] = m.group(1) if m else None

    def artefact(self) -> dict:
        out = ROOT / TARGETS[self.args.target]
        if out.is_file():
            data = out.read_bytes()
            return {"path": _rel(out), "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}
        if out.is_dir():
            h = hashlib.sha256()
            files = sorted(p for p in out.rglob("*") if p.is_file())
            for p in files:
                h.update(p.relative_to(out).as_posix().encode() + b"\0")
                h.update(hashlib.sha256(p.read_bytes()).digest())
            return {"path": _rel(out), "sha256_tree": h.hexdigest(), "files": len(files)}
        raise Blocked("build", f"expected artefact not found: {_rel(out)}")

    # -- pipeline ------------------------------------------------------------
    def validate(self) -> None:
        self.check_repository()
        self.check_locale_configuration()
        self.pubspec_version()
        self.remove_stale_artefact()
        self.flutter_version()
        self._flutter("pub-get", "pub", "get")
        self._flutter("gen-l10n", "gen-l10n")
        self.check_generated_current("generated-localisations-current")
        try:
            self._python("completeness-and-approval", "scripts/check_enabled_l10n.py",
                         "--env", "prod", summary=self._completeness)
        finally:
            self.record_gate_state()
        self._python("approval-gate", "scripts/l10n_approval_gate.py", "--env", "prod",
                     summary=self._gate_summary)
        if self.args.enable_ch_packs:
            self._run("ch-packs", ["dart", "run", "tools/validate_packs.dart", "--enable-ch-packs"],
                      [self._tool("dart"), "run", "tools/validate_packs.dart", "--enable-ch-packs"])
            self._python("ch-content-quality", "scripts/validate_content_quality.py", "--strict-ch")
        else:
            self._run("packs", ["dart", "run", "tools/validate_packs.dart"],
                      [self._tool("dart"), "run", "tools/validate_packs.dart"])
        self.check_generated_current("tree-unchanged-before-build")
        if self._git("rev-parse", "HEAD").strip() != self.record["git"]["commit"]:
            raise Blocked("repository", "HEAD moved during validation")

    def build(self) -> None:
        cmd = build_command(self.args.target, self.args.enable_ch_packs)
        self._flutter("build", *cmd[1:])
        self.record["artefact"] = self.artefact()

    def write_provenance(self) -> Path:
        self.record["finished_at"] = _utc()
        self.record["duration_s"] = round(time.monotonic() - self.started, 1)
        directory = ROOT / PROVENANCE_DIR
        directory.mkdir(parents=True, exist_ok=True)
        stamp = _dt.datetime.now(_dt.timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
        sha = (self.record.get("git") or {}).get("commit", "nocommit")[:12]
        path = directory / f"{stamp}_{sha}_{self.args.target}_{self.record['status']}.json"
        path.write_text(json.dumps(self.record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        return path


def main(argv: list[str] | None = None) -> int:
    try:
        args = parse_args(argv)
    except SystemExit as exc:
        return EXIT_USAGE if exc.code else EXIT_BUILT
    g = Gate(args)
    code = EXIT_BUILT
    try:
        g.validate()
    except Blocked as exc:
        g.record.update(status="blocked", failed_step=exc.step, reason=exc.reason)
        code = EXIT_BLOCKED
    except Exception as exc:  # fail closed on anything unexpected
        g.record.update(status="blocked", failed_step="internal",
                        reason=f"unexpected error during validation: {type(exc).__name__}")
        code = EXIT_BLOCKED
    else:
        try:
            g.build()
            g.record["status"] = "built"
        except Blocked as exc:
            g.record.update(status="build_failed", failed_step=exc.step, reason=exc.reason)
            code = EXIT_BUILD_FAILED
    path = g.write_provenance()
    if code == EXIT_BLOCKED:
        print(f"[release-gate] BLOCKED at {g.record['failed_step']}: {g.record['reason']}")
        print("[release-gate] No production build was started.")
    elif code == EXIT_BUILD_FAILED:
        print(f"[release-gate] BUILD FAILED: {g.record['reason']}")
    else:
        print("[release-gate] Validation passed and the production build completed.")
    print(f"[release-gate] Provenance: {_rel(path)}")
    return code


if __name__ == "__main__":
    raise SystemExit(main())
