#!/usr/bin/env python3
"""Patch manifest-scoped question issues with backups and post-patch validation."""

from __future__ import annotations

import argparse
import csv
import json
import shutil
import subprocess
import sys
from collections import defaultdict
from copy import deepcopy
from datetime import datetime
from pathlib import Path
from typing import Any


EXPLANATION_FIELDS = {"explanation", "explanations", "hint", "rationale"}
REPORT_COLUMNS = (
    "file",
    "question_id",
    "action",
    "status",
    "detail",
    "options_before",
    "options_after",
    "answer_index_before",
    "answer_index_after",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, default=Path("remediation_manifest.csv"))
    parser.add_argument("--input-dir", type=Path, default=Path("assets/packs/en-GB"))
    parser.add_argument("--backup-dir", type=Path, default=Path("backups/question_patches"))
    parser.add_argument("--report", type=Path, default=Path("patch_report.csv"))
    parser.add_argument(
        "--needs-regeneration",
        type=Path,
        default=Path("needs_regeneration.jsonl"),
    )
    parser.add_argument(
        "--validation-report",
        type=Path,
        default=Path("validation_report.csv"),
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Back up and modify the input banks in place. Without this flag, run a dry-run.",
    )
    return parser.parse_args()


def read_manifest(path: Path) -> dict[str, dict[str, set[str]]]:
    manifest: dict[str, dict[str, set[str]]] = defaultdict(dict)
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        required = {"file", "question_id", "issue_types"}
        missing = required.difference(reader.fieldnames or ())
        if missing:
            raise ValueError(f"{path} is missing columns: {', '.join(sorted(missing))}")
        for row in reader:
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


def normalize_exponents(value: Any, field: str = "") -> tuple[Any, int]:
    if field in EXPLANATION_FIELDS:
        return value, 0
    if isinstance(value, str):
        return value.replace("**", "^"), value.count("**")
    if isinstance(value, list):
        output = []
        replacements = 0
        for item in value:
            normalized, count = normalize_exponents(item, field)
            output.append(normalized)
            replacements += count
        return output, replacements
    if isinstance(value, dict):
        output = {}
        replacements = 0
        for key, item in value.items():
            normalized, count = normalize_exponents(item, key)
            output[key] = normalized
            replacements += count
        return output, replacements
    return value, 0


def remove_duplicate_options(record: dict[str, Any]) -> int:
    options = record.get("options")
    answer_index = record.get("answer_index")
    if not isinstance(options, list) or not all(isinstance(option, str) for option in options):
        raise ValueError("options is not a list of strings")
    if not isinstance(answer_index, int) or not 0 <= answer_index < len(options):
        raise ValueError("answer_index is outside options")

    answer_value = options[answer_index]
    unique_options = []
    for option in options:
        if option not in unique_options:
            unique_options.append(option)
    removed = len(options) - len(unique_options)
    record["options"] = unique_options
    record["answer_index"] = unique_options.index(answer_value)
    return removed


def write_bank(path: Path, records: list[dict[str, Any]]) -> None:
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        for record in records:
            handle.write(json.dumps(record, ensure_ascii=False, separators=(",", ":")) + "\n")


def report_row(
    source_file: str,
    question_id: str,
    action: str,
    status: str,
    detail: str = "",
    before: dict[str, Any] | None = None,
    after: dict[str, Any] | None = None,
) -> dict[str, object]:
    before = before or {}
    after = after or {}
    return {
        "file": source_file,
        "question_id": question_id,
        "action": action,
        "status": status,
        "detail": detail,
        "options_before": json.dumps(before.get("options"), ensure_ascii=False),
        "options_after": json.dumps(after.get("options"), ensure_ascii=False),
        "answer_index_before": before.get("answer_index", ""),
        "answer_index_after": after.get("answer_index", ""),
    }


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=REPORT_COLUMNS)
        writer.writeheader()
        writer.writerows(rows)


