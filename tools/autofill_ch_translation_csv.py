#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Auto-fill CH translation review CSV using deterministic template rules.
Works for de-CH, fr-CH, it-CH.

Assumptions:
- Input CSV includes a source column (commonly: source_text or source).
- It includes either:
  A) per-locale columns: de-CH, fr-CH, it-CH (preferred), OR
  B) a single column translated_text plus a locale column (less common), OR
  C) you're running a per-locale filtered CSV with translated_text only.

This script tries to detect columns and fill what's present.
"""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path
from typing import Dict, Tuple, Optional

# --- Regex helpers: preserve math-ish regions ---
# We do NOT want to alter content inside these blocks.
MATH_PATTERNS = [
    r"\$\$.*?\$\$",   # $$...$$
    r"\$.*?\$",       # $...$
    r"\\\(.+?\\\)",   # \( ... \)
    r"\\\[.+?\\\]",   # \[ ... \]
    r"∫",             # integral sign is fine; we don't translate math around it
]

MATH_RE = re.compile("|".join(f"({p})" for p in MATH_PATTERNS), re.DOTALL)

def split_preserving_math(text: str) -> Tuple[list[str], list[str]]:
    """
    Splits into non-math chunks and math chunks; recombine alternating.
    Returns (chunks, seps) where seps are math tokens/blocks.
    """
    chunks = []
    seps = []
    last = 0
    for m in MATH_RE.finditer(text):
        chunks.append(text[last:m.start()])
        seps.append(text[m.start():m.end()])
        last = m.end()
    chunks.append(text[last:])
    return chunks, seps

def recombine(chunks: list[str], seps: list[str]) -> str:
    out = []
    for i, c in enumerate(chunks):
        out.append(c)
        if i < len(seps):
            out.append(seps[i])
    return "".join(out)

# --- Template translations (high coverage) ---
DE = {
    "Find": "Bestimme",
    "Calculate": "Berechne",
    "Solve": "Löse",
    "Simplify": "Vereinfache",
    "Evaluate": "Berechne",
    "Convert": "Wandle um",
    "Round": "Runde",
    "Estimate": "Schätze",
}

FR = {
    "Find": "Calcule",
    "Calculate": "Calcule",
    "Solve": "Résous",
    "Simplify": "Simplifie",
    "Evaluate": "Calcule",
    "Convert": "Convertis",
    "Round": "Arrondis",
    "Estimate": "Estime",
}

IT = {
    "Find": "Trova",
    "Calculate": "Calcola",
    "Solve": "Risolvi",
    "Simplify": "Semplifica",
    "Evaluate": "Calcola",
    "Convert": "Converti",
    "Round": "Arrotonda",
    "Estimate": "Stima",
}

# Specific sentence-level templates (more accurate than word-for-word)
# Pattern -> replacement with captured groups preserved
TEMPLATES = {
    "de-CH": [
        (re.compile(r"^\s*Find\s+(.+)$", re.IGNORECASE), r"Bestimme \1"),
        (re.compile(r"^\s*Calculate\s*:\s*(.+)$", re.IGNORECASE), r"Berechne: \1"),
        (re.compile(r"^\s*Calculate\s+(.+)$", re.IGNORECASE), r"Berechne \1"),
        (re.compile(r"^\s*Solve\s+(.+)$", re.IGNORECASE), r"Löse \1"),
        (re.compile(r"^\s*Simplify\s+(.+)$", re.IGNORECASE), r"Vereinfache \1"),
        (re.compile(r"^\s*Evaluate\s+(.+)$", re.IGNORECASE), r"Berechne \1"),
        (re.compile(r"perimeter of a rectangle with length\s+(\d+)\s+and width\s+(\d+)", re.IGNORECASE),
         r"den Umfang eines Rechtecks mit Länge \1 und Breite \2"),
        (re.compile(r"area of a rectangle with length\s+(\d+)\s+and width\s+(\d+)", re.IGNORECASE),
         r"die Fläche eines Rechtecks mit Länge \1 und Breite \2"),
    ],
    "fr-CH": [
        (re.compile(r"^\s*Find\s+(.+)$", re.IGNORECASE), r"Calcule \1"),
        (re.compile(r"^\s*Calculate\s*:\s*(.+)$", re.IGNORECASE), r"Calcule : \1"),
        (re.compile(r"^\s*Calculate\s+(.+)$", re.IGNORECASE), r"Calcule \1"),
        (re.compile(r"^\s*Solve\s+(.+)$", re.IGNORECASE), r"Résous \1"),
        (re.compile(r"^\s*Simplify\s+(.+)$", re.IGNORECASE), r"Simplifie \1"),
        (re.compile(r"^\s*Evaluate\s+(.+)$", re.IGNORECASE), r"Calcule \1"),
        (re.compile(r"perimeter of a rectangle with length\s+(\d+)\s+and width\s+(\d+)", re.IGNORECASE),
         r"le périmètre d’un rectangle de longueur \1 et de largeur \2"),
        (re.compile(r"area of a rectangle with length\s+(\d+)\s+and width\s+(\d+)", re.IGNORECASE),
         r"l’aire d’un rectangle de longueur \1 et de largeur \2"),
    ],
    "it-CH": [
        (re.compile(r"^\s*Find\s+(.+)$", re.IGNORECASE), r"Trova \1"),
        (re.compile(r"^\s*Calculate\s*:\s*(.+)$", re.IGNORECASE), r"Calcola: \1"),
        (re.compile(r"^\s*Calculate\s+(.+)$", re.IGNORECASE), r"Calcola \1"),
        (re.compile(r"^\s*Solve\s+(.+)$", re.IGNORECASE), r"Risolvi \1"),
        (re.compile(r"^\s*Simplify\s+(.+)$", re.IGNORECASE), r"Semplifica \1"),
        (re.compile(r"^\s*Evaluate\s+(.+)$", re.IGNORECASE), r"Calcola \1"),
        (re.compile(r"perimeter of a rectangle with length\s+(\d+)\s+and width\s+(\d+)", re.IGNORECASE),
         r"il perimetro di un rettangolo con lunghezza \1 e larghezza \2"),
        (re.compile(r"area of a rectangle with length\s+(\d+)\s+and width\s+(\d+)", re.IGNORECASE),
         r"l’area di un rettangolo con lunghezza \1 e larghezza \2"),
    ],
}

def translate_line(src: str, locale: str) -> str:
    """
    Apply safe deterministic translations to the non-math chunks.
    """
    chunks, seps = split_preserving_math(src)

    def apply_templates(s: str) -> str:
        s0 = s

        for rx, repl in TEMPLATES[locale]:
            if rx.search(s0):
                s0 = rx.sub(repl, s0)

        # If no template matched, do light verb replacement at beginning.
        # Keep conservative: only replace first token if it is one of the known verbs.
        m = re.match(r"^\s*([A-Za-z]+)\b(.*)$", s0)
        if m:
            verb = m.group(1)
            rest = m.group(2)
            mapping = {"de-CH": DE, "fr-CH": FR, "it-CH": IT}[locale]
            if verb in mapping:
                return f"{mapping[verb]}{rest}"
        return s0

    new_chunks = [apply_templates(c) for c in chunks]
    return recombine(new_chunks, seps).strip()

def detect_columns(fieldnames: list[str]) -> Dict[str, str]:
    """
    Detect likely columns. Returns keys:
      - source_col
      - de_col / fr_col / it_col (if present)
      - translated_text_col (if present)
      - locale_col (if present)
    """
    lower = {f.lower(): f for f in fieldnames}

    def pick(*cands: str) -> Optional[str]:
        for c in cands:
            if c in lower:
                return lower[c]
        return None

    return {
        "source_col": pick("source_text", "source", "english", "text", "src"),
        "de_col": pick("de-ch", "de_ch", "de"),
        "fr_col": pick("fr-ch", "fr_ch", "fr"),
        "it_col": pick("it-ch", "it_ch", "it"),
        "translated_text_col": pick("translated_text", "translation", "target_text"),
        "locale_col": pick("locale", "target_locale"),
    }

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="in_csv", required=True, help="Input CSV path (review template).")
    ap.add_argument("--out", dest="out_csv", required=True, help="Output CSV path.")
    ap.add_argument("--locale", choices=["de-CH", "fr-CH", "it-CH", "ALL"], default="ALL",
                    help="Which locale to fill. Use ALL to fill all locale columns if present.")
    ap.add_argument("--overwrite", action="store_true",
                    help="Overwrite existing non-empty translation cells (default: only fill blanks).")
    args = ap.parse_args()

    inp = Path(args.in_csv)
    outp = Path(args.out_csv)

    with inp.open("r", encoding="utf-8", newline="") as f:
        rdr = csv.DictReader(f)
        rows = list(rdr)
        if not rdr.fieldnames:
            raise SystemExit("CSV has no header row.")
        cols = detect_columns(rdr.fieldnames)

    if not cols["source_col"]:
        raise SystemExit("Could not detect source column. Expected one of: source_text/source/english/text/src.")

    fieldnames = list(rows[0].keys())
    # Ensure locale columns exist if using translated_text mode.
    # We do not invent columns; we only fill what exists.
    fill_mode = "per_locale" if (cols["de_col"] or cols["fr_col"] or cols["it_col"]) else "translated_text"
    if fill_mode == "translated_text" and not cols["translated_text_col"]:
        raise SystemExit("Could not detect translation column. Expected translated_text/translation/target_text.")

    filled = {"de-CH": 0, "fr-CH": 0, "it-CH": 0}

    for r in rows:
        src = (r.get(cols["source_col"]) or "").strip()
        if not src:
            continue

        if fill_mode == "per_locale":
            for loc, colkey in [("de-CH", cols["de_col"]), ("fr-CH", cols["fr_col"]), ("it-CH", cols["it_col"])]:
                if args.locale != "ALL" and args.locale != loc:
                    continue
                if not colkey:
                    continue
                cur = (r.get(colkey) or "").strip()
                if cur and not args.overwrite:
                    continue
                r[colkey] = translate_line(src, loc)
                filled[loc] += 1
        else:
            # translated_text + optional locale column
            if cols["locale_col"]:
                loc = (r.get(cols["locale_col"]) or "").strip()
                if loc not in ("de-CH", "fr-CH", "it-CH"):
                    continue
                if args.locale != "ALL" and args.locale != loc:
                    continue
            else:
                # If there is no locale column, you must run once per locale and specify --locale.
                if args.locale == "ALL":
                    raise SystemExit("No locale column present; re-run with --locale de-CH (or fr-CH / it-CH).")
                loc = args.locale

            cur = (r.get(cols["translated_text_col"]) or "").strip()
            if cur and not args.overwrite:
                continue
            r[cols["translated_text_col"]] = translate_line(src, loc)
            filled[loc] += 1

    outp.parent.mkdir(parents=True, exist_ok=True)
    with outp.open("w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)

    print("Wrote:", str(outp))
    print("Filled:", filled)
    print("NOTE: This is deterministic template translation; review a sample before applying.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())