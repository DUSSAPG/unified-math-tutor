#!/usr/bin/env python3
"""Validate manifest-scoped question-bank patches without modifying files."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any


EXPLANATION_FIELDS = {"explanation", "explanations", "hint", "rationale"}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, default=Path("remediation_manifest.csv"))
    parser.add_argument("--input-dir", type=Path, required=True)
    parser.add_argument("--baseline-dir", type=Path)
    parser.add_argument("--report", type=Path, default=Path("validation_report.csv"))
    return parser.parse_args()


def read_manifest(path: Path) -> dict[str, dict[str, set[str]]]:
    manifest: dict[str, dict[str, set[str]]] = defaultdict(dict)
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        for row in csv.DictReader(handle):
            manifest[row["file"]][row["question_id"]] = set(row["issue_types"].split("|"))
    return manifest


def load_bank(path: Path) -> tuple[list[dict[str, Any]], dict[str, dict[str, Any]]]:
    records = []
    by_id = {}
    with path.open("r", encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            try:
                record = json.loads(line)
            except json.JSONDecodeError as error:
                raise ValueError(f"{path}:{line_number}: malformed JSON: {error}") from error
            records.append(record)
            question_id = record.get("id")
            if question_id is None:
                continue
            if not isinstance(question_id, str) or not question_id:
                raise ValueError(f"{path}:{line_number}: invalid id")
            if question_id in by_id:
                raise ValueError(f"{path}:{line_number}: duplicate id {question_id}")
            by_id[question_id] = record
    return records, by_id


def strings_outside_explanations(value: Any, field: str = "") -> list[str]:
    if field in EXPLANATION_FIELDS:
        return []
    if isinstance(value, str):
        return [value]
    if isinstance(value, list):
        return [
            text
            for item in value
            for text in strings_outside_explanations(item, field)
        ]
    if isinstance(value, dict):
        return [
            text
            for key, item in value.items()
            for text in strings_outside_explanations(item, key)
        ]
    return []


def validate_question(record: dict[str, Any], issues: set[str]) -> list[str]:
    errors = []
    options = record.get("options")
    answer_index = record.get("answer_index")
    if not isinstance(options, list) or not all(isinstance(option, str) for option in options):
        return ["options is not a list of strings"]
    if not options:
        errors.append("options is empty")
    if not isinstance(answer_index, int) or not 0 <= answer_index < len(options):
        errors.append("answer_index is outside options")
    if "PYTHON_EXPONENT" in issues:
        if any("**" in text for text in strings_outside_explanations(record)):
            errors.append("Python exponent notation remains outside explanation fields")
    if "DUPLICATE_OPTIONS" in issues and len(options) != len(set(options)):
        errors.append("exact duplicate options remain")
    return errors


def add_result(
    results: list[dict[str, str]],
    source_file: str,
    question_id: str,
    check: str,
    status: str,
    detail: str = "",
) -> None:
    results.append(
        {
            "file": source_file,
            "question_id": question_id,
            "check": check,
            "status": status,
            "detail": detail,
        }
    )


def main() -> int:
    args = parse_args()
    manifest = read_manifest(args.manifest)
    results: list[dict[str, str]] = []
    failed = False

    try:
        for source_file, questions in sorted(manifest.items()):
            patched_path = args.input_dir / source_file
            patched_records, patched_by_id = load_bank(patched_path)
            if args.baseline_dir:
                baseline_records, baseline_by_id = load_bank(args.baseline_dir / source_file)
                if len(patched_records) != len(baseline_records):
                    failed = True
                    add_result(
                        results,
                        source_file,
                        "",
                        "record_count",
                        "FAIL",
                        f"{len(baseline_records)} -> {len(patched_records)}",
                    )
                if set(patched_by_id) != set(baseline_by_id):
                    failed = True
                    add_result(results, source_file, "", "id_set", "FAIL", "ID set changed")

            for question_id, issues in sorted(questions.items()):
                record = patched_by_id.get(question_id)
                if record is None:
                    failed = True
                    add_result(results, source_file, question_id, "manifest_id", "FAIL", "missing")
                    continue
                errors = validate_question(record, issues)
                if errors:
                    failed = True
                    add_result(
                        results,
                        source_file,
                        question_id,
                        "question",
                        "FAIL",
                        "; ".join(errors),
                    )
                else:
                    add_result(results, source_file, question_id, "question", "PASS")
    except (OSError, ValueError) as error:
        failed = True
        add_result(results, "", "", "bank_load", "FAIL", str(error))

    args.report.parent.mkdir(parents=True, exist_ok=True)
    with args.report.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle, fieldnames=("file", "question_id", "check", "status", "detail")
        )
        writer.writeheader()
        writer.writerows(results)

    failures = sum(result["status"] == "FAIL" for result in results)
    print(f"Validation wrote {args.report}: {len(results)} checks, {failures} failures")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
