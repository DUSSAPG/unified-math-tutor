#!/usr/bin/env python3
"""Mine deterministic translation templates from CH review CSVs."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import sys
from collections import defaultdict
from pathlib import Path


LOCALES = ("de-CH", "fr-CH", "it-CH")
LATEX_RE = re.compile(r"\$\$.*?\$\$|\$.*?\$", re.DOTALL)
FRACTION_RE = re.compile(r"(?<![\w.])\d+\s*/\s*\d+(?!\w)")
NUMBER_RE = re.compile(r"(?<![\w.])\d+(?:\.\d+)?(?!\w)")
TOKEN_RE = re.compile(
    r"\$\$.*?\$\$|\$.*?\$|(?<![\w.])\d+\s*/\s*\d+(?!\w)|"
    r"(?<![\w.])\d+(?:\.\d+)?(?!\w)",
    re.DOTALL,
)
TEMPLATE_FIELDS = (
    "pattern_id",
    "normalized_pattern",
    "example_source",
    "count",
    "sample_seg_ids",
)


def normalize_source_text(text: str) -> str:
    """Replace variable values while preserving readable mathematical structure."""
    text = LATEX_RE.sub("{latex}", text)
    text = FRACTION_RE.sub("{frac}", text)
    text = NUMBER_RE.sub("{n}", text)
    return " ".join(text.split())


def pattern_id(normalized_pattern: str) -> str:
    digest = hashlib.sha256(normalized_pattern.encode("utf-8")).hexdigest()
    return f"pattern_{digest[:16]}"


def extract_values(text: str) -> list[tuple[str, str]]:
    """Return normalized placeholder names and original values in source order."""
    values: list[tuple[str, str]] = []
    for match in TOKEN_RE.finditer(text):
        value = match.group(0)
        if value.startswith("$"):
            values.append(("latex", value))
        elif "/" in value:
            values.append(("frac", value))
        else:
            values.append(("n", value))
    return values


def render_template(source_text: str, translated_template: str) -> str:
    """Put values from source_text into a translated normalized template."""
    values = extract_values(source_text)
    index = 0

    def replace(match: re.Match[str]) -> str:
        nonlocal index
        if index >= len(values):
            raise ValueError("translated template has more placeholders than source text")
        expected = match.group(1)
        actual, value = values[index]
        if actual != expected:
            raise ValueError(
                f"placeholder order mismatch: expected {{{expected}}}, found {{{actual}}}"
            )
        index += 1
        return value

    rendered = re.sub(r"\{(n|frac|latex)\}", replace, translated_template)
    if index != len(values):
        raise ValueError("translated template has fewer placeholders than source text")
    return rendered


def _segment_id(row: dict[str, str]) -> str:
    return row.get("seg_id") or row.get("segment_hash") or ""


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames or "source_text" not in reader.fieldnames:
            raise ValueError(f"{path}: expected a source_text column")
        return list(reader)


def mine_csv(input_csv: Path, output_csv: Path, stats_json: Path) -> dict[str, object]:
    rows = read_csv_rows(input_csv)
    patterns: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        patterns[normalize_source_text(row["source_text"])].append(row)

    mined_rows: list[dict[str, object]] = []
    for normalized, grouped_rows in patterns.items():
        segment_ids = [_segment_id(row) for row in grouped_rows if _segment_id(row)]
        mined_rows.append(
            {
                "pattern_id": pattern_id(normalized),
                "normalized_pattern": normalized,
                "example_source": grouped_rows[0]["source_text"],
                "count": len(grouped_rows),
                "sample_seg_ids": " | ".join(segment_ids[:5]),
            }
        )
    mined_rows.sort(key=lambda row: (-int(row["count"]), str(row["normalized_pattern"])))

    total = len(rows)
    counts = [int(row["count"]) for row in mined_rows]
    stats: dict[str, object] = {
        "input_csv": str(input_csv),
        "unique_segments": total,
        "unique_patterns": len(mined_rows),
        "coverage_top10": sum(counts[:10]) / total if total else 0.0,
        "coverage_top25": sum(counts[:25]) / total if total else 0.0,
        "coverage_top50": sum(counts[:50]) / total if total else 0.0,
        "coverage_top100": sum(counts[:100]) / total if total else 0.0,
        "top_patterns": mined_rows[:10],
    }

    output_csv.parent.mkdir(parents=True, exist_ok=True)
    with output_csv.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=TEMPLATE_FIELDS)
        writer.writeheader()
        writer.writerows(mined_rows)
    stats_json.write_text(
        json.dumps(stats, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return stats


def _inputs(args: argparse.Namespace) -> list[tuple[str, Path]]:
    if args.input_csv:
        locale = args.locale or args.input_csv.stem.split(".")[-1]
        if locale not in LOCALES:
            raise ValueError("pass --locale for CSV names that do not end in a CH locale")
        return [(locale, args.input_csv)]
    return [
        (locale, args.reports_dir / f"ch_translation_template.{locale}.csv")
        for locale in LOCALES
    ]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv", nargs="?", type=Path)
    parser.add_argument("--locale", choices=LOCALES)
    parser.add_argument("--reports-dir", type=Path, default=Path("reports"))
    args = parser.parse_args()
    for locale, input_csv in _inputs(args):
        stats = mine_csv(
            input_csv,
            args.reports_dir / f"templates_{locale}.csv",
            args.reports_dir / f"template_stats_{locale}.json",
        )
        print(
            f"{locale}: segments={stats['unique_segments']}, "
            f"patterns={stats['unique_patterns']}, "
            f"coverage_top10={stats['coverage_top10']:.1%}"
        )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"Template mining failed: {error}", file=sys.stderr)
        raise SystemExit(1)
