#!/usr/bin/env python3
"""
translate_pack_jsonl.py — Offline translation pipeline for math JSONL packs.

Subcommands
-----------
  extract   Scan source JSONL packs; emit deduplicated review CSVs per locale.
  apply     Apply reviewed CSVs to source JSONL; write translated JSONL + log.
  report    Print per-pack coverage table and optional QA samples.

Directory convention  (relative to repo root)
---------------------------------------------
  assets/packs/en-GB/<pack>.jsonl        source packs          (read-only)
  translations/csv/<locale>/<pack>.csv   review CSVs           (extract writes, apply reads)
  translations/out/<locale>/<pack>.jsonl translated output      (apply writes)
  translations/log/<locale>/<pack>.log   warnings + untranslated report (apply writes)

Usage examples
--------------
  python tools/translate_pack_jsonl.py extract
  python tools/translate_pack_jsonl.py apply --locales de-CH
  python tools/translate_pack_jsonl.py report --samples
  python tools/translate_pack_jsonl.py extract --packs KS4_merged_deduped --locales fr-CH it-CH
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import pathlib
import re
import sys
from typing import Any, Generator

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent

SOURCE_LOCALE = "en-GB"
TARGET_LOCALES = ["de-CH", "fr-CH", "it-CH"]
PACKS = [
    "KS2_bank_ok_10000",
    "KS3_bank_ok_10000",
    "KS4_merged_deduped",
    "KS5_merged_deduped",
]

# Human-facing fields, in resolution order.
# Primary (stem / question) — translate whenever present and non-empty.
# Secondary (hint, rationale) — translate only if non-empty.
_PRIMARY_FIELDS = ("stem", "question")
_SECONDARY_FIELDS = ("hint", "rationale")
HUMAN_FIELDS: tuple[str, ...] = _PRIMARY_FIELDS + _SECONDARY_FIELDS

# Per-segment: max question IDs stored in context_ids column (reviewer aid).
_CTX_LIMIT = 3
# QA sample rows shown by `report --samples`.
_QA_SAMPLES = 5

# Protected-token regex: these must survive verbatim into any translation.
#   $$display math$$   $inline math$   {placeholder}   \LaTeXcommand
_PROTECTED_RE = re.compile(
    r"\$\$[^$]+?\$\$"
    r"|\$[^$]+?\$"
    r"|\{[A-Za-z_]\w*\}"
    r"|\\[A-Za-z]+"
)

CSV_FIELDS = ["seg_id", "source_text", "locale_target", "translation", "context_ids"]

# ---------------------------------------------------------------------------
# Core helpers  (pure — no I/O, easy to unit-test)
# ---------------------------------------------------------------------------


def seg_id(text: str) -> str:
    """Return a stable 16-char hex SHA-256 digest of the UTF-8 source text."""
    return hashlib.sha256(text.encode()).hexdigest()[:16]


def protected_tokens(text: str) -> frozenset[str]:
    """Return the set of protected tokens (LaTeX, placeholders) found in *text*."""
    return frozenset(_PROTECTED_RE.findall(text))


def validate_placeholders(source: str, translation: str) -> list[str]:
    """Return warning strings for tokens present in source but absent in translation."""
    missing = protected_tokens(source) - protected_tokens(translation)
    return [f"missing token {t!r}" for t in sorted(missing)]


def human_fields_of(record: dict[str, Any]) -> list[tuple[str, str]]:
    """
    Return [(field_name, text), ...] for non-empty human-facing fields in *record*.
    Fields are returned in HUMAN_FIELDS order; empty / non-string values are skipped.
    """
    result = []
    for fld in HUMAN_FIELDS:
        val = record.get(fld)
        if isinstance(val, str) and val.strip():
            result.append((fld, val))
    return result


# ---------------------------------------------------------------------------
# I/O helpers
# ---------------------------------------------------------------------------


def iter_jsonl(
    path: pathlib.Path,
) -> Generator[tuple[int, dict], None, None]:
    """
    Yield (1-based line_no, record) streaming *path* line by line.
    Malformed lines emit a warning to stderr and are skipped.
    """
    with path.open(encoding="utf-8") as fh:
        for line_no, raw in enumerate(fh, 1):
            raw = raw.strip()
            if not raw:
                continue
            try:
                yield line_no, json.loads(raw)
            except json.JSONDecodeError as exc:
                _warn(f"line {line_no} in {path.name}: JSON decode error — {exc}")


def _warn(msg: str) -> None:
    print(f"  WARNING {msg}", file=sys.stderr)


# ---------------------------------------------------------------------------
# Path helpers
# ---------------------------------------------------------------------------


def source_path(pack: str) -> pathlib.Path:
    return REPO_ROOT / "assets" / "packs" / SOURCE_LOCALE / f"{pack}.jsonl"


def csv_path(locale: str, pack: str) -> pathlib.Path:
    return REPO_ROOT / "translations" / "csv" / locale / f"{pack}.csv"


def out_path(locale: str, pack: str) -> pathlib.Path:
    return REPO_ROOT / "translations" / "out" / locale / f"{pack}.jsonl"


def log_path(locale: str, pack: str) -> pathlib.Path:
    return REPO_ROOT / "translations" / "log" / locale / f"{pack}.log"


# ---------------------------------------------------------------------------
# extract
# ---------------------------------------------------------------------------


def cmd_extract(args: argparse.Namespace) -> None:
    """
    Scan source packs and write a review CSV for each (pack, locale) pair.

    Each CSV row is one unique segment (deduplicated by source text).
    Re-running is safe: previously entered translations are preserved in place
    and only genuinely new segments are added.
    """
    packs = args.packs or PACKS
    locales = args.locales or TARGET_LOCALES

    for pack in packs:
        src = source_path(pack)
        if not src.exists():
            _warn(f"source not found: {src} — skipping {pack}")
            continue

        # Stream source; collect unique segments.
        seg_order: list[str] = []               # seg_ids in first-seen order
        seg_texts: dict[str, str] = {}          # seg_id -> source_text
        seg_ctx: dict[str, list[str]] = {}      # seg_id -> [qid, ...]
        total_lines = 0

        for line_no, record in iter_jsonl(src):
            total_lines += 1
            qid = str(record.get("id", f"line_{line_no}"))
            for _fld, text in human_fields_of(record):
                sid = seg_id(text)
                if sid not in seg_texts:
                    seg_order.append(sid)
                    seg_texts[sid] = text
                    seg_ctx[sid] = []
                if len(seg_ctx[sid]) < _CTX_LIMIT:
                    seg_ctx[sid].append(qid)

        print(f"  {pack}: {total_lines:,} lines, {len(seg_order):,} unique segments")

        for locale in locales:
            dest = csv_path(locale, pack)
            dest.parent.mkdir(parents=True, exist_ok=True)

            # Merge with existing reviewer work.
            existing: dict[str, str] = {}
            if dest.exists():
                with dest.open(newline="", encoding="utf-8") as fh:
                    for row in csv.DictReader(fh):
                        t = row.get("translation", "").strip()
                        if t:
                            existing[row["seg_id"]] = t

            with dest.open("w", newline="", encoding="utf-8") as fh:
                writer = csv.DictWriter(
                    fh, fieldnames=CSV_FIELDS, quoting=csv.QUOTE_ALL
                )
                writer.writeheader()
                for sid in seg_order:
                    writer.writerow(
                        {
                            "seg_id": sid,
                            "source_text": seg_texts[sid],
                            "locale_target": locale,
                            "translation": existing.get(sid, ""),
                            "context_ids": ";".join(seg_ctx[sid]),
                        }
                    )

            n_new = len(seg_order) - len(existing)
            print(
                f"    {locale}  {dest.relative_to(REPO_ROOT)}"
                f"  ({len(existing)} kept, {n_new} new)"
            )


# ---------------------------------------------------------------------------
# apply
# ---------------------------------------------------------------------------


def _load_translations(locale: str, pack: str) -> dict[str, str]:
    """Return {seg_id: translation} for CSV rows with a non-empty translation."""
    result: dict[str, str] = {}
    p = csv_path(locale, pack)
    if not p.exists():
        return result
    with p.open(newline="", encoding="utf-8") as fh:
        for row in csv.DictReader(fh):
            t = row.get("translation", "").strip()
            if t:
                result[row["seg_id"]] = t
    return result


def cmd_apply(args: argparse.Namespace) -> None:
    """
    Stream source JSONL, substitute reviewed translations, emit output JSONL.

    Policy:
      - Translated segments: field value is replaced with the reviewed text.
        Protected tokens (LaTeX, {placeholders}) are checked; mismatches are
        logged as PLACEHOLDER_WARNING but the translation is still applied.
      - Untranslated segments: English value is kept as-is; the log records
        every missing entry so reviewers can prioritise follow-up work.
    All non-human fields (IDs, numbers, check_* expressions, params, …) are
    written back byte-for-byte as parsed from the source.
    """
    packs = args.packs or PACKS
    locales = args.locales or TARGET_LOCALES

    for locale in locales:
        for pack in packs:
            src = source_path(pack)
            if not src.exists():
                _warn(f"source not found: {src} — skipping")
                continue

            translations = _load_translations(locale, pack)
            dest = out_path(locale, pack)
            dest_log = log_path(locale, pack)
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest_log.parent.mkdir(parents=True, exist_ok=True)

            total_segs = translated_segs = ph_warnings = 0
            untranslated: list[tuple[int, str, str]] = []  # (line_no, qid, fld)

            with dest.open("w", encoding="utf-8") as out_fh, \
                 dest_log.open("w", encoding="utf-8") as log_fh:

                log_fh.write(f"# Translation apply log — {locale}/{pack}\n\n")

                for line_no, record in iter_jsonl(src):
                    qid = str(record.get("id", f"line_{line_no}"))

                    for fld, source_text in human_fields_of(record):
                        total_segs += 1
                        sid = seg_id(source_text)

                        if sid in translations:
                            t = translations[sid]
                            warns = validate_placeholders(source_text, t)
                            if warns:
                                ph_warnings += 1
                                log_fh.write(
                                    f"PLACEHOLDER_WARNING"
                                    f"  line={line_no}  id={qid}  field={fld}\n"
                                    f"  src : {source_text!r}\n"
                                    f"  tgt : {t!r}\n"
                                    f"  warn: {'; '.join(warns)}\n\n"
                                )
                            record[fld] = t
                            translated_segs += 1
                        else:
                            untranslated.append((line_no, qid, fld))

                    out_fh.write(json.dumps(record, ensure_ascii=False) + "\n")

                if untranslated:
                    log_fh.write(
                        f"# UNTRANSLATED SEGMENTS ({len(untranslated)})\n\n"
                    )
                    for line_no, qid, fld in untranslated:
                        log_fh.write(
                            f"UNTRANSLATED  line={line_no}  id={qid}  field={fld}\n"
                        )

            cov = translated_segs / total_segs * 100 if total_segs else 0.0
            status = "[ok]" if cov == 100.0 else ("[~~]" if cov > 0 else "[--]")
            print(
                f"  {status} {locale}/{pack}:  "
                f"{translated_segs}/{total_segs} segs ({cov:.1f}%),  "
                f"{ph_warnings} placeholder warning(s),  "
                f"{len(untranslated)} untranslated"
            )


# ---------------------------------------------------------------------------
# report
# ---------------------------------------------------------------------------


def cmd_report(args: argparse.Namespace) -> None:
    """
    Print a per-locale, per-pack coverage table from the review CSVs.
    With --samples, also prints up to 5 source/translation QA pairs per pack.
    """
    packs = args.packs or PACKS
    locales = args.locales or TARGET_LOCALES

    for locale in locales:
        print(f"\n{'=' * 62}")
        print(f"  Locale: {locale}")
        print(f"{'=' * 62}")
        print(f"  {'Pack':<32} {'Total':>7} {'Trans':>7} {'Cov%':>7}")
        print(f"  {'-' * 32} {'-' * 7} {'-' * 7} {'-' * 7}")

        for pack in packs:
            p = csv_path(locale, pack)
            if not p.exists():
                print(f"  {pack:<32} {'(no CSV yet)':>22}")
                continue

            total = translated = 0
            samples: list[tuple[str, str]] = []

            with p.open(newline="", encoding="utf-8") as fh:
                for row in csv.DictReader(fh):
                    total += 1
                    t = row.get("translation", "").strip()
                    if t:
                        translated += 1
                        if len(samples) < _QA_SAMPLES:
                            samples.append((row["source_text"], t))

            cov = translated / total * 100 if total else 0.0
            flag = " [ok]" if cov == 100.0 else (" [~~]" if cov > 0 else " [--]")
            print(
                f"  {pack:<32} {total:>7,} {translated:>7,} {cov:>6.1f}%{flag}"
            )

            if args.samples and samples:
                for i, (src, tgt) in enumerate(samples, 1):
                    src_d = src[:70] + ("…" if len(src) > 70 else "")
                    tgt_d = tgt[:70] + ("…" if len(tgt) > 70 else "")
                    print(f"      QA {i}  en : {src_d}")
                    print(f"           {locale}: {tgt_d}")
                print()


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def _add_filters(p: argparse.ArgumentParser) -> None:
    p.add_argument(
        "--packs",
        nargs="*",
        metavar="PACK",
        help="Restrict to these pack names (default: all four KS packs)",
    )
    p.add_argument(
        "--locales",
        nargs="*",
        metavar="LOCALE",
        help="Restrict to these target locales (default: de-CH fr-CH it-CH)",
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="translate_pack_jsonl.py",
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_ext = sub.add_parser("extract", help="Emit review CSVs from source JSONL")
    _add_filters(p_ext)

    p_app = sub.add_parser("apply", help="Apply reviewed CSVs, write translated JSONL")
    _add_filters(p_app)

    p_rep = sub.add_parser("report", help="Print coverage table")
    _add_filters(p_rep)
    p_rep.add_argument(
        "--samples",
        action="store_true",
        help="Print QA sample rows under each pack",
    )

    return parser


def main() -> None:
    args = build_parser().parse_args()
    {"extract": cmd_extract, "apply": cmd_apply, "report": cmd_report}[args.cmd](args)


if __name__ == "__main__":
    main()
