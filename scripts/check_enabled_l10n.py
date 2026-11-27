#!/usr/bin/env python3
"""Fail when an enabled production locale lacks template ARB messages, or when
a production translation lacks linguistic approval (see l10n_approval_gate).

Usage: py scripts/check_enabled_l10n.py [--env dev|uat|prod]   (default prod)
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import l10n_approval_gate  # noqa: E402


ARB_DIR = Path("lib/l10n")
TEMPLATE = ARB_DIR / "app_en.arb"
UNTRANSLATED_REPORT = Path("untranslated_messages.txt")
ENABLED = ("de_CH", "fr_CH", "it_CH")


def keys(path: Path) -> set[str]:
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    return {key for key in data if not key.startswith("@")}


def remove_inherited_override_noise() -> None:
    if not UNTRANSLATED_REPORT.exists():
        return
    report = json.loads(UNTRANSLATED_REPORT.read_text(encoding="utf-8-sig"))
    report.pop("en_GB", None)
    UNTRANSLATED_REPORT.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--env", choices=l10n_approval_gate.ENVS, default="prod")
    args = parser.parse_args(argv)
    remove_inherited_override_noise()
    template_keys = keys(TEMPLATE)
    failed = False
    for locale in ENABLED:
        language = locale.split("_", 1)[0]
        effective = keys(ARB_DIR / f"app_{language}.arb") | keys(ARB_DIR / f"app_{locale}.arb")
        missing = sorted(template_keys - effective)
        print(f"{locale}: untranslated={len(missing)}")
        if missing:
            failed = True
            print("  " + ", ".join(missing))
    approval = l10n_approval_gate.evaluate(Path("."), args.env)
    l10n_approval_gate.report(approval)
    if approval.blocking:
        failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