def write_regeneration(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        for row in rows:
            handle.write(json.dumps(row, ensure_ascii=False, separators=(",", ":")) + "\n")


def validate_dirs(input_dir: Path, backup_root: Path) -> None:
    input_resolved = input_dir.resolve()
    backup_resolved = backup_root.resolve()
    if input_resolved == backup_resolved or input_resolved in backup_resolved.parents:
        raise ValueError("--backup-dir must be outside --input-dir")


def run_validator(
    args: argparse.Namespace, backup_dir: Path, validator_path: Path
) -> None:
    command = [
        sys.executable,
        str(validator_path),
        "--manifest",
        str(args.manifest),
        "--input-dir",
        str(args.input_dir),
        "--baseline-dir",
        str(backup_dir),
        "--report",
        str(args.validation_report),
    ]
    subprocess.run(command, check=True)


def main() -> int:
    args = parse_args()
    validate_dirs(args.input_dir, args.backup_dir)
    manifest = read_manifest(args.manifest)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = args.backup_dir / timestamp
    report_rows: list[dict[str, object]] = []
    regeneration_rows: list[dict[str, Any]] = []
    staged_banks: dict[str, list[dict[str, Any]]] = {}

    try:
        for source_file, questions in sorted(manifest.items()):
            source_path = args.input_dir / source_file
            records, by_id = load_bank(source_path)
            missing = sorted(set(questions).difference(by_id))
            if missing:
                raise ValueError(f"{source_path}: missing {len(missing)} manifest IDs")

            for question_id, issues in sorted(questions.items()):
                original = deepcopy(by_id[question_id])
                patched = deepcopy(original)

                if "PYTHON_EXPONENT" in issues:
                    patched, replacements = normalize_exponents(patched)
                    report_rows.append(
                        report_row(
                            source_file,
                            question_id,
                            "normalize_python_exponent",
                            "PLANNED" if not args.apply else "APPLIED",
                            f"replaced {replacements} '**' occurrence(s)",
                            original,
                            patched,
                        )
                    )

                if "DUPLICATE_OPTIONS" in issues:
                    before_dedupe = deepcopy(patched)
                    removed = remove_duplicate_options(patched)
                    report_rows.append(
                        report_row(
                            source_file,
                            question_id,
                            "remove_exact_duplicate_options",
                            "PLANNED" if not args.apply else "APPLIED",
                            f"removed {removed} duplicate option(s)",
                            before_dedupe,
                            patched,
                        )
                    )

                if "PLACEHOLDER_QUESTION" in issues:
                    regeneration_rows.append(
                        {
                            "source_file": source_file,
                            "question_id": question_id,
                            "reason": "PLACEHOLDER_QUESTION",
                            "question": original,
                        }
                    )
                    report_rows.append(
                        report_row(
                            source_file,
                            question_id,
                            "export_placeholder_for_regeneration",
                            "PLANNED" if not args.apply else "EXPORTED",
                            "question bank record left unchanged",
                            original,
                            patched,
                        )
                    )

                by_id[question_id].clear()
                by_id[question_id].update(patched)

            staged_banks[source_file] = records
    except (OSError, ValueError) as error:
        print(f"Patch aborted before modification: {error}", file=sys.stderr)
        return 1

    write_csv(args.report, report_rows)
    write_regeneration(args.needs_regeneration, regeneration_rows)

    if not args.apply:
        print(f"Dry-run only. Wrote {args.report} and {args.needs_regeneration}")
        print("No question-bank files were modified. Re-run with --apply to back up and patch.")
        return 0

    backup_dir.mkdir(parents=True, exist_ok=False)
    for source_file in sorted(staged_banks):
        source_path = args.input_dir / source_file
        shutil.copy2(source_path, backup_dir / source_file)
    for source_file, records in sorted(staged_banks.items()):
        write_bank(args.input_dir / source_file, records)

    validator_path = Path(__file__).with_name("validate_question_patches.py")
    try:
        run_validator(args, backup_dir, validator_path)
    except subprocess.CalledProcessError:
        print(
            f"Patch applied but validation failed. Restore from {backup_dir}",
            file=sys.stderr,
        )
        return 1

    print(f"Patched {len(staged_banks)} bank(s) after backing up to {backup_dir}")
    print(f"Wrote {args.report}, {args.needs_regeneration}, and {args.validation_report}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
