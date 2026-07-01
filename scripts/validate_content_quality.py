#!/usr/bin/env python3
"""Validate release-facing JSONL content quality without rewriting packs."""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import Counter
from pathlib import Path


PACK_ROOT = Path("assets/packs")
CONFIG = Path("assets/config/content_quality.json")
CH_LOCALES = ("de-CH", "fr-CH", "it-CH")
EN_PACKS = (
    "KS2_bank_ok_10000.jsonl",
    "KS3_bank_ok_10000.jsonl",
    "KS4_merged_deduped.jsonl",
    "KS5_merged_deduped.jsonl",
)
TEXT_FIELDS = ("stem", "question", "hint", "rationale", "explanation")
BAD_SYMBOLS = ("\ufffd", "Ã", "â€", "â€”", "â€“")
FIND_RE = re.compile(r"\bFind\b")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--strict-ch",
        action="store_true",
        help="Fail if CH packs contain untranslated English 'Find'.",
    )
    args = parser.parse_args()
    issues: list[str] = []
    warnings: list[str] = []

    validate_difficulty_distributions(issues)
    validate_malformed_symbols(issues)
    validate_ch_find(issues if args.strict_ch else warnings)
    validate_graph_topics(issues)

    print("Content quality summary")
    print("-----------------------")
    for warning in warnings:
        print(f"WARNING: {warning}")
    if issues:
        print("\nContent quality failed:", file=sys.stderr)
        for issue in issues:
            print(f" - {issue}", file=sys.stderr)
        return 1
    print("Content quality checks passed.")
    return 0


def iter_jsonl(path: Path):
    with path.open(encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, 1):
            if not line.strip():
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError as error:
                raise ValueError(f"{path}:{line_number}: invalid JSON: {error}") from error
            if not isinstance(row, dict):
                raise ValueError(f"{path}:{line_number}: row must be an object")
            yield line_number, row


def validate_difficulty_distributions(issues: list[str]) -> None:
    for pack in EN_PACKS:
        counts: Counter[str] = Counter()
        for _, row in iter_jsonl(PACK_ROOT / "en-GB" / pack):
            difficulty = row.get("difficulty")
            if difficulty is None:
                issues.append(f"{pack}: missing difficulty value")
                return
            counts[str(difficulty)] += 1
        print(f"{pack}: difficulty={dict(sorted(counts.items()))}")
        if len(counts) < 2:
            issues.append(f"{pack}: difficulty distribution has fewer than two bands")


def validate_malformed_symbols(issues: list[str]) -> None:
    for locale_dir in ("en-GB", *CH_LOCALES):
        for path in (PACK_ROOT / locale_dir).glob("*.jsonl"):
            for line_number, row in iter_jsonl(path):
                for field, value in iter_text(row):
                    for symbol in BAD_SYMBOLS:
                        if symbol in value:
                            issues.append(
                                f"{path}:{line_number}:{field}: malformed symbol {symbol!r}"
                            )
                    if value.count("$") % 2:
                        issues.append(
                            f"{path}:{line_number}:{field}: unbalanced LaTeX '$' delimiter"
                        )
                    if value.count("{") != value.count("}"):
                        issues.append(
                            f"{path}:{line_number}:{field}: unbalanced math braces"
                        )


def validate_ch_find(target: list[str]) -> None:
    for locale in CH_LOCALES:
        hits = 0
        for pack in EN_PACKS:
            for _, row in iter_jsonl(PACK_ROOT / locale / pack):
                for _, value in iter_text(row):
                    hits += len(FIND_RE.findall(value))
        print(f"{locale}: untranslated_Find={hits}")
        if hits:
            target.append(f"{locale}: {hits} untranslated 'Find' occurrences")


def validate_graph_topics(issues: list[str]) -> None:
    config = json.loads(CONFIG.read_text(encoding="utf-8"))
    required = set(config.get("graphRequiredTopics", []))
    if not required:
        print("graph-required topics: none configured")
        return
    covered: set[str] = set()
    for pack in EN_PACKS:
        for _, row in iter_jsonl(PACK_ROOT / "en-GB" / pack):
            if row.get("type") == "graph_read":
                covered.add(str(row.get("topic") or row.get("skill") or ""))
    for topic in sorted(required - covered):
        issues.append(f"graph-required topic {topic!r} has no graph_read question")


def iter_text(row: dict):
    for field in TEXT_FIELDS:
        value = row.get(field)
        if isinstance(value, str):
            yield field, value
    options = row.get("options")
    if isinstance(options, list):
        for index, value in enumerate(options):
            if isinstance(value, str):
                yield f"options[{index}]", value


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"Content quality failed: {error}", file=sys.stderr)
        raise SystemExit(1)
