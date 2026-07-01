#!/usr/bin/env python3
"""
Rule-based JSONL pack translator for CH locales.

- Reads JSONL packs (one JSON object per line).
- Translates only human-facing fields:
  question/stem/prompt + options + hint/rationale/explanation (if present).
- Keeps IDs, answer indexes, check expressions, etc. byte-for-byte.
- Writes locale-specific packs into assets/packs/<locale>/...
- Produces a report of lines with likely-untranslated English leftovers.

Usage (from repo root):
  python tools/translate_packs_ch.py \
    --src_dir "assets/packs/en-GB" \
    --out_dir "assets/packs" \
    --locales de-CH fr-CH it-CH \
    --packs KS2_bank_ok_10000.jsonl KS3_bank_ok_10000.jsonl KS4_merged_deduped.jsonl KS5_merged_deduped.jsonl
"""

from __future__ import annotations

import argparse
import json
import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Tuple


HUMAN_TEXT_KEYS = [
    "question", "stem", "prompt", "text", "title",
    "hint", "rationale", "explanation", "solution",
]

OPTION_KEYS = ["options", "choices", "answers"]  # whichever your schema uses


# ----------------------------
# Locale rules
# ----------------------------

@dataclass(frozen=True)
class LocaleRules:
    locale: str
    # ordered regex substitutions (pattern, replacement)
    subs: List[Tuple[re.Pattern, str]]
    # marker words to detect leftover English that should have been translated
    english_markers: List[re.Pattern]


def _rx(pattern: str) -> re.Pattern:
    return re.compile(pattern, flags=re.IGNORECASE)


