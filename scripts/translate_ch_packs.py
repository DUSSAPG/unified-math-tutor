#!/usr/bin/env python3
"""Export and apply reviewed CH translations for runtime JSONL packs.

This script is intentionally offline. It exports a translation-memory CSV for
review, then applies reviewed translations while rejecting placeholder or math
token changes. It never translates IDs or machine-check fields.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import sys
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


SOURCE_ROOT = Path("assets/packs/en-GB")
REPORT_PATH = Path("translation_report.csv")
LOCALES = ("de-CH", "fr-CH", "it-CH")
PACKS = (
    "KS2_bank_ok_10000.jsonl",
    "KS3_bank_ok_10000.jsonl",
    "KS4_merged_deduped.jsonl",
    "KS5_merged_deduped.jsonl",
)
TEXT_FIELDS = ("stem", "question", "hint", "rationale", "explanation")
LIST_TEXT_FIELDS = ("options",)
TOKEN_RE = re.compile(
    r"""
    \{[^{}]+\}                         # named placeholders
    |\$[^$]+\$                         # inline LaTeX
    |\\(?:\[[^\]]*\\\]|\([^)]*\\\))    # displayed or inline escaped LaTeX
    |\\[A-Za-z]+                       # LaTeX commands
    |\b\d+(?:\.\d+)?(?:/\d+)?\b        # numeric values and fractions
    |[A-Za-z]\^\d+                     # powers such as x^2
    |[=+\-*/]                          # operators
    """,
    re.VERBOSE,
)
WORD_RE = re.compile(r"[A-Za-zÀ-ÖØ-öø-ÿ]")
REPORT_FIELDS = (
    "row_type",
    "locale",
    "pack",
    "input_rows",
    "output_rows",
    "translated_segments",
    "sample_id",
    "field",
    "source_text",
    "translated_text",
    "status",
)


def main() -> int:
    parser = argparse.ArgumentParser()
    commands = parser.add_subparsers(dest="command", required=True)
    export = commands.add_parser("export", help="Export translation-memory CSV")
    export.add_argument(
        "--output",
        type=Path,
        default=Path("reports/ch_translation_template.csv"),
    )
    apply = commands.add_parser("apply", help="Apply reviewed translations")
    apply.add_argument("--locale", choices=LOCALES, required=True)
    apply.add_argument("--translations", type=Path, required=True)
    apply.add_argument("--report", type=Path, default=REPORT_PATH)
    args = parser.parse_args()
    if args.command == "export":
        return export_template(args.output)
    return apply_translations(args.locale, args.translations, args.report)


def export_template(output: Path) -> int:
    occurrences: dict[str, list[str]] = defaultdict(list)
    for pack in PACKS:
        for row in read_jsonl(SOURCE_ROOT / pack):
            for field, text in iter_translatable(row):
                occurrences[text].append(f"{pack}:{row.get('id', '')}:{field}")
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=(
                "locale",
                "segment_hash",
                "source_text",
                "translated_text",
                "occurrences",
                "sample_locations",
            ),
        )
        writer.writeheader()
        for locale in LOCALES:
            for source_text in sorted(occurrences):
                locations = occurrences[source_text]
                writer.writerow(
                    {
                        "locale": locale,
                        "segment_hash": segment_hash(source_text),
                        "source_text": source_text,
                        "translated_text": "",
                        "occurrences": len(locations),
                        "sample_locations": " | ".join(locations[:3]),
                    }
                )
    print(f"Exported {len(occurrences)} source segments x {len(LOCALES)} locales to {output}")
    return 0


def apply_translations(locale: str, translations_path: Path, report_path: Path) -> int:
    memory = load_translation_memory(locale, translations_path)
    missing: set[str] = set()
    report_rows: list[dict[str, Any]] = []
    pending_outputs: list[tuple[Path, list[dict[str, Any]]]] = []
    for pack in PACKS:
        source_rows = list(read_jsonl(SOURCE_ROOT / pack))
        output_rows: list[dict[str, Any]] = []
        translated_segments = 0
        samples: list[dict[str, Any]] = []
        for source in source_rows:
            translated = dict(source)
            source_id = source.get("id")
            if "lang" in translated:
                translated["lang"] = locale
            for field, source_text in iter_translatable(source):
                target_text = memory.get(source_text)
                if target_text is None:
                    missing.add(source_text)
                    continue
                validate_tokens(source_text, target_text)
                set_text(translated, field, target_text)
                translated_segments += 1
                if len(samples) < 5:
                    samples.append(
                        report_row(
                            "sample",
                            locale,
                            pack,
                            sample_id=str(source_id or ""),
                            field=field,
                            source_text=source_text,
                            translated_text=target_text,
                            status="qa_required",
                        )
                    )
            if translated.get("id") != source_id:
                raise ValueError(f"{pack}: id changed for {source_id!r}")
            output_rows.append(translated)
        report_rows.append(
            report_row(
                "summary",
                locale,
                pack,
                input_rows=len(source_rows),
                output_rows=len(output_rows),
                translated_segments=translated_segments,
                status="generated",
            )
        )
        report_rows.extend(samples)
        pending_outputs.append((Path("assets/packs") / locale / pack, output_rows))
    if missing:
        examples = "\n".join(f" - {text}" for text in sorted(missing)[:20])
        raise ValueError(
            f"{len(missing)} reviewed translations are missing for {locale}.\n{examples}"
        )
    for output_path, rows in pending_outputs:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with output_path.open("w", encoding="utf-8") as handle:
            for row in rows:
                handle.write(json.dumps(row, ensure_ascii=False, separators=(",", ":")))
                handle.write("\n")
    write_report(report_path, locale, report_rows)
    print(f"Generated {len(pending_outputs)} {locale} packs and {report_path}")
    return 0


def load_translation_memory(locale: str, path: Path) -> dict[str, str]:
    memory: dict[str, str] = {}
    with path.open(newline="", encoding="utf-8-sig") as handle:
        for row in csv.DictReader(handle):
            if row.get("locale") != locale:
                continue
            source = row.get("source_text", "")
            expected_hash = row.get("segment_hash", "")
            target = row.get("translated_text", "").strip()
            if not source or not target:
                continue
            actual_hash = segment_hash(source)
            if expected_hash != actual_hash:
                raise ValueError(
                    f"Stale or malformed segment hash for {source!r}: "
                    f"expected {actual_hash}, found {expected_hash or '<missing>'}"
                )
            existing = memory.get(source)
            if existing is not None and existing != target:
                raise ValueError(f"Conflicting translations for {source!r}")
            memory[source] = target
    return memory


def segment_hash(text: str) -> str:
    normalized = unicodedata.normalize("NFKC", text)
    normalized = re.sub(r"\s+", " ", normalized).strip()
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()


def read_jsonl(path: Path):
    with path.open(encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            if not line.strip():
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError as error:
                raise ValueError(f"{path}:{line_number}: invalid JSON: {error}") from error
            if not isinstance(row, dict):
                raise ValueError(f"{path}:{line_number}: JSONL line must be an object")
            yield row


def iter_translatable(row: dict[str, Any]):
    for field in TEXT_FIELDS:
        value = row.get(field)
        if isinstance(value, str) and should_translate(value):
            yield field, value
    for field in LIST_TEXT_FIELDS:
        values = row.get(field)
        if not isinstance(values, list):
            continue
        for index, value in enumerate(values):
            if isinstance(value, str) and should_translate(value):
                yield f"{field}[{index}]", value


def should_translate(text: str) -> bool:
    residual = TOKEN_RE.sub("", text)
    return bool(text.strip() and re.search(r"[A-Za-zÀ-ÖØ-öø-ÿ]{2,}", residual))


def set_text(row: dict[str, Any], field: str, text: str) -> None:
    if "[" not in field:
        row[field] = text
        return
    name, raw_index = field[:-1].split("[", maxsplit=1)
    values = list(row[name])
    values[int(raw_index)] = text
    row[name] = values


def validate_tokens(source: str, target: str) -> None:
    source_tokens = Counter(TOKEN_RE.findall(source))
    target_tokens = Counter(TOKEN_RE.findall(target))
    if source_tokens != target_tokens:
        raise ValueError(
            "Translation changed placeholders or math tokens:\n"
            f" source={source!r}\n target={target!r}\n"
            f" source_tokens={dict(source_tokens)}\n target_tokens={dict(target_tokens)}"
        )


def report_row(
    row_type: str,
    locale: str,
    pack: str,
    *,
    input_rows: int | str = "",
    output_rows: int | str = "",
    translated_segments: int | str = "",
    sample_id: str = "",
    field: str = "",
    source_text: str = "",
    translated_text: str = "",
    status: str,
) -> dict[str, Any]:
    return {
        "row_type": row_type,
        "locale": locale,
        "pack": pack,
        "input_rows": input_rows,
        "output_rows": output_rows,
        "translated_segments": translated_segments,
        "sample_id": sample_id,
        "field": field,
        "source_text": source_text,
        "translated_text": translated_text,
        "status": status,
    }


def write_report(path: Path, locale: str, rows: list[dict[str, Any]]) -> None:
    retained: list[dict[str, Any]] = []
    if path.exists():
        with path.open(newline="", encoding="utf-8-sig") as handle:
            retained = [
                row for row in csv.DictReader(handle) if row.get("locale") != locale
            ]
    with path.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=REPORT_FIELDS)
        writer.writeheader()
        writer.writerows(retained)
        writer.writerows(rows)


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"Translation pipeline failed: {error}", file=sys.stderr)
        raise SystemExit(1)
