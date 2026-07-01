#!/usr/bin/env python3
"""Merge reviewed locale upload CSVs into the canonical CH template."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path

from split_ch_translation_template import CANONICAL_FIELDS, LOCALES


def _load_review(path: Path, locale: str) -> dict[str, str]:
    translations: dict[str, str] = {}
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        expected = ("seg_id", "source", locale)
        if tuple(reader.fieldnames or ()) != expected:
            raise ValueError(
                f"{path}: expected columns {expected}, found {tuple(reader.fieldnames or ())}"
            )
        for row in reader:
            seg_id = row["seg_id"]
            if not seg_id:
                raise ValueError(f"{path}: empty seg_id")
            if seg_id in translations:
                raise ValueError(f"{path}: duplicate seg_id {seg_id!r}")
            translations[seg_id] = row[locale]
    return translations


def merge_reviews(template: Path, reviews: dict[str, Path]) -> None:
    rows: list[dict[str, str]] = []
    canonical_ids = {locale: set() for locale in LOCALES}
    with template.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if tuple(reader.fieldnames or ()) != CANONICAL_FIELDS:
            raise ValueError(
                f"{template}: expected columns {CANONICAL_FIELDS}, "
                f"found {tuple(reader.fieldnames or ())}"
            )
        for row in reader:
            locale = row["locale"]
            if locale not in canonical_ids:
                raise ValueError(f"{template}: unsupported locale {locale!r}")
            seg_id = row["segment_hash"]
            if not seg_id:
                raise ValueError(f"{template}: row for {locale} has an empty segment_hash")
            if seg_id in canonical_ids[locale]:
                raise ValueError(f"{template}: duplicate segment_hash {seg_id!r} for {locale}")
            canonical_ids[locale].add(seg_id)
            rows.append(row)

    loaded = {locale: _load_review(reviews[locale], locale) for locale in LOCALES}
    for locale in LOCALES:
        expected = canonical_ids[locale]
        actual = set(loaded[locale])
        if len(loaded[locale]) != len(expected):
            raise ValueError(
                f"{reviews[locale]}: row count differs for {locale}: "
                f"expected {len(expected)}, found {len(loaded[locale])}"
            )
        if actual != expected:
            missing = sorted(expected - actual)[:3]
            unexpected = sorted(actual - expected)[:3]
            raise ValueError(
                f"{reviews[locale]}: seg_id mismatch for {locale}: "
                f"missing={missing}, unexpected={unexpected}"
            )

    for row in rows:
        row["translated_text"] = loaded[row["locale"]][row["segment_hash"]]

    with template.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=CANONICAL_FIELDS,
            quoting=csv.QUOTE_MINIMAL,
        )
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "template",
        nargs="?",
        type=Path,
        default=Path("reports/ch_translation_template.csv"),
    )
    args = parser.parse_args()
    reviews = {
        locale: args.template.with_name(
            f"{args.template.stem}.{locale}{args.template.suffix}"
        )
        for locale in LOCALES
    }
    merge_reviews(args.template, reviews)
    print(f"Merged reviewed locale CSVs into {args.template}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"CH translation review merge failed: {error}")
        raise SystemExit(1)
