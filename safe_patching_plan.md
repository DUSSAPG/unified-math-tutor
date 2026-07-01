# Safe Question Remediation Plan

This plan is generated from `audit_report.csv`. No question-bank files are modified.

## Exported Queues

- `fixes_python_exponent.csv`: 6584 `PYTHON_EXPONENT` audit rows
- `fixes_duplicate_options.csv`: 7154 `DUPLICATE_OPTIONS` audit rows
- `fixes_placeholder.csv`: 4140 `PLACEHOLDER_QUESTION` audit rows
- `remediation_manifest.csv`: 12855 unique questions across the target issues
- `remediation_counts_by_source.csv`: issue counts grouped by source file

## Counts By Source

| Source file | Python exponent | Duplicate options | Placeholder question | Total target issues |
| --- | ---: | ---: | ---: | ---: |
| `ALL_merged_deduped.jsonl` | 2793 | 3289 | 2070 | 8152 |
| `KS4_bank_ok_2000_A.jsonl` | 534 | 315 | 0 | 849 |
| `KS4_bank_ok_2000_B.jsonl` | 464 | 261 | 0 | 725 |
| `KS4_merged_deduped.jsonl` | 1193 | 690 | 2070 | 3953 |
| `KS5_merged_deduped.jsonl` | 1600 | 2599 | 0 | 4199 |

## Overlap Summary

- `DUPLICATE_OPTIONS`: 2131 unique questions
- `PLACEHOLDER_QUESTION`: 4140 unique questions
- `PYTHON_EXPONENT`: 1561 unique questions
- `PYTHON_EXPONENT|DUPLICATE_OPTIONS`: 5023 unique questions

## Safe Patching Sequence

1. Resolve each manifest `file` value to its canonical question-bank path. Stop if a source file is missing or ambiguous.
2. Copy each canonical JSONL source to a timestamped backup directory outside the source tree.
3. Parse JSONL structurally and index records by exact `question_id`. Stop on duplicate IDs or missing IDs.
4. Apply exponent normalization first only to questions listed in `fixes_python_exponent.csv`. Replace Python `**` notation in text fields with display `^` notation; do not use an unrestricted repository-wide replacement.
5. Re-evaluate options for every question in `fixes_duplicate_options.csv`, including questions changed in step 4. Replace duplicate distractors with mathematically distinct distractors and preserve the correct-answer mapping.
6. Replace `fixes_placeholder.csv` questions with skill-matched authored content in a manual-review batch. Do not generate arithmetic stubs.
7. Write patched JSONL to a staging directory, never over the canonical files on the first pass.
8. Re-run the content audit against staging. Require zero `PYTHON_EXPONENT`, `DUPLICATE_OPTIONS`, and `PLACEHOLDER_QUESTION` findings before promotion.
9. Validate JSONL parsing, stable question IDs, option uniqueness, correct-answer validity, record counts, and a source-versus-staging diff.
10. Promote staged files only after review of the diff and validation report.

## Guardrails For A Future Patcher

- Default to dry-run mode and require an explicit `--apply` flag.
- Require `--input-dir`, `--staging-dir`, and `--backup-dir`; reject overlapping directories.
- Patch only IDs listed in `remediation_manifest.csv`.
- Fail closed on malformed JSON, missing IDs, duplicate IDs, unexpected schema, or record-count changes.
- Emit per-question before/after records and a machine-readable validation report.
- Keep placeholder replacement separate from mechanical notation fixes.
