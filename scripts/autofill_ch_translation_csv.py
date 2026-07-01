#!/usr/bin/env python3
"""Autofill CH review CSV rows from deterministic translation phrasebooks."""

from __future__ import annotations

import argparse
import csv
import sys
from collections import Counter
from pathlib import Path

from mine_translation_templates import normalize_source_text, pattern_id, render_template


LOCALES = ("de-CH", "fr-CH", "it-CH")
PHRASEBOOK_FIELDS = ("pattern_id", "translated_template")

SEED_TRANSLATIONS = {
    "de-CH": {
        "Calculate: {n} + {n}": "Berechne: {n} + {n}",
        "Calculate: {n} - {n}": "Berechne: {n} - {n}",
        "Calculate: {n} × {n}": "Berechne: {n} × {n}",
        "Calculate: {n} ÷ {n}": "Berechne: {n} ÷ {n}",
        "Convert {frac} to a percentage.": "Wandle {frac} in eine Prozentzahl um.",
        "A value of {n} is increased by {n}%.": "Ein Wert von {n} wird um {n}% erhöht.",
        "A value of {n} is decreased by {n}%.": "Ein Wert von {n} wird um {n}% verringert.",
        "Given density = mass / volume, and density={n}, mass={n}. Find volume.": "Gegeben: Dichte = Masse / Volumen, Dichte={n}, Masse={n}. Bestimme das Volumen.",
        "A sequence starts at {n} and increases by {n} each time. What is the {n}th term?": "Eine Folge beginnt bei {n} und nimmt jedes Mal um {n} zu. Wie lautet das {n}. Glied?",
        "Expand and simplify: (x+{n})(x-{n})": "Multipliziere aus und vereinfache: (x+{n})(x-{n})",
    },
    "fr-CH": {
        "Calculate: {n} + {n}": "Calcule : {n} + {n}",
        "Calculate: {n} - {n}": "Calcule : {n} - {n}",
        "Calculate: {n} × {n}": "Calcule : {n} × {n}",
        "Calculate: {n} ÷ {n}": "Calcule : {n} ÷ {n}",
        "Convert {frac} to a percentage.": "Convertis {frac} en pourcentage.",
        "A value of {n} is increased by {n}%.": "Une valeur de {n} est augmentée de {n} %.",
        "A value of {n} is decreased by {n}%.": "Une valeur de {n} est diminuée de {n} %.",
        "Given density = mass / volume, and density={n}, mass={n}. Find volume.": "Sachant que densité = masse / volume, densité={n}, masse={n}. Trouve le volume.",
        "A sequence starts at {n} and increases by {n} each time. What is the {n}th term?": "Une suite commence à {n} et augmente de {n} à chaque fois. Quel est son {n}e terme ?",
        "Expand and simplify: (x+{n})(x-{n})": "Développe et simplifie : (x+{n})(x-{n})",
    },
    "it-CH": {
        "Calculate: {n} + {n}": "Calcola: {n} + {n}",
        "Calculate: {n} - {n}": "Calcola: {n} - {n}",
        "Calculate: {n} × {n}": "Calcola: {n} × {n}",
        "Calculate: {n} ÷ {n}": "Calcola: {n} ÷ {n}",
        "Convert {frac} to a percentage.": "Converti {frac} in percentuale.",
        "A value of {n} is increased by {n}%.": "Un valore di {n} viene aumentato del {n}%.",
        "A value of {n} is decreased by {n}%.": "Un valore di {n} viene diminuito del {n}%.",
        "Given density = mass / volume, and density={n}, mass={n}. Find volume.": "Data densità = massa / volume, densità={n}, massa={n}. Trova il volume.",
        "A sequence starts at {n} and increases by {n} each time. What is the {n}th term?": "Una successione inizia da {n} e aumenta di {n} ogni volta. Qual è il termine numero {n}?",
        "Expand and simplify: (x+{n})(x-{n})": "Sviluppa e semplifica: (x+{n})(x-{n})",
    },
}


def write_seed_phrasebook(path: Path, locale: str) -> bool:
    """Write starter templates once, preserving subsequent reviewer edits."""
    if path.exists():
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=PHRASEBOOK_FIELDS)
        writer.writeheader()
        for normalized, translated in SEED_TRANSLATIONS[locale].items():
            writer.writerow(
                {
                    "pattern_id": pattern_id(normalized),
                    "translated_template": translated,
                }
            )
    return True


def read_phrasebook(path: Path) -> dict[str, str]:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if tuple(reader.fieldnames or ()) != PHRASEBOOK_FIELDS:
            raise ValueError(f"{path}: expected columns {PHRASEBOOK_FIELDS}")
        rows = list(reader)
    phrasebook: dict[str, str] = {}
    for row in rows:
        key = row["pattern_id"].strip()
        translated = row["translated_template"].strip()
        if not key or not translated:
            continue
        if key in phrasebook:
            raise ValueError(f"{path}: duplicate pattern_id {key}")
        phrasebook[key] = translated
    return phrasebook


def autofill_csv(
    input_csv: Path, phrasebook_csv: Path, output_csv: Path, residual_csv: Path
) -> tuple[int, int, Counter[str]]:
    phrasebook = read_phrasebook(phrasebook_csv)
    with input_csv.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        fieldnames = tuple(reader.fieldnames or ())
        rows = list(reader)
    if "source_text" not in fieldnames or "translated_text" not in fieldnames:
        raise ValueError(f"{input_csv}: expected source_text and translated_text columns")

    residual_rows: list[dict[str, str]] = []
    residual_patterns: Counter[str] = Counter()
    matched = 0
    for row in rows:
        normalized = normalize_source_text(row["source_text"])
        translated_template = phrasebook.get(pattern_id(normalized))
        if translated_template:
            if not row["translated_text"].strip():
                row["translated_text"] = render_template(
                    row["source_text"], translated_template
                )
            matched += 1
        else:
            residual_rows.append(row)
            residual_patterns[normalized] += 1

    output_csv.parent.mkdir(parents=True, exist_ok=True)
    for path, selected_rows in ((output_csv, rows), (residual_csv, residual_rows)):
        with path.open("w", newline="", encoding="utf-8-sig") as handle:
            writer = csv.DictWriter(handle, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(selected_rows)
    return matched, len(rows), residual_patterns


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--in-csv", "--in_csv", dest="input_csv", type=Path, required=True)
    parser.add_argument("--phrasebook", type=Path, required=True)
    parser.add_argument("--out-csv", "--out_csv", dest="output_csv", type=Path, required=True)
    parser.add_argument("--residual-csv", type=Path, required=True)
    args = parser.parse_args()
    matched, total, residuals = autofill_csv(
        args.input_csv, args.phrasebook, args.output_csv, args.residual_csv
    )
    print(f"Wrote {args.output_csv}: matched_rows={matched}/{total}")
    if residuals:
        print("Top residual patterns:")
        for normalized, count in residuals.most_common(10):
            print(f"  {count:>5}  {normalized}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError) as error:
        print(f"CH translation autofill failed: {error}", file=sys.stderr)
        raise SystemExit(1)