def build_rules() -> Dict[str, LocaleRules]:
    # Common patterns seen in procedural math packs.
    # Keep replacements simple + safe. Preserve numbers/variables via capture groups.

    # Tokens:
    #  - Allow × or x or * as multiplication symbol.
    #  - Allow ÷ or / for division.
    mul = r"(?:×|x|\*)"
    div = r"(?:÷|/)"
    eq = r"="

    # Generic English prompts:
    # Calculate: a + b
    calc_expr = _rx(rf"^\s*calculate\s*:\s*(.+)\s*$")
    work_out = _rx(rf"^\s*work\s+out\s*:\s*(.+)\s*$")
    simplify = _rx(r"^\s*simplify\s*:\s*(.+)\s*$")
    solve_for = _rx(r"^\s*solve\s+for\s+([a-z])\s*:\s*(.+)\s*$")
    solve = _rx(r"^\s*solve\s*:\s*(.+)\s*$")
    find_frac_of = _rx(r"^\s*find\s+(\d+/\d+)\s+of\s+(\d+)\s*\.?\s*$")
    find_percent_of = _rx(r"^\s*find\s+(\d+)\s*%\s+of\s+(\d+)\s*\.?\s*$")
    what_is = _rx(r"^\s*what\s+is\s+(.+?)\s*\?\s*$")
    convert_to = _rx(r"^\s*convert\s+(.+)\s+to\s+(.+)\s*\.?\s*$")

    # Geometry / measures:
    perimeter = _rx(r"^\s*find\s+the\s+perimeter\s+of\s+(.+)\s*\.?\s*$")
    area = _rx(r"^\s*find\s+the\s+area\s+of\s+(.+)\s*\.?\s*$")
    volume = _rx(r"^\s*find\s+the\s+volume\s+of\s+(.+)\s*\.?\s*$")

    # KS5-ish phrases:
    differentiate = _rx(r"^\s*differentiate\s+(.+)\s*$")
    integrate = _rx(r"^\s*integrate\s+(.+)\s*$")
    find_derivative = _rx(r"^\s*find\s+dy/dx\s+for\s+(.+)\s*$")
    evaluate_at = _rx(r"^\s*evaluate\s+(.+)\s+at\s+([a-z])\s*=\s*([-\d\.]+)\s*$")
    radians = _rx(r"^\s*convert\s+(\d+)\s*degrees\s+to\s+radians\s*\.?\s*$")
    degrees = _rx(r"^\s*convert\s+(\d+)\s*radians\s+to\s+degrees\s*\.?\s*$")

    # Trig identities/equations:
    prove_identity = _rx(r"^\s*prove\s+the\s+identity\s*:\s*(.+)\s*$")
    solve_trig = _rx(r"^\s*solve\s+the\s+trigonometric\s+equation\s*:\s*(.+)\s*$")

    # Probability / stats:
    prob_find = _rx(r"^\s*find\s+the\s+probability\s+that\s+(.+)\s*\.?\s*$")
    binomial = _rx(r"^\s*binomial\s*:\s*(.+)\s*$")
    normal = _rx(r"^\s*normal\s*:\s*(.+)\s*$")
    hypothesis = _rx(r"^\s*hypothesis\s+test\s*:\s*(.+)\s*$")

    # English markers to flag leftover text:
    markers = [
        _rx(r"\bcalculate\b"),
        _rx(r"\bwork\s+out\b"),
        _rx(r"\bsimplify\b"),
        _rx(r"\bsolve\b"),
        _rx(r"\bfind\b"),
        _rx(r"\bprobability\b"),
        _rx(r"\bdifferentiate\b"),
        _rx(r"\bintegrate\b"),
        _rx(r"\bdegrees\b"),
        _rx(r"\bradians\b"),
        _rx(r"\bperimeter\b"),
        _rx(r"\barea\b"),
        _rx(r"\bvolume\b"),
    ]

    de = LocaleRules(
        locale="de-CH",
        subs=[
            (calc_expr, r"Berechne: \1"),
            (work_out, r"Berechne: \1"),
            (simplify, r"Vereinfache: \1"),
            (solve_for, r"Löse nach \1 auf: \2"),
            (solve, r"Löse: \1"),
            (find_frac_of, r"Bestimme \1 von \2."),
            (find_percent_of, r"Bestimme \1% von \2."),
            (what_is, r"Was ist \1?"),
            (convert_to, r"Wandle \1 in \2 um."),
            (perimeter, r"Bestimme den Umfang von \1."),
            (area, r"Bestimme den Flächeninhalt von \1."),
            (volume, r"Bestimme das Volumen von \1."),
            (differentiate, r"Leite ab: \1"),
            (integrate, r"Integriere: \1"),
            (find_derivative, r"Bestimme dy/dx für \1"),
            (evaluate_at, r"Berechne \1 für \2 = \3"),
            (radians, r"Wandle \1° in Bogenmaß um."),
            (degrees, r"Wandle \1 Radiant in Grad um."),
            (prove_identity, r"Beweise die Identität: \1"),
            (solve_trig, r"Löse die trigonometrische Gleichung: \1"),
            (prob_find, r"Bestimme die Wahrscheinlichkeit, dass \1."),
            (binomial, r"Binomialverteilung: \1"),
            (normal, r"Normalverteilung: \1"),
            (hypothesis, r"Hypothesentest: \1"),
        ],
        english_markers=markers,
    )

    fr = LocaleRules(
        locale="fr-CH",
        subs=[
            (calc_expr, r"Calcule : \1"),
            (work_out, r"Calcule : \1"),
            (simplify, r"Simplifie : \1"),
            (solve_for, r"Résous pour \1 : \2"),
            (solve, r"Résous : \1"),
            (find_frac_of, r"Calcule \1 de \2."),
            (find_percent_of, r"Calcule \1 % de \2."),
            (what_is, r"Combien vaut \1 ?"),
            (convert_to, r"Convertis \1 en \2."),
            (perimeter, r"Calcule le périmètre de \1."),
            (area, r"Calcule l’aire de \1."),
            (volume, r"Calcule le volume de \1."),
            (differentiate, r"Dérive : \1"),
            (integrate, r"Intègre : \1"),
            (find_derivative, r"Trouve dy/dx pour \1"),
            (evaluate_at, r"Évalue \1 pour \2 = \3"),
            (radians, r"Convertis \1° en radians."),
            (degrees, r"Convertis \1 radians en degrés."),
            (prove_identity, r"Démontre l’identité : \1"),
            (solve_trig, r"Résous l’équation trigonométrique : \1"),
            (prob_find, r"Calcule la probabilité que \1."),
            (binomial, r"Loi binomiale : \1"),
            (normal, r"Loi normale : \1"),
            (hypothesis, r"Test d’hypothèse : \1"),
        ],
        english_markers=markers,
    )

    it = LocaleRules(
        locale="it-CH",
        subs=[
            (calc_expr, r"Calcola: \1"),
            (work_out, r"Calcola: \1"),
            (simplify, r"Semplifica: \1"),
            (solve_for, r"Risolvi per \1: \2"),
            (solve, r"Risolvi: \1"),
            (find_frac_of, r"Trova \1 di \2."),
            (find_percent_of, r"Trova \1% di \2."),
            (what_is, r"Quanto fa \1?"),
            (convert_to, r"Converti \1 in \2."),
            (perimeter, r"Trova il perimetro di \1."),
            (area, r"Trova l’area di \1."),
            (volume, r"Trova il volume di \1."),
            (differentiate, r"Deriva: \1"),
            (integrate, r"Integra: \1"),
            (find_derivative, r"Trova dy/dx per \1"),
            (evaluate_at, r"Valuta \1 per \2 = \3"),
            (radians, r"Converti \1° in radianti."),
            (degrees, r"Converti \1 radianti in gradi."),
            (prove_identity, r"Dimostra l’identità: \1"),
            (solve_trig, r"Risolvi l’equazione trigonometrica: \1"),
            (prob_find, r"Trova la probabilità che \1."),
            (binomial, r"Distribuzione binomiale: \1"),
            (normal, r"Distribuzione normale: \1"),
            (hypothesis, r"Test d’ipotesi: \1"),
        ],
        english_markers=markers,
    )

    return {r.locale: r for r in [de, fr, it]}


