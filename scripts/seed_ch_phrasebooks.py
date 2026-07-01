#!/usr/bin/env python3
"""Create starter CH template phrasebooks without overwriting reviewer edits."""

from pathlib import Path

from autofill_ch_translation_csv import LOCALES, write_seed_phrasebook


for locale in LOCALES:
    path = Path("reports") / f"phrasebook_{locale}.csv"
    print(f"{'Wrote' if write_seed_phrasebook(path, locale) else 'Kept'} {path}")
