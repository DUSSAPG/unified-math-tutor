#!/usr/bin/env python3
"""Export remediation queues and a patch plan without changing question files."""

from __future__ import annotations

import argparse
import csv
from collections import Counter, defaultdict
from pathlib import Path
from typing import Iterable


TARGET_EXPORTS = {
    "PYTHON_EXPONENT": "fixes_python_exponent.csv",
    "DUPLICATE_OPTIONS": "fixes_duplicate_options.csv",
    "PLACEHOLDER_QUESTION": "fixes_placeholder.csv",
}
ISSUE_ORDER = tuple(TARGET_EXPORTS)
MANIFEST_COLUMNS = (
    "file",
    "question_id",
    "stage",
    "skill",
    "issue_types",
    "issue_count",
    "requires_manual_content",
    "recommended_phase",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export read-only remediation queues from an audit CSV."
    )
    parser.add_argument(
        "--input",
        type=Path,
        default=Path("audit_report.csv"),
        help="Audit CSV to read (default: audit_report.csv).",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("."),
        help="Directory for generated CSV and Markdown files (default: current directory).",
    )
    return parser.parse_args()


def read_audit(path: Path) -> tuple[list[str], list[dict[str, str]]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise ValueError(f"{path} has no CSV header")
        required = {"file", "question_id", "stage", "skill", "issue_type"}
        missing = required.difference(reader.fieldnames)
        if missing:
            raise ValueError(f"{path} is missing columns: {', '.join(sorted(missing))}")
        return reader.fieldnames, list(reader)


def write_csv(path: Path, columns: Iterable[str], rows: Iterable[dict[str, object]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(columns), extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def phase_for(issue_types: set[str]) -> str:
    if "PLACEHOLDER_QUESTION" in issue_types:
        return "3_manual_placeholder_replacement"
    if "DUPLICATE_OPTIONS" in issue_types:
        return "2_option_repair_and_validation"
    return "1_exponent_normalization"


def build_manifest(rows: list[dict[str, str]]) -> list[dict[str, object]]:
    grouped: dict[tuple[str, str], list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        if row["issue_type"] in TARGET_EXPORTS:
            grouped[(row["file"], row["question_id"])].append(row)

    manifest = []
    for (source_file, question_id), question_rows in sorted(grouped.items()):
        first = question_rows[0]
        issue_types = {row["issue_type"] for row in question_rows}
        ordered_types = [issue for issue in ISSUE_ORDER if issue in issue_types]
        manifest.append(
            {
                "file": source_file,
                "question_id": question_id,
                "stage": first["stage"],
                "skill": first["skill"],
                "issue_types": "|".join(ordered_types),
                "issue_count": len(issue_types),
                "requires_manual_content": (
                    "yes" if "PLACEHOLDER_QUESTION" in issue_types else "no"
                ),
                "recommended_phase": phase_for(issue_types),
            }
        )
    return manifest


def build_source_counts(rows: list[dict[str, str]]) -> list[dict[str, object]]:
    counts = Counter(
        (row["file"], row["issue_type"])
        for row in rows
        if row["issue_type"] in TARGET_EXPORTS
    )
    source_files = sorted({source_file for source_file, _ in counts})
    output = []
    for source_file in source_files:
        per_issue = {
            issue: counts[(source_file, issue)]
            for issue in ISSUE_ORDER
        }
        output.append(
            {
                "file": source_file,
                **per_issue,
                "TOTAL_TARGET_ISSUES": sum(per_issue.values()),
            }
        )
    return output


def write_plan(
    path: Path,
    source_counts: list[dict[str, object]],
    manifest: list[dict[str, object]],
) -> None:
    issue_totals = Counter()
    for row in source_counts:
        for issue in ISSUE_ORDER:
            issue_totals[issue] += int(row[issue])

    overlap_counts = Counter(row["issue_types"] for row in manifest)
    lines = [
        "# Safe Question Remediation Plan",
        "",
        "This plan is generated from `audit_report.csv`. No question-bank files are modified.",
        "",
        "## Exported Queues",
        "",
    ]
    for issue, filename in TARGET_EXPORTS.items():
        lines.append(f"- `{filename}`: {issue_totals[issue]} `{issue}` audit rows")

    lines.extend(
        [
            f"- `remediation_manifest.csv`: {len(manifest)} unique questions across the target issues",
            "- `remediation_counts_by_source.csv`: issue counts grouped by source file",
            "",
            "## Counts By Source",
            "",
            "| Source file | Python exponent | Duplicate options | Placeholder question | Total target issues |",
            "| --- | ---: | ---: | ---: | ---: |",
        ]
    )
    for row in source_counts:
        lines.append(
            f"| `{row['file']}` | {row['PYTHON_EXPONENT']} | "
            f"{row['DUPLICATE_OPTIONS']} | {row['PLACEHOLDER_QUESTION']} | "
            f"{row['TOTAL_TARGET_ISSUES']} |"
        )

    lines.extend(["", "## Overlap Summary", ""])
    for issue_types, count in sorted(overlap_counts.items()):
        lines.append(f"- `{issue_types}`: {count} unique questions")

    lines.extend(
        [
            "",
            "## Safe Patching Sequence",
            "",
            "1. Resolve each manifest `file` value to its canonical question-bank path. Stop if a source file is missing or ambiguous.",
            "2. Copy each canonical JSONL source to a timestamped backup directory outside the source tree.",
            "3. Parse JSONL structurally and index records by exact `question_id`. Stop on duplicate IDs or missing IDs.",
            "4. Apply exponent normalization first only to questions listed in `fixes_python_exponent.csv`. Replace Python `**` notation in text fields with display `^` notation; do not use an unrestricted repository-wide replacement.",
            "5. Re-evaluate options for every question in `fixes_duplicate_options.csv`, including questions changed in step 4. Replace duplicate distractors with mathematically distinct distractors and preserve the correct-answer mapping.",
            "6. Replace `fixes_placeholder.csv` questions with skill-matched authored content in a manual-review batch. Do not generate arithmetic stubs.",
            "7. Write patched JSONL to a staging directory, never over the canonical files on the first pass.",
            "8. Re-run the content audit against staging. Require zero `PYTHON_EXPONENT`, `DUPLICATE_OPTIONS`, and `PLACEHOLDER_QUESTION` findings before promotion.",
            "9. Validate JSONL parsing, stable question IDs, option uniqueness, correct-answer validity, record counts, and a source-versus-staging diff.",
            "10. Promote staged files only after review of the diff and validation report.",
            "",
            "## Guardrails For A Future Patcher",
            "",
            "- Default to dry-run mode and require an explicit `--apply` flag.",
            "- Require `--input-dir`, `--staging-dir`, and `--backup-dir`; reject overlapping directories.",
            "- Patch only IDs listed in `remediation_manifest.csv`.",
            "- Fail closed on malformed JSON, missing IDs, duplicate IDs, unexpected schema, or record-count changes.",
            "- Emit per-question before/after records and a machine-readable validation report.",
            "- Keep placeholder replacement separate from mechanical notation fixes.",
            "",
        ]
    )
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    args = parse_args()
    columns, rows = read_audit(args.input)
    args.output_dir.mkdir(parents=True, exist_ok=True)

    for issue_type, filename in TARGET_EXPORTS.items():
        filtered = [row for row in rows if row["issue_type"] == issue_type]
        write_csv(args.output_dir / filename, columns, filtered)

    source_counts = build_source_counts(rows)
    count_columns = (*ISSUE_ORDER, "TOTAL_TARGET_ISSUES")
    write_csv(
        args.output_dir / "remediation_counts_by_source.csv",
        ("file", *count_columns),
        source_counts,
    )

    manifest = build_manifest(rows)
    write_csv(args.output_dir / "remediation_manifest.csv", MANIFEST_COLUMNS, manifest)
    write_plan(args.output_dir / "safe_patching_plan.md", source_counts, manifest)

    print(f"Read {len(rows)} audit rows from {args.input}")
    for issue_type, filename in TARGET_EXPORTS.items():
        count = sum(row["issue_type"] == issue_type for row in rows)
        print(f"Wrote {filename}: {count} rows")
    print(f"Wrote remediation_counts_by_source.csv: {len(source_counts)} source files")
    print(f"Wrote remediation_manifest.csv: {len(manifest)} unique questions")
    print("Wrote safe_patching_plan.md")


if __name__ == "__main__":
    main()