# ----------------------------
# Translation engine
# ----------------------------

def translate_text(s: str, rules: LocaleRules) -> Tuple[str, bool]:
    if not s or not isinstance(s, str):
        return s, False

    original = s
    out = s

    # Apply ordered substitutions (first match wins style)
    for pat, repl in rules.subs:
        if isinstance(pat, re.Pattern):
            if pat.search(out):
                out = pat.sub(repl, out, count=1)
                break
        else:
            # shouldn't happen; kept for safety
            out = out.replace(str(pat), str(repl))

    changed = (out != original)
    return out, changed


def maybe_translate_options(opts: Any, rules: LocaleRules) -> Tuple[Any, bool]:
    # Options may be list[str] or list[dict] or dict; handle the most common cases.
    changed_any = False

    if isinstance(opts, list):
        new_list = []
        for item in opts:
            if isinstance(item, str):
                t, ch = translate_text(item, rules)
                new_list.append(t)
                changed_any |= ch
            elif isinstance(item, dict):
                new_item = dict(item)
                # common key names for option label text
                for k in ["text", "label", "value"]:
                    if k in new_item and isinstance(new_item[k], str):
                        t, ch = translate_text(new_item[k], rules)
                        new_item[k] = t
                        changed_any |= ch
                new_list.append(new_item)
            else:
                new_list.append(item)
        return new_list, changed_any

    if isinstance(opts, dict):
        new_dict = dict(opts)
        for k, v in list(new_dict.items()):
            if isinstance(v, str):
                t, ch = translate_text(v, rules)
                new_dict[k] = t
                changed_any |= ch
        return new_dict, changed_any

    return opts, False


