#!/usr/bin/env python3
"""Normalize daily brain teaser assets into the canonical array schema."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


ID_PATTERN = re.compile(r"^t\d{3}$")
DIFFICULTIES = {"easy", "medium", "hard"}
QUESTION_KEYS = ("question", "teaser", "q", "frag", "domanda")
ANSWER_KEYS = ("answer", "a", "réponse", "reponse", "antwort", "risposta")


def _clean_source(source: str) -> str:
    source = source.lstrip("\ufeff").strip()
    source = re.sub(r"^```(?:json)?\s*", "", source, flags=re.IGNORECASE)
    source = re.sub(r"\s*```$", "", source)
    return source.strip()


def _parse_json(source: str, path: Path) -> Any:
    attempts = [source]
    repaired = source.translate(
        str.maketrans({"\u201c": '"', "\u201d": '"', "\u201e": '"'})
    )
    repaired = re.sub(r",(\s*[}\]])", r"\1", repaired)
    attempts.append(repaired)

    for candidate in attempts:
        try:
            return json.loads(candidate)
        except json.JSONDecodeError:
            pass

    starts = [index for index in (repaired.find("["), repaired.find("{")) if index >= 0]
    if starts:
        candidate = repaired[min(starts) :]
        try:
            return json.loads(candidate)
        except json.JSONDecodeError as error:
            raise ValueError(
                f"{path}: invalid JSON at line {error.lineno}, "
                f"column {error.colno}: {error.msg}"
            ) from error
    raise ValueError(f"{path}: content is neither JSON nor a Markdown table")


def _split_markdown_row(line: str) -> list[str]:
    placeholder = "\0PIPE\0"
    escaped = line.strip().strip("|").replace(r"\|", placeholder)
    return [cell.strip().replace(placeholder, "|") for cell in escaped.split("|")]


def _parse_markdown_table(source: str, path: Path) -> list[dict[str, Any]]:
    rows = [
        _split_markdown_row(line)
        for line in source.splitlines()
        if line.strip().startswith("|")
    ]
    if len(rows) < 3:
        raise ValueError(f"{path}: Markdown table has no data rows")

    entries: list[dict[str, Any]] = []
    for line_number, cells in enumerate(rows[2:], start=3):
        if len(cells) < 3:
            raise ValueError(
                f"{path}:{line_number}: expected ID, question, and answer columns"
            )
        entries.append(
            {
                "id": cells[0],
                "question": cells[1],
                "answer": "|".join(cells[2:]).strip(),
            }
        )
    return entries


def _first_text(entry: dict[str, Any], keys: tuple[str, ...]) -> str:
    lowered = {str(key).strip().lower(): value for key, value in entry.items()}
    for key in keys:
        value = lowered.get(key)
        if isinstance(value, str) and value.strip():
            return re.sub(r"\s+", " ", value).strip()
    return ""


def _normal_sort_key(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip().casefold()


def normalize(path: Path) -> list[dict[str, Any]]:
    source = _clean_source(path.read_text(encoding="utf-8-sig"))
    if source.startswith("|"):
        raw_entries = _parse_markdown_table(source, path)
    else:
        decoded = _parse_json(source, path)
        if isinstance(decoded, dict):
            decoded = decoded.get("teasers", decoded.get("items"))
        if not isinstance(decoded, list):
            raise ValueError(f"{path}: top-level value must be a JSON array")
        raw_entries = decoded

    entries: list[dict[str, Any]] = []
    for index, value in enumerate(raw_entries, start=1):
        if not isinstance(value, dict):
            raise ValueError(f"{path}: entry {index} must be an object")
        question = _first_text(value, QUESTION_KEYS)
        answer = _first_text(value, ANSWER_KEYS)
        if not question:
            raise ValueError(f"{path}: entry {index} has an empty question")
        if not answer:
            raise ValueError(f"{path}: entry {index} has an empty answer")
        difficulty = str(value.get("difficulty", "easy")).strip().lower()
        if difficulty not in DIFFICULTIES:
            difficulty = "easy"
        tags = value.get("tags", ["all-ages"])
        if not isinstance(tags, list) or not all(
            isinstance(tag, str) and tag.strip() for tag in tags
        ):
            tags = ["all-ages"]
        entries.append(
            {
                "id": str(value.get("id", "")).strip(),
                "question": question,
                "answer": answer,
                "difficulty": difficulty,
                "tags": [tag.strip() for tag in tags],
            }
        )

    ids = [entry["id"] for entry in entries]
    regenerate_ids = (
        any(not ID_PATTERN.fullmatch(teaser_id) for teaser_id in ids)
        or len(set(ids)) != len(ids)
    )
    if regenerate_ids:
        entries.sort(key=lambda entry: _normal_sort_key(entry["question"]))
        if len(entries) > 999:
            raise ValueError(f"{path}: {len(entries)} entries exceed the t999 limit")
        for index, entry in enumerate(entries, start=1):
            entry["id"] = f"t{index:03d}"

    return entries


def _canonical(entries: list[dict[str, Any]]) -> str:
    return json.dumps(entries, ensure_ascii=False, indent=2) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--in",
        dest="inputs",
        action="append",
        required=True,
        type=Path,
        help="Teaser asset to normalize; repeat for multiple locales.",
    )
    parser.add_argument(
        "--check-only",
        action="store_true",
        help="Validate canonical content without writing files.",
    )
    args = parser.parse_args()

    failed = False
    for path in args.inputs:
        try:
            entries = normalize(path)
            canonical = _canonical(entries)
            if args.check_only:
                current = path.read_text(encoding="utf-8-sig")
                if current != canonical:
                    print(f"{path}: valid but not canonical", file=sys.stderr)
                    failed = True
                    continue
            else:
                path.write_text(canonical, encoding="utf-8", newline="\n")
            first_id = entries[0]["id"] if entries else "-"
            last_id = entries[-1]["id"] if entries else "-"
            print(f"{path}: count={len(entries)}, ids={first_id}..{last_id}")
        except (OSError, ValueError) as error:
            print(error, file=sys.stderr)
            failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
