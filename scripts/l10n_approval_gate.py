#!/usr/bin/env python3
"""Linguistic-approval gate for production releases.

Part of the existing release validation (`check_enabled_l10n.py`, run by
`release_readiness.ps1`). It fails a production release when any
production-locale translation is still a draft, or when a translation that
requires linguistic review has no valid approval record.

Rules:
* Every production ARB (read from `LocaleService.productionLocales`) is
  scanned for the draft marker "PENDING LINGUISTIC REVIEW" in `@key`
  descriptions. Any marker blocks a production release.
* Keys listed in `docs/l10n_approvals/required_keys.json` need an approval
  record even after their marker is removed: removing a marker is never
  evidence of approval on its own. The gate fails closed: a missing,
  unreadable, wrong-schema or empty `required_keys.json` blocks production.
* An approval record (`docs/l10n_approvals/records/*.json`) names the locale,
  the reviewer (identity or approved reviewer reference), the review date,
  the reviewed ARB version (SHA-256) and a per-key outcome with the SHA-256
  of the approved text. The gate checks each approved key's current ARB text
  against that hash, so an edit after approval needs a new review.
* `--env dev` and `--env uat` report the same findings without failing, so
  ordinary development and UAT validation are not blocked.

Output names only locales, keys, record file names and problems: never
translation text or reviewer identities.
"""

from __future__ import annotations

import argparse
import datetime as _dt
import hashlib
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

MARKER = "PENDING LINGUISTIC REVIEW"
RECORD_SCHEMA = "l10n-approval-record/v1"
REQUIRED_SCHEMA = "l10n-required-review/v1"
OUTCOMES_APPROVED = {"approved", "approved_with_changes"}
OUTCOMES = OUTCOMES_APPROVED | {"rejected"}
ENVS = ("dev", "uat", "prod")
_HEX64 = re.compile(r"^[0-9a-f]{64}$")
_PLACEHOLDER = re.compile(r"^\s*$|^(tbd|todo|n/?a|none|unknown|-+)$|^<.*>$", re.I)


@dataclass
class Paths:
    root: Path

    @property
    def arb_dir(self) -> Path:
        return self.root / "lib" / "l10n"

    @property
    def locale_service(self) -> Path:
        return self.root / "lib" / "services" / "locale_service.dart"

    @property
    def approvals_dir(self) -> Path:
        return self.root / "docs" / "l10n_approvals"

    @property
    def required_keys(self) -> Path:
        return self.approvals_dir / "required_keys.json"

    @property
    def records_dir(self) -> Path:
        return self.approvals_dir / "records"


@dataclass
class Result:
    env: str
    pending: list[tuple[str, str]] = field(default_factory=list)
    unapproved: list[tuple[str, str, str]] = field(default_factory=list)
    invalid_records: list[tuple[str, str]] = field(default_factory=list)
    approved: list[tuple[str, str]] = field(default_factory=list)
    config_problems: list[str] = field(default_factory=list)

    @property
    def problems(self) -> int:
        return (len(self.pending) + len(self.unapproved) + len(self.invalid_records)
                + len(self.config_problems))

    @property
    def blocking(self) -> bool:
        return self.env == "prod" and self.problems > 0