def contains_english_markers(s: str, rules: LocaleRules) -> bool:
    if not s or not isinstance(s, str):
        return False
    return any(m.search(s) for m in rules.english_markers)


def process_pack(src_path: Path, out_path: Path, rules: LocaleRules) -> Dict[str, Any]:
    out_path.parent.mkdir(parents=True, exist_ok=True)

    total = 0
    changed = 0
    flagged = 0
    flagged_examples: List[Dict[str, Any]] = []

    with src_path.open("r", encoding="utf-8") as fin, out_path.open("w", encoding="utf-8") as fout:
        for line_no, line in enumerate(fin, start=1):
            raw = line.strip("\n")
            if not raw.strip():
                continue

            try:
                obj = json.loads(raw)
            except Exception as e:
                raise RuntimeError(f"{src_path.name}:{line_no} invalid JSON: {e}")

            total += 1
            obj2 = dict(obj)

            any_change = False

            # translate main text keys
            for k in HUMAN_TEXT_KEYS:
                if k in obj2 and isinstance(obj2[k], str) and obj2[k].strip():
                    t, ch = translate_text(obj2[k], rules)
                    obj2[k] = t
                    any_change |= ch

            # translate options if they are text
            for ok in OPTION_KEYS:
                if ok in obj2:
                    new_opts, ch = maybe_translate_options(obj2[ok], rules)
                    obj2[ok] = new_opts
                    any_change |= ch

            if any_change:
                changed += 1

            # flag if English markers still appear in visible fields
            # (useful for later clean-up / manual review)
            visible_texts = []
            for k in HUMAN_TEXT_KEYS:
                v = obj2.get(k)
                if isinstance(v, str) and v.strip():
                    visible_texts.append(v)

            if any(contains_english_markers(v, rules) for v in visible_texts):
                flagged += 1
                if len(flagged_examples) < 25:
                    flagged_examples.append({
                        "line": line_no,
                        "id": obj2.get("id"),
                        "stage": obj2.get("stage"),
                        "sample": visible_texts[0] if visible_texts else "",
                    })

            fout.write(json.dumps(obj2, ensure_ascii=False) + "\n")

    return {
        "src": str(src_path),
        "out": str(out_path),
        "locale": rules.locale,
        "total": total,
        "changed": changed,
        "flagged": flagged,
        "flagged_examples": flagged_examples,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src_dir", required=True)
    ap.add_argument("--out_dir", required=True)
    ap.add_argument("--locales", nargs="+", required=True)
    ap.add_argument("--packs", nargs="+", required=True)
    args = ap.parse_args()

    rules_map = build_rules()

    src_dir = Path(args.src_dir)
    out_dir = Path(args.out_dir)

    missing = [p for p in args.packs if not (src_dir / p).exists()]
    if missing:
        raise SystemExit(f"Missing pack files in {src_dir}: {missing}")

    for loc in args.locales:
        if loc not in rules_map:
            raise SystemExit(f"Unsupported locale {loc}. Supported: {list(rules_map.keys())}")

    reports: List[Dict[str, Any]] = []

    for loc in args.locales:
        rules = rules_map[loc]
        for pack in args.packs:
            src_path = src_dir / pack
            out_path = out_dir / loc / pack  # keep same filename
            rep = process_pack(src_path, out_path, rules)
            reports.append(rep)
            print(f"[OK] {loc} {pack}: total={rep['total']} changed={rep['changed']} flagged={rep['flagged']}")

    # write summary report
    report_path = out_dir / "translation_report_ch.json"
    report_path.write_text(json.dumps(reports, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"[DONE] wrote report: {report_path}")

    # show a small sample of flagged examples
    for rep in reports:
        if rep["flagged_examples"]:
            print(f"\n[FLAGGED SAMPLE] {rep['locale']} {Path(rep['src']).name}")
            for ex in rep["flagged_examples"][:5]:
                print(f"  line={ex['line']} id={ex['id']} sample={ex['sample'][:90]}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())