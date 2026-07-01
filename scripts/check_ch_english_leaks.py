#!/usr/bin/env python3
"""Report obvious English command-word leaks in filled CH review CSVs."""

from __future__ import annotations

import csv
import re
import sys
from pathlib import Path


LOCALES = ("de-CH", "fr-CH", "it-CH")
WORDS = ("Find", "Given", "Calculate")


def main() -> int:
    total = 0
    for locale in LOCALES:
        path = Path(f"reports/ch_translation_template.{locale}.filled.csv")
        if not path.exists():
            print(f"Missing filled CSV: {path}", file=sys.stderr)
            return 1
        with path.open(newline="", encoding="utf-8-sig") as handle:
            rows = list(csv.DictReader(handle))
        counts = {
            word: sum(
                len(re.findall(rf"\b{re.escape(word)}\b", row.get("translated_text", ""), re.I))
                for row in rows
            )
            for word in WORDS
        }
        locale_total = sum(counts.values())
        total += locale_total
        print(
            f"{locale}: "
            + ", ".join(f"{word}={counts[word]}" for word in WORDS)
            + f", total={locale_total}"
        )
    print(f"CH English command-word leaks: {total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
