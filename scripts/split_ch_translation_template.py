#!/usr/bin/env python3
"""Split the canonical CH template into authoritative per-locale review CSVs."""

from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path


LOCALES = ("de-CH", "fr-CH", "it-CH")
FIELDS = (
    "locale",
    "segment_hash",
    "source_text",
    "translated_text",
    "occurrences",
    "sample_locations",
)


def _read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if tuple(reader.fieldnames or ()) != FIELDS:
            raise ValueError(
                f"{path}: expected columns {FIELDS}, found {tuple(reader.fieldnames or ())}"
            )
        return list(reader)


def _validate_locale_rows(path: Path, locale: str, rows: list[dict[str, str]]) -> None:
    if not rows:
        raise ValueError(f"{path}: expected rows for {locale}, found none")
    wrong = [row.get("locale", "") for row in rows if row.get("locale") != locale]
    if wrong:
        raise ValueError(
            f"{path}: must contain only {locale} rows; rerun with --force to repair"
        )


def split_template(template: Path, *, force: bool = False) -> list[Path]:
    rows = _read_rows(template)
    rows_by_locale = {locale: [] for locale in LOCALES}
    for row in rows:
        locale = row.get("locale")
        if locale not in rows_by_locale:
            raise ValueError(f"{template}: unsupported locale {locale!r}")
        rows_by_locale[locale].append(row)

    outputs: list[Path] = []
    for locale in LOCALES:
        output = template.with_name(f"{template.stem}.{locale}{template.suffix}")
        locale_rows = rows_by_locale[locale]
        _validate_locale_rows(template, locale, locale_rows)
        if output.exists() and not force:
            _validate_locale_rows(output, locale, _read_rows(output))
            print(f"Kept existing {output}")
            outputs.append(output)
            continue
        with output.open("w", newline="", encoding="utf-8-sig") as handle:
            writer = csv.DictWriter(handle, fieldnames=FIELDS)
            writer.writeheader()
            writer.writerows(locale_rows)
        print(f"Wrote {output}")
        outputs.append(output)
    return outputs


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "template",
        nargs="?",
        type=Path,
        default=Path("reports/ch_translation_template.csv"),
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Replace existing locale CSVs from the combined canonical template.",
    )
    args = parser.parse_args()
    split_template(args.template, force=args.force)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"CH translation template split failed: {error}", file=sys.stderr)
        raise SystemExit(1)
