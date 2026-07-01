#!/usr/bin/env python3
"""Audit Swiss Home, Exam Packs, and Daily Brain Teaser localization."""

from __future__ import annotations

import csv
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
L10N_DIR = ROOT / "lib" / "l10n"
REPORT = ROOT / "reports" / "ui_english_leaks.csv"
LOCALES = ("fr_CH", "de_CH", "it_CH")
SURFACES = {
    "Home": ROOT / "lib/screens/home/home_shell.dart",
    "Exam Packs": ROOT / "lib/screens/packs/exam_packs_screen.dart",
    "Daily Brain Teaser": (
        ROOT / "lib/screens/mental_math/daily_teaser_detail_screen.dart"
    ),
}
LOCALE_ASSETS = {
    "fr_CH": ROOT / "assets/config/daily_brain_teasers.fr-CH.json",
    "de_CH": ROOT / "assets/config/daily_brain_teasers.de-CH.json",
    "it_CH": ROOT / "assets/config/daily_brain_teasers.it-CH.json",
}
SHARED_TERMS = {
    "homeBadgeTenQuestions",
    "homeContinueKs2Topic",
    "homeContinueKs3Topic",
    "homeLearningFractionsTitle",
    "navTutor",
    "topicsPremiumLabel",
    "topicsTrackGcseFoundation",
    "topicsTrackGcseHigher",
}
ENGLISH_TOKENS = re.compile(
    r"\b(?:Daily Mission|Brain Teaser|Ready to power up|Good evening|"
    r"Good morning|Coming Soon|Exam Packs|Choose a pack|Included|Top-up|"
    r"Solve|Fuel|Practice|Topics|Multiply|Find|Calculate|Rewards On|"
    r"Rewards Off|First Session|Algebra Starter|Equivalent fractions|"
    r"Solving equations|Quadratics|Differentiation)\b",
    re.IGNORECASE,
)
L10N_KEY = re.compile(
    r"\bl10n\.([A-Za-z][A-Za-z0-9_]*)|"
    r"AppLocalizations\.of\(context\)\.([A-Za-z][A-Za-z0-9_]*)"
)
STRING_PATTERN = re.compile(r"""(['"])(.*?)(?<!\\)\1""")
COPY_KEYS = ("quietStudyModeLabel", "quietStudyModeTooltip")


def _load_arb(locale: str) -> dict[str, object]:
    return json.loads(
        (L10N_DIR / f"app_{locale}.arb").read_text(encoding="utf-8-sig")
    )


def _surface_keys(path: Path) -> set[str]:
    keys = set()
    for match in L10N_KEY.finditer(path.read_text(encoding="utf-8")):
        keys.add(match.group(1) or match.group(2))
    return keys


def _hardcoded_english(path: Path) -> list[tuple[int, str]]:
    leaks = []
    for line_number, line in enumerate(
        path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        stripped = line.strip()
        if stripped.startswith(("//", "import ", "export ")):
            continue
        for match in STRING_PATTERN.finditer(line):
            value = match.group(2)
            if value.startswith(("/", "assets/", "package:")):
                continue
            if ENGLISH_TOKENS.search(value):
                leaks.append((line_number, value))
    return leaks


def _asset_english(path: Path) -> list[str]:
    values: list[str] = []

    def visit(value: object) -> None:
        if isinstance(value, str) and ENGLISH_TOKENS.search(value):
            values.append(value)
        elif isinstance(value, list):
            for item in value:
                visit(item)
        elif isinstance(value, dict):
            for key, item in value.items():
                if key not in {"id", "difficulty", "tags"}:
                    visit(item)

    visit(json.loads(path.read_text(encoding="utf-8-sig")))
    return values


def main() -> int:
    english = _load_arb("en")
    source_keys = {
        key
        for values in json.loads(
            (ROOT / "untranslated_messages.txt").read_text(encoding="utf-8")
        ).values()
        for key in values
    }
    source_keys.update(COPY_KEYS)
    leaks: list[dict[str, object]] = []
    counts = {
        locale: {surface: 0 for surface in SURFACES} for locale in LOCALES
    }

    locale_arbs = {locale: _load_arb(locale) for locale in LOCALES}
    for locale, arb in locale_arbs.items():
        missing_source = sorted(source_keys - set(arb))
        for key in missing_source:
            leaks.append(
                {
                    "locale": locale.replace("_", "-"),
                    "surface": "ARB coverage",
                    "key": key,
                    "issue": "missing source-of-truth key",
                    "value": "",
                }
            )

    missing_english = sorted(source_keys - set(english))
    for key in missing_english:
        leaks.append(
            {
                "locale": "en",
                "surface": "ARB coverage",
                "key": key,
                "issue": "missing fallback key",
                "value": "",
            }
        )

    for surface, path in SURFACES.items():
        keys = _surface_keys(path)
        hardcoded = _hardcoded_english(path)
        for locale, arb in locale_arbs.items():
            for key in sorted(keys):
                value = arb.get(key)
                if value is None:
                    issue = "missing localized key"
                elif value == english.get(key) and key not in SHARED_TERMS:
                    issue = "matches English fallback"
                else:
                    continue
                counts[locale][surface] += 1
                leaks.append(
                    {
                        "locale": locale.replace("_", "-"),
                        "surface": surface,
                        "key": key,
                        "issue": issue,
                        "value": value or "",
                    }
                )
            for line_number, value in hardcoded:
                counts[locale][surface] += 1
                leaks.append(
                    {
                        "locale": locale.replace("_", "-"),
                        "surface": surface,
                        "key": f"{path.name}:{line_number}",
                        "issue": "hard-coded English UI text",
                        "value": value,
                    }
                )

    for locale, path in LOCALE_ASSETS.items():
        for value in _asset_english(path):
            counts[locale]["Daily Brain Teaser"] += 1
            leaks.append(
                {
                    "locale": locale.replace("_", "-"),
                    "surface": "Daily Brain Teaser",
                    "key": path.name,
                    "issue": "English text in localized teaser asset",
                    "value": value,
                }
            )

    REPORT.parent.mkdir(parents=True, exist_ok=True)
    with REPORT.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle, fieldnames=("locale", "surface", "key", "issue", "value")
        )
        writer.writeheader()
        writer.writerows(leaks)

    print("Keys added/updated:")
    for key in COPY_KEYS:
        print(f"  {key}: en/en-GB/fr-CH/de-CH/it-CH")
    print("  navHome: it-CH")
    print("Leak count by locale and surface:")
    for locale in LOCALES:
        values = ", ".join(
            f"{surface}={counts[locale][surface]}" for surface in SURFACES
        )
        print(f"  {locale.replace('_', '-')}: {values}")
    print(f"Total leaks: {len(leaks)}")
    print(f"Report: {REPORT.relative_to(ROOT).as_posix()}")
    return 1 if leaks else 0


if __name__ == "__main__":
    raise SystemExit(main())
