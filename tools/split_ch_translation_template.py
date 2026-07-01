#!/usr/bin/env python3
"""Split the canonical CH translation template into locale upload CSVs."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path


LOCALES = ("de-CH", "fr-CH", "it-CH")
CANONICAL_FIELDS = (
    "locale",
    "segment_hash",
    "source_text",
    "translated_text",
    "occurrences",
    "sample_locations",
)


def split_template(template: Path) -> list[Path]:
    rows_by_locale = {locale: [] for locale in LOCALES}
    seen_by_locale = {locale: set() for locale in LOCALES}
    with template.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if tuple(reader.fieldnames or ()) != CANONICAL_FIELDS:
            raise ValueError(
                f"{template}: expected columns {CANONICAL_FIELDS}, "
                f"found {tuple(reader.fieldnames or ())}"
            )
        for row in reader:
            locale = row["locale"]
            if locale not in rows_by_locale:
                raise ValueError(f"{template}: unsupported locale {locale!r}")
            seg_id = row["segment_hash"]
            if not seg_id:
                raise ValueError(f"{template}: row for {locale} has an empty segment_hash")
            if seg_id in seen_by_locale[locale]:
                raise ValueError(f"{template}: duplicate segment_hash {seg_id!r} for {locale}")
            seen_by_locale[locale].add(seg_id)
            rows_by_locale[locale].append(
                {
                    "seg_id": seg_id,
                    "source": row["source_text"],
                    locale: row["translated_text"],
                }
            )

    expected_ids = seen_by_locale[LOCALES[0]]
    for locale in LOCALES[1:]:
        if seen_by_locale[locale] != expected_ids:
            raise ValueError(f"{template}: segment_hash set differs for {locale}")

    outputs = []
    for locale in LOCALES:
        output = template.with_name(f"{template.stem}.{locale}{template.suffix}")
        with output.open("w", newline="", encoding="utf-8-sig") as handle:
            writer = csv.DictWriter(
                handle,
                fieldnames=("seg_id", "source", locale),
                quoting=csv.QUOTE_MINIMAL,
            )
            writer.writeheader()
            writer.writerows(rows_by_locale[locale])
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
    args = parser.parse_args()
    for output in split_template(args.template):
        print(f"Wrote {output}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"CH translation template split failed: {error}")
        raise SystemExit(1)
