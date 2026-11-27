# AS-1 Swiss Localisation Acceptance

- **Branch:** `fix/as1-swiss-localisation`, from `7efd8da` (the PR #7 merge on `feature/math-intelligence-v2`).
- **Scope:** AS-1 only. The accessibility settings, the onboarding accessibility step and the 19 Early Maths lane strings are localised for the production locales en, en_GB, de_CH, fr_CH and it_CH. All work was on the host: no Pixel, adb, APK or TalkBack.
- **Status:** implemented and verified on the host, and committed as an engineering checkpoint (not production-copy approval). The Swiss texts are **drafts, PENDING LINGUISTIC REVIEW**. No native speaker has approved them, and they are not production-approved copy.

## 1. What changed

Before, the Accessibility screen and the onboarding accessibility step were hard-coded in English: 14 distinct strings, which TalkBack spoke in English in every locale. The 19 Early Maths lane keys existed only in the English template, so every Swiss user saw English. Three Appearance keys had the English text copied verbatim into the Swiss files.

| File | Change |
|---|---|
| `lib/screens/settings/accessibility_screen.dart` | 13 literals replaced with localisation keys. The Reading Size options get stable ids (`small`, `default`, `large`) for their widget keys. |
| `lib/screens/onboarding/accessibility_step_screen.dart` | 8 literals (including `~15 seconds`) replaced with keys. Stable Reading Size ids, as in settings. |
| `lib/l10n/app_en.arb` | 11 new keys, with the existing English wording unchanged and translator descriptions |
| `lib/l10n/app_en_GB.arb` | the 11 new keys and the 19 lane keys, with the same British English wording |
| `lib/l10n/app_de_CH.arb`, `app_fr_CH.arb`, `app_it_CH.arb` | 30 new draft translations, plus 3 Appearance values that were English, corrected. All 33 are marked as drafts. |
| `lib/l10n/app_localizations*.dart`, `untranslated_messages.txt` | regenerated with `flutter gen-l10n`, not hand-edited |
| `test/reading_size_semantics_test.dart`, `test/reading_size_text_scaler_test.dart` | use the stable keys. The spoken English labels they check are unchanged. |
| `test/math_studio_l10n_completeness_test.dart` | prefix `earlyMathsPlayground` widened to `earlyMaths`, plus `accessibility` |
| `test/as1_swiss_localisation_test.dart` (new, 41 tests) | ARB completeness, placeholders, draft marker, curriculum terminology, generated getters, source guard, lane mapping |
| `test/as1_swiss_localisation_widget_test.dart` (new, 12 tests) | the three screens in en, de_CH, fr_CH and it_CH: localised names and semantics, stable keys, screen-reader selection |

**Unchanged:**
- **Behaviour and data:** preferences (`text_scale` 0.9 / 1.0 / 1.15, `reduce_motion`, `quiet_study_mode`, `sound_enabled`), layout and widget structure, lane persistence values, the lane-to-activity mapping, the curriculum manifest, question packs, maths content and learner progress.
- **Locales:** production stays at en, en_GB, de_CH, fr_CH and it_CH. No UAT-only language was enabled.
- **Out of scope:** regional routing. No Firebase, RevenueCat, OpenAI, TutorBot or subscription change.

## 2. Keys

**New shared keys (11).** The template English is the previous literal.

| Key | English |
|---|---|
| `accessibilitySettingsSubtitle` | Adjust for comfort and readability |
| `accessibilityReadingSizeSubtitle` | Choose a comfortable reading size |
| `accessibilityReadingSizeSmall` | Small |
| `accessibilityReadingSizeDefault` | Default |
| `accessibilityReadingSizeLarge` | Large |
| `accessibilityReduceMotionTitle` | Reduce Motion |
| `accessibilityReduceMotionSubtitle` | Minimise animations and transitions |
| `accessibilityQuietStudyModeSubtitle` | Inspired by Nyepi, a Balinese tradition of reflection, stillness and focus — reduces Captain Math and sound cues |
| `accessibilitySoundCuesTitle` | Sound Cues |
| `accessibilitySoundCuesSubtitle` | Short, optional sounds for Interactive Labs actions |
| `onboardingTimeEstimateSeconds` | ~{seconds} seconds (`int` placeholder) |

**Reused existing keys (3):**
- `profileAccessibility` ("Accessibility") and `quietStudyModeLabel` ("Quiet Study Mode") already had Swiss translations.
- `appearanceReadingSizeTitle` ("Reading Size") was English in all three Swiss files and is corrected here.

**Corrected Appearance keys (3):** `appearanceAccessibilityHeading`, `appearanceReadingSizeTitle` and `appearanceReadingSizeSub`. The new Reading Size option names are used in `appearanceReadingSizeSub`, so both screens use the same words.

**Lane keys (19):** every `earlyMaths*` key outside `earlyMathsPlayground*`. One has a placeholder: `earlyMathsParentTitlesLine` (`{titles}`).

## 3. Coverage by locale

| Locale | AS-1 strings | Status |
|---|---|---|
| en | 33 of 33 (template) | source English, unchanged wording |
| en_GB | 33 of 33 | British English: the 30 new and lane keys are explicit; the 3 Appearance keys and the reused keys inherit the template (which is already British) |
| de_CH | 33 of 33 | **draft, PENDING LINGUISTIC REVIEW** |
| fr_CH | 33 of 33 | **draft, PENDING LINGUISTIC REVIEW** |
| it_CH | 33 of 33 | **draft, PENDING LINGUISTIC REVIEW** |
| 11 UAT-only locales | not translated | Deferred. They remain UAT-only and fall back to English, as before. Each already misses 1,300–1,500 keys. |

- **The draft marker:** each of the 99 Swiss strings (33 × 3) has an `@key` description starting "AS-1 draft translation. PENDING LINGUISTIC REVIEW: not yet approved by a native speaker; not production-approved copy." A test fails if any of them loses the marker, so they can't silently become production copy. Removing a marker is **not** evidence of approval (see §7.1).
- **Placeholders and metadata:** the Swiss files keep `{titles}` and `{seconds}`, plus their `placeholders` metadata, exactly as in the template.
- **What screen readers say:** after this change the Swiss locales show and speak only translated text on the three audited screens. The persona name Captain Math and the term Nyepi stay as written, by decision.

## 4. Draft versus approved

| Item | Status |
|---|---|
| Swiss translations (99 strings) | Drafts written in this sprint for review. Not native-speaker approved. Not production-approved. |
| Reused `profileAccessibility` and `quietStudyModeLabel` | existing translations, unchanged and not re-reviewed here |
| English template and en_GB | unchanged wording, no review needed |

**Draft conventions** (for the reviewer to confirm or correct):
- **Register:** informal du / tu, matching the existing Swiss Family Maths copy ("dein Kind", "ton enfant", "tuo figlio").
- **Diacritics:** full diacritics. Swiss German uses "ss" for "ß" (Textgrösse, Gross).
- **French punctuation:** a space before ":", following the existing fr_CH file (see §8).
- **Terminology:** Abakus / Boulier / Abaco follow the existing Visual Maths translations. "Interaktive Labore" / "laboratoires interactifs" / "laboratori interattivi" and "Eltern-PIN" / "code PIN parental" / "PIN genitore" follow existing keys.

## 5. Curriculum terminology decisions

These follow the authorised product decisions. No Swiss school-year equivalence was invented, and no age band was changed.

| Lane string | English | Swiss treatment | Why |
|---|---|---|---|
| `earlyMathsLanePlayTitle` | Early Maths Play | A generic section title: "Mathe spielerisch entdecken" / "Découvrir les maths en jouant" / "Scoprire la matematica giocando" | Decision 3: a generic educational section title, not a brand term |
| `earlyMathsLanePlayAges` | Typical ages 4–5 · Reception | The age band only: "Typisches Alter: 4–5 Jahre" / "Âge habituel : 4–5 ans" / "Età tipica: 4–5 anni". "Reception" is dropped. | Decision 5: the play section is curriculum-neutral in Swiss views. The age band is unchanged (decision 7). |
| `earlyMathsLaneKs1Title` | KS1 Maths Foundations | Keeps "KS1" and names England: "Mathe-Grundlagen KS1 (Lehrplan England)" / "… (programme d'Angleterre)" / "… (programma dell'Inghilterra)" | Decisions 4 and 6: the lane is an England-curriculum pathway. It must not read as a Swiss stage or qualification. |
| `earlyMathsLaneKs1Ages` | Typical ages 5–7 · Years 1–2 | The age band, then the England label kept as "Year 1–2 (England / Angleterre / Inghilterra)" | Decisions 6 and 7: the England school years stay as UK labels. No "1.–2. Klasse", Kindergarten or HarmoS equivalence. |

**Enforced by tests in every Swiss locale:**
- the KS1 title and ages name England, and keep "KS1" and "Year 1–2";
- the play ages contain no "Reception";
- no lane string contains a Swiss stage term (Kindergarten, Primar, Klasse, HarmoS, Zyklus, enfantine, primaire, classe, cycle, infanzia, elementare, ciclo);
- every number in every AS-1 string is the same, in the same order, as in English: age bands, "1 to 3 apples from 5", "KS1".

**Not changed:** the lane's curriculum mapping, the persisted lane values and the activities it shows. These are covered by a test too.

## 6. Automated verification

| Check | Result |
|---|---|
| `flutter analyze` | No issues found |
| ARB validation | all 5 edited ARBs parse as JSON with no duplicate keys. `flutter gen-l10n` completes, and running it again produces no further change. |
| `git diff --check` | clean |
| `dart format` | the edited source and test files are formatted |
| `test/as1_swiss_localisation_test.dart` | 41 passed, 0 failed |
| `test/as1_swiss_localisation_widget_test.dart` | 12 passed, 0 failed (3 screens × en, de_CH, fr_CH, it_CH) |
| `test/math_studio_l10n_completeness_test.dart` (widened) | 8 passed, 0 failed |
| Full host suite (260 test files in 6 batches of 50; `practice_screen_continue_learning_resume_test.dart` excluded as in every gate, because of its known pre-existing hang) | **3,291 passed, 0 failed, 0 skipped** (Closure A: 3,238, plus 53 new). The Fractions of a Set distinction guard passed; no protected lab file was touched. |

**What the new tests cover:**
1. All 19 lane keys, in every production locale.
2. The accessibility settings strings.
3. The onboarding accessibility strings.
4. The 3 Appearance accessibility keys.
5. No hard-coded user-facing literals in the two audited widgets (an exact allowlist built from the Dart string literals), and no hard-coded prose in the hub.
6. The same Reading Size keys (`readingSizeOption-small` and so on) in every locale.
7. Placeholder substitution, in both the ARBs and the generated code.
8. Localised names, button roles, single-choice selection and switch state, including selecting through the screen reader in each Swiss locale.
9. Unchanged lane values and lane-to-activity mapping.

**Negative controls.** Each was run with part of the change reverted, then restored; the restored diff hash was byte-identical both times.

| Reverted | Result |
|---|---|
| Swiss ARBs only (the code and template kept) | 39 of 61 tests fail, all Swiss-specific: completeness, fallback, draft marker, terminology, numbers, the Swiss widget tests, and the widened completeness test. The English tests still pass. |
| The two screens only (back to hard-coded English) | both source guards fail, and every Settings and onboarding widget test fails (8, in all 4 locales; English too, because the stable keys are gone) |

## 7. Outstanding linguistic review

1. **Linguistic review:** a native or professional reviewer must review all 99 Swiss drafts (§9) for de-CH, fr-CH and it-CH: meaning, register, Swiss conventions and how they read aloud. Approval needs an approval record (§7.1), not just marker removal.
2. **French punctuation:** confirm the convention for fr-CH, space or no space before ":", "?" and "!" (see §8).
3. **Matching the Android setting name:** confirm "Bewegung reduzieren" / "Réduire les animations" / "Riduci movimento" against the wording Android uses in each language, so users recognise it.
4. **Device check:** a TalkBack listen on the Pixel 6a in each Swiss locale, which needs authorisation. The host tests check the semantics tree, not the speech engine's pronunciation.

### 7.1 Approval controls and their limits

- **What the tests enforce:** `test/as1_swiss_localisation_test.dart` requires the draft marker on all 33 AS-1 strings in each Swiss locale. Removing a marker therefore makes that test fail; the tests never treat a missing marker as approval.
- **What they cannot do:** the tests cannot tell an approved string from one whose marker was simply deleted. A test can only be changed to accept approved strings, and that change is not itself evidence of linguistic approval. There is no review-management system, and this sprint does not add one.
- **What final approval requires.** A string counts as approved only when a written approval record exists with:
  1. the locale (de_CH, fr_CH or it_CH);
  2. the reviewer's identity or an approved reviewer reference;
  3. the review date;
  4. the approved ARB version: a commit SHA or the file's SHA-256;
  5. the explicit review outcome for each string or block: approved, approved with changes (with the final text), or rejected.
- **Order of steps:** the record comes first; then the marker is removed from exactly the approved strings and the marker test is updated in the same change, citing the record.
- **Current state:** no approval record exists for any AS-1 string, and none is implied by this document.

## 8. Other localisation deficiencies outside AS-1

These were not changed here. Each needs its own ticket.

- **Panda Portions:** all 59 keys are English-only in the Swiss locales, including its card on the Early Maths hub. This is the most visible remaining gap on the hub.
- **Appearance screen:** 12 theme and other keys are English verbatim in the Swiss files.
- **Onboarding:** 33–35 keys are English copies, and 8 are missing, in each Swiss locale. The 7 other onboarding steps still pass hard-coded English time estimates; the new `onboardingTimeEstimateSeconds` key can replace them.
- **Accent-free Swiss text:** the existing Early Maths and lab translations have no diacritics ("Fruehe Mathe-Spielwiese", "Zaehlen", "affame", "piu"). Screen readers mispronounce these.
- **French punctuation:** fr_CH places a space before "?", "!" and ":", France-style. The Swiss convention should be decided once, for the whole file.
- **What remains untranslated:** about 272 keys per Swiss locale, according to `untranslated_messages.txt`.
- **UAT-only locales:** 1,300–1,500 missing keys each. The base `de`, `fr` and `it` files aren't selectable and inherit English.
- **Cleanup:** `lib/l10n_disabled/` (old ko/ar files) and the unreachable `MarketPickerScreen`.

## 9. Swiss draft translations for review

All entries below are **PENDING LINGUISTIC REVIEW**. They are generated from the ARB files, so they match what the app shows.

### Accessibility settings and onboarding (11 new keys)

| Key | English | de_CH | fr_CH | it_CH |
|---|---|---|---|---|
| `accessibilitySettingsSubtitle` | Adjust for comfort and readability | Für mehr Komfort und Lesbarkeit anpassen | Ajuster pour plus de confort et de lisibilité | Regola per maggiore comfort e leggibilità |
| `accessibilityReadingSizeSubtitle` | Choose a comfortable reading size | Angenehme Textgrösse wählen | Choisir une taille de texte confortable | Scegli una dimensione del testo comoda |
| `accessibilityReadingSizeSmall` | Small | Klein | Petit | Piccolo |
| `accessibilityReadingSizeDefault` | Default | Standard | Par défaut | Predefinito |
| `accessibilityReadingSizeLarge` | Large | Gross | Grand | Grande |
| `accessibilityReduceMotionTitle` | Reduce Motion | Bewegung reduzieren | Réduire les animations | Riduci movimento |
| `accessibilityReduceMotionSubtitle` | Minimise animations and transitions | Animationen und Übergänge minimieren | Limiter au minimum les animations et les transitions | Riduci al minimo animazioni e transizioni |
| `accessibilityQuietStudyModeSubtitle` | Inspired by Nyepi, a Balinese tradition of reflection, stillness and focus — reduces Captain Math and sound cues | Inspiriert von Nyepi, einer balinesischen Tradition der Reflexion, Stille und Konzentration – reduziert Captain Math und Tonhinweise | Inspiré de Nyepi, une tradition balinaise de réflexion, de calme et de concentration — réduit Captain Math et les signaux sonores | Ispirata a Nyepi, una tradizione balinese di riflessione, quiete e concentrazione — riduce Captain Math e i segnali sonori |
| `accessibilitySoundCuesTitle` | Sound Cues | Tonhinweise | Signaux sonores | Segnali sonori |
| `accessibilitySoundCuesSubtitle` | Short, optional sounds for Interactive Labs actions | Kurze, optionale Töne für Aktionen in den interaktiven Laboren | Sons courts et facultatifs pour les actions des laboratoires interactifs | Suoni brevi e facoltativi per le azioni nei laboratori interattivi |
| `onboardingTimeEstimateSeconds` | ~{seconds} seconds | ~{seconds} Sekunden | ~{seconds} secondes | ~{seconds} secondi |

### Appearance accessibility keys (3 corrected)

| Key | English | de_CH | fr_CH | it_CH |
|---|---|---|---|---|
| `appearanceAccessibilityHeading` | ACCESSIBILITY | BARRIEREFREIHEIT | ACCESSIBILITÉ | ACCESSIBILITÀ |
| `appearanceReadingSizeTitle` | Reading Size | Textgrösse | Taille du texte | Dimensione del testo |
| `appearanceReadingSizeSub` | Small, Default, or Large text scaling | Textgrösse Klein, Standard oder Gross | Taille du texte Petit, Par défaut ou Grand | Dimensione del testo Piccolo, Predefinito o Grande |

### Early Maths lane strings (19)

| Key | English | de_CH | fr_CH | it_CH |
|---|---|---|---|---|
| `earlyMathsAbacusScope` | An interactive place-value tool: tap or drag beads to explore hundreds, tens and ones. | Ein interaktives Stellenwert-Werkzeug: Tippe auf die Perlen oder ziehe sie, um Hunderter, Zehner und Einer zu erkunden. | Un outil interactif sur la valeur positionnelle : touche ou fais glisser les perles pour explorer les centaines, les dizaines et les unités. | Uno strumento interattivo sul valore posizionale: tocca o trascina le perline per esplorare centinaia, decine e unità. |
| `earlyMathsAbacusTitle` | Abacus | Abakus | Boulier | Abaco |
| `earlyMathsActivitiesHeading` | Activities to try | Aktivitäten zum Ausprobieren | Activités à essayer | Attività da provare |
| `earlyMathsEntryIntro` | Pick a friendly place to start. Age is only a suggestion, not a level. There is no test, and you can switch at any time. | Wähle einen angenehmen Einstieg. Das Alter ist nur ein Vorschlag, keine Stufe. Es gibt keinen Test, und du kannst jederzeit wechseln. | Choisis un point de départ agréable. L'âge n'est qu'une suggestion, pas un niveau. Il n'y a pas de test, et tu peux changer à tout moment. | Scegli un punto di partenza adatto. L'età è solo un suggerimento, non un livello. Non c'è nessun test e puoi cambiare in qualsiasi momento. |
| `earlyMathsLaneChooserLabel` | Choose a starting point | Einstieg wählen | Choisis un point de départ | Scegli un punto di partenza |
| `earlyMathsLaneKs1Ages` | Typical ages 5–7 · Years 1–2 | Typisches Alter: 5–7 Jahre · Year 1–2 (England) | Âge habituel : 5–7 ans · Year 1–2 (Angleterre) | Età tipica: 5–7 anni · Year 1–2 (Inghilterra) |
| `earlyMathsLaneKs1Title` | KS1 Maths Foundations | Mathe-Grundlagen KS1 (Lehrplan England) | Bases des maths KS1 (programme d'Angleterre) | Basi di matematica KS1 (programma dell'Inghilterra) |
| `earlyMathsLaneNotSureSubtitle` | No test needed. We'll suggest one gentle first step. | Kein Test nötig. Wir schlagen einen sanften ersten Schritt vor. | Aucun test nécessaire. Nous te proposerons une première étape en douceur. | Nessun test necessario. Ti suggeriremo un primo passo tranquillo. |
| `earlyMathsLaneNotSureTitle` | I'm not sure | Ich bin nicht sicher | Je ne sais pas encore | Non lo so ancora |
| `earlyMathsLanePlayAges` | Typical ages 4–5 · Reception | Typisches Alter: 4–5 Jahre | Âge habituel : 4–5 ans | Età tipica: 4–5 anni |
| `earlyMathsLanePlayTitle` | Early Maths Play | Mathe spielerisch entdecken | Découvrir les maths en jouant | Scoprire la matematica giocando |
| `earlyMathsLaneSwitchNote` | Switching never removes anything your child has already done. | Beim Wechseln geht nichts verloren, was dein Kind schon gemacht hat. | Changer n'efface jamais ce que ton enfant a déjà fait. | Cambiare non cancella mai ciò che tuo figlio ha già fatto. |
| `earlyMathsNotSureBody` | There is no right or wrong choice. Try this one small activity and see how it feels. You can choose a different starting point above whenever you like. | Es gibt keine richtige oder falsche Wahl. Probiere diese eine kleine Aktivität aus und schau, wie sie sich anfühlt. Oben kannst du jederzeit einen anderen Einstieg wählen. | Il n'y a pas de bon ou de mauvais choix. Essaie cette petite activité et vois comment ça se passe. Tu peux choisir un autre point de départ ci-dessus quand tu veux. | Non esiste una scelta giusta o sbagliata. Prova questa piccola attività e vedi come va. Puoi scegliere un altro punto di partenza qui sopra quando vuoi. |
| `earlyMathsNotSureHeading` | A gentle first step | Ein sanfter erster Schritt | Une première étape en douceur | Un primo passo tranquillo |
| `earlyMathsPandaScope` | Count out 1 to 3 apples from 5, then say how many are left. | Zähle 1 bis 3 Äpfel von 5 ab und sage dann, wie viele übrig bleiben. | Compte 1 à 3 pommes parmi 5, puis dis combien il en reste. | Conta da 1 a 3 mele su 5, poi di' quante ne restano. |
| `earlyMathsParentCardSubtitle` | Short activities to do together. Opens with your parent PIN. | Kurze Aktivitäten zum gemeinsamen Ausprobieren. Öffnet sich mit deiner Eltern-PIN. | De courtes activités à faire ensemble. S'ouvre avec ton code PIN parental. | Brevi attività da fare insieme. Si apre con il tuo PIN genitore. |
| `earlyMathsParentCardTitle` | Parent-led activities | Aktivitäten mit Eltern | Activités guidées par un parent | Attività guidate dai genitori |
| `earlyMathsParentHeading` | For grown-ups | Für Erwachsene | Pour les adultes | Per gli adulti |
| `earlyMathsParentTitlesLine` | Includes: {titles} | Enthält: {titles} | Comprend : {titles} | Include: {titles} |

## 10. Recommendation

- **Host implementation: GO.** All 33 AS-1 strings are localised in every production locale. The screens use localisation keys with stable ids, behaviour and data are unchanged, analyze is clean, and the full host suite is green (§6).
- **Production copy: NO-GO** until an approval record (§7.1) exists for each Swiss locale and the draft markers are removed for exactly the approved strings.
- **Public release: still NO-GO.** Also outstanding: Pixel TalkBack for AF-3, SW-1 and HL-1; a human traversal; D-1 on a phone; the bottom-navigation decision; L-1; and the §8 deficiencies the product owner decides to include.