def text_sha256(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def production_locales(paths: Paths) -> list[str]:
    """`LocaleService.productionLocales` as ARB suffixes, e.g. `de_CH`."""
    source = paths.locale_service.read_text(encoding="utf-8")
    match = re.search(r"productionLocales\s*=\s*\[(.*?)\];", source, re.S)
    if not match:
        raise ValueError("productionLocales not found in locale_service.dart")
    locales = []
    for lang, country in re.findall(
            r"Locale\(\s*'([a-z]{2,3})'\s*(?:,\s*'([A-Z]{2})'\s*)?\)", match.group(1)):
        locales.append(f"{lang}_{country}" if country else lang)
    if not locales:
        raise ValueError("productionLocales is empty")
    return locales


def load_arb(paths: Paths, locale: str) -> dict:
    return json.loads((paths.arb_dir / f"app_{locale}.arb").read_text(encoding="utf-8-sig"))


def pending_keys(arb: dict) -> list[str]:
    out = []
    for key, meta in arb.items():
        if not key.startswith("@") or key.startswith("@@") or not isinstance(meta, dict):
            continue
        if MARKER in str(meta.get("description", "")):
            out.append(key[1:])
    return sorted(out)


def load_required(paths: Paths, production: list[str] | None = None):
    """Required keys per locale, plus configuration problems.

    Fails closed: a missing, unreadable, wrong-schema or empty manifest is a
    configuration problem (blocking in prod), never "nothing required".
    """
    name = paths.required_keys.name
    if not paths.required_keys.exists():
        return {}, [f"{name} is missing"]
    try:
        data = json.loads(paths.required_keys.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}, [f"{name} is not valid JSON"]
    if not isinstance(data, dict) or data.get("schema") != REQUIRED_SCHEMA:
        return {}, [f"{name} schema must be {REQUIRED_SCHEMA}"]
    locales = data.get("locales")
    if not isinstance(locales, dict) or not locales:
        return {}, [f"{name} lists no locales"]
    required, problems = {}, []
    for loc, keys in locales.items():
        if production is not None and loc not in production:
            problems.append(f"{name} locale {loc} is not a production locale")
        if (not isinstance(keys, list) or not keys
                or not all(isinstance(k, str) and k for k in keys)):
            problems.append(f"{name} locale {loc} needs a non-empty list of keys")
            continue
        required[loc] = sorted(set(keys))
    return required, problems


def validate_record(record: object, production: list[str], today: _dt.date) -> list[str]:
    """Return the problems with one approval record (empty when valid)."""
    if not isinstance(record, dict):
        return ["not a JSON object"]
    problems = []
    if record.get("schema") != RECORD_SCHEMA:
        problems.append(f"schema must be {RECORD_SCHEMA}")
    locale = record.get("locale")
    if locale not in production:
        problems.append("locale is not a production locale")
    reviewer = record.get("reviewer")
    if not isinstance(reviewer, str) or _PLACEHOLDER.match(reviewer):
        problems.append("reviewer identity or reference is missing")
    try:
        date = _dt.date.fromisoformat(str(record.get("review_date")))
        if date > today:
            problems.append("review_date is in the future")
    except ValueError:
        problems.append("review_date must be YYYY-MM-DD")
    if record.get("arb_file") != f"lib/l10n/app_{locale}.arb":
        problems.append("arb_file does not match the locale")
    if not _HEX64.match(str(record.get("approved_arb_sha256", ""))):
        problems.append("approved_arb_sha256 must be a SHA-256 hex digest")
    entries = record.get("entries")
    if not isinstance(entries, list) or not entries:
        problems.append("entries must be a non-empty list")
        return problems
    for i, entry in enumerate(entries):
        if not isinstance(entry, dict) or not isinstance(entry.get("key"), str):
            problems.append(f"entry {i} has no key")
            continue
        if entry.get("outcome") not in OUTCOMES:
            problems.append(f"entry {entry['key']} has no valid outcome")
        if not _HEX64.match(str(entry.get("approved_text_sha256", ""))):
            problems.append(f"entry {entry['key']} has no approved_text_sha256")
    return problems


def load_records(paths: Paths, production: list[str], today: _dt.date):
    """Valid records, plus (file name, problem) for every invalid one."""
    valid, invalid = [], []
    if not paths.records_dir.exists():
        return valid, invalid
    for path in sorted(paths.records_dir.glob("*.json")):
        try:
            record = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            invalid.append((path.name, "not valid JSON"))
            continue
        problems = validate_record(record, production, today)
        if problems:
            invalid.extend((path.name, p) for p in problems)
        else:
            valid.append(record)
    return valid, invalid


def evaluate(root: Path, env: str = "prod", today: _dt.date | None = None) -> Result:
    if env not in ENVS:
        raise ValueError(f"env must be one of {ENVS}")
    paths = Paths(root)
    today = today or _dt.date.today()
    result = Result(env=env)
    production = production_locales(paths)
    arbs = {loc: load_arb(paths, loc) for loc in production}
    required, result.config_problems = load_required(paths, production)
    records, result.invalid_records = load_records(paths, production, today)

    # Approved / rejected text hashes per (locale, key), from valid records.
    approved: dict[tuple[str, str], set[str]] = {}
    rejected: dict[tuple[str, str], set[str]] = {}
    for record in records:
        for entry in record["entries"]:
            target = approved if entry["outcome"] in OUTCOMES_APPROVED else rejected
            target.setdefault((record["locale"], entry["key"]), set()).add(
                entry["approved_text_sha256"])

    for locale in production:
        arb = arbs[locale]
        marked = set(pending_keys(arb))
        result.pending.extend((locale, key) for key in sorted(marked))
        for key in required.get(locale, []):
            if key in marked:
                continue  # already reported as pending
            value = arb.get(key)
            if not isinstance(value, str):
                result.unapproved.append((locale, key, "missing from the ARB"))
                continue
            digest = text_sha256(value)
            if digest in rejected.get((locale, key), set()):
                result.unapproved.append((locale, key, "the current text was rejected"))
            elif digest in approved.get((locale, key), set()):
                result.approved.append((locale, key))
            elif (locale, key) in approved:
                result.unapproved.append(
                    (locale, key, "text changed after approval; needs a new review"))
            else:
                result.unapproved.append(
                    (locale, key, "marker removed but no valid approval record"))
    return result


def report(result: Result, out=sys.stdout) -> None:
    print(f"Linguistic approval gate (env={result.env}):", file=out)
    for why in result.config_problems:
        print(f"  CONFIG      {why}", file=out)
    for locale, key in result.pending:
        print(f"  PENDING     {locale}  {key}", file=out)
    for locale, key, why in result.unapproved:
        print(f"  UNAPPROVED  {locale}  {key}: {why}", file=out)
    for name, why in result.invalid_records:
        print(f"  BAD RECORD  {name}: {why}", file=out)
    by_locale: dict[str, int] = {}
    for locale, _ in result.pending:
        by_locale[locale] = by_locale.get(locale, 0) + 1
    summary = ", ".join(f"{loc}={n}" for loc, n in sorted(by_locale.items())) or "none"
    print(f"  pending drafts: {len(result.pending)} ({summary}); "
          f"unapproved: {len(result.unapproved)}; invalid records: "
          f"{len(result.invalid_records)}; config problems: "
          f"{len(result.config_problems)}; approved: {len(result.approved)}", file=out)
    if result.blocking:
        print("  RESULT: FAIL - production release blocked until every required "
              "translation has a valid approval record.", file=out)
    elif result.problems:
        print(f"  RESULT: reported only - not blocking for env={result.env}.", file=out)
    else:
        print("  RESULT: PASS", file=out)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--env", choices=ENVS, default="prod",
                        help="release target; only prod blocks (default: prod)")
    parser.add_argument("--root", type=Path, default=Path("."),
                        help="repository root (default: current directory)")
    args = parser.parse_args(argv)
    result = evaluate(args.root, args.env)
    report(result)
    return 1 if result.blocking else 0


if __name__ == "__main__":
    raise SystemExit(main())
