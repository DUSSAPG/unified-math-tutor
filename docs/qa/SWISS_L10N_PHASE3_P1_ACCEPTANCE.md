# Swiss localisation Phase 3: P1 learning-content acceptance report

| | |
|---|---|
| Baseline | `a2f60b0` (`feature/math-intelligence-v2`, PR #10 merge: production release gate) |
| Branch / worktree | `l10n/swiss-phase3-p1`, worktree `unified_math_tutor_swiss_l10n_phase3` |
| State | **Uncommitted. Awaiting scope and results review.** Not pushed, not merged. |
| Nature | Translation engineering. **No translation is approved by this work.** |
| Production result | **NO-GO.** 1,470 translations are pending and 0 are approved. The production build wrapper blocks before any Flutter build. |
| Device work | None (no Pixel or ADB, no APK or AAB). |

## 1. Summary

- **Source:** the P1 proposals committed in Phase 2 (`docs/l10n_review/swiss_phase2/REVIEW_<locale>.csv`, rows "P1 proposal (NOT in ARB)"). No translation was newly generated.
- **What was written:** the proposals are now in the de_CH, fr_CH and it_CH ARBs as pending drafts.
  - Each value carries `PENDING LINGUISTIC REVIEW` and is listed in `required_keys.json`.
  - All 754 earlier pending drafts keep their markers.
- **Nothing else changed:** no approval record was created, no marker was removed, and no English source, curriculum, maths engine, answer marking or app code changed.
- **Inventory matched Phase 2 exactly:**
  - the 173 missing P1 keys per locale were all still missing;
  - every correction's current value equalled its recorded previous value;
  - no English source had changed since Phase 2;
  - every other missing key was explained (the 26 P2 keys, plus the fr/it Gymnasium label).
- **One deviation from the proposals:** in `abacusPlayParentNote`, the final instruction uses informal address ("Lass dein Kind", "Demande à ton enfant", "Chiedi a tuo figlio"). Every existing parent string uses informal address; the proposal used formal address. Decision D-8 stays open.

## 2. Translation counts by locale

| | de_CH | fr_CH | it_CH |
|---|---:|---:|---:|
| Previously missing keys, now drafted | 173 | 173 | 173 |
| Existing values corrected | 90 | 79 | 28 |
| of which | 85 umlaut digraphs, 5 ß in Swiss German | 52 missing accents, 9 ambiguous accents, 3 both, 13 fr punctuation, 1 punctuation and accent, 1 English copy replaced | 27 missing accents, 1 apostrophe used as accent |
| **Phase 3 P1 values written** | **263** | **252** | **201** |
| Pending before Phase 3 (AS-1 + Phase 2 P0) | 267 | 256 | 231 |
| **Pending now (= `required_keys.json`)** | **530** | **508** | **432** |

Total pending: **1,470** (754 before Phase 3, plus 716 new).

### By learning area (Phase 3 values)

| Area | de_CH | fr_CH | it_CH |
|---|---:|---:|---:|
| Panda Portions | 50 | 50 | 50 |
| Number sense | 86 | 86 | 86 |
| Abacus and place value | 37 | 38 | 37 |
| Fractions and ratios | 16 | 9 | 2 |
| Interactive labs | 56 | 50 | 25 |
| Other learning activities | 18 | 19 | 1 |

All the added keys are Panda Portions, number sense, and abacus and place value. The corrections are in interactive labs, fractions and ratios, and other activities, plus one fr abacus key.

## 3. Panda Portions coverage

- All **59** `pandaPortions*` template keys are now present in each Swiss ARB, and all 59 are pending review. Phase 3 added 50; the other 9 were Phase 2 P0 drafts.
- `pandaPortionsTitle` stays "Panda Portions" in all three locales, kept as the English activity name. This is open decision D-6; the alternatives are recorded in the package.
- `{fraction}` is always the symbol form `n/d`, as checked in code in Phase 2. How TalkBack reads "3/4" in de, fr and it must be confirmed in context (flagged on `pandaPortionsBowlHas`).

## 4. Remaining missing keys

| | de_CH | fr_CH | it_CH |
|---|---:|---:|---:|
| Untranslated template keys (completeness check) | **26** (was 199) | **27** (was 200) | **27** (was 200) |
| of which P2, deferred and unreferenced in `lib/` | 26 | 26 | 26 |
| of which `practiceExamSwissGymnasium` (blocked, D-1) | 0 | 1 | 1 |

The 272-key requirement is unchanged and still fails while these keys are missing.

## 5. Unresolved terminology and review flags

Each item is flagged in the `translator_notes` column of `docs/l10n_review/swiss_phase3/P1_APPLIED_<locale>.csv`. None was resolved by guessing.

- **Strings built from fragments (G-9):** 24 per locale (number-sense units, direction and relation words, abacus column names). Review each with its fragments.
- **Plural agreement:** in `numberSenseComparisonExplanationSameDenominator`, "sind" / "sono" is wrong when `{largerCount}` is 1. The template declares `largerCount` as `int`, so an ICU plural in the Swiss strings is technically possible. That would be a separate engineering change and was not made.
- **Unusual counted units:** "Halbe" / "demis" (`numberSenseComparisonHalves`) appear only if a comparison with denominator 2 is generated.
- **D-3 decimal separator:** the decimal point is kept in 5 / 6 / 5 P1 keys (the number-sense hundredths keys, plus `placeValueCaption2` in fr). A decimal comma needs a separate implementation contract.
- **D-4 / D-5 (fr-CH):** non-breaking spaces before `? ! : ;` and the 1990 spellings are applied provisionally.
- **D-6:** the Panda Portions name (above).
- **D-8:** parent register. All parent copy is now informal, including the one adjusted P1 key. Formal or informal is still a reviewer decision.
- **Values identical to English, on purpose (per locale):**
  - `abacusBoardEquationOne`, `abacusBoardEquationTwo`, `abacusBoardEquationThree` and `numberSenseHundredthsTargetEquationDynamic` are pure notation;
  - `pandaPortionsTitle` is open under D-6.
- **Still open from Phase 2:** D-1 Gymnasium, D-2 legal review of `helpTermsBody`, D-7 Fluency, and D-9 English source fixes.
- **P1 flags left unchanged:** fr 3 and it 1 keys (`labsAircraftLandingVectorApproachHelpWhatToDo`, `labsFlightPathLabNarrationIntroBuilder`, `labsFlightPathLabNarrationResultNearMiss*`) were reviewed in Phase 2 as correct, and Phase 3 did not touch them.

## 6. Files

| File | Change |
|---|---|
| `lib/l10n/app_de_CH.arb`, `app_fr_CH.arb`, `app_it_CH.arb` | 263 / 252 / 201 values, each with a pending `@key` description; other `@key` fields kept |
| `lib/l10n/app_localizations_de.dart`, `_fr.dart`, `_it.dart`, `untranslated_messages.txt` | Regenerated by `flutter gen-l10n` |
| `docs/l10n_approvals/required_keys.json` | 754 → 1,470 keys; description and source updated |
| `docs/l10n_approvals/README.md`, `RELEASE_CHECKLIST.md` | Current counts (1,470 pending, 26/27/27 untranslated) |
| `docs/RC1_FEATURE_FREEZE.md` | §8 changelog entry |
| `scripts/test_l10n_approval_gate.py` | `EXPECTED_PENDING` = 530 / 508 / 432 |
| `scripts/test_release_build_gate.py` | Current-state pin: 1,470 pending, 26/27/27 untranslated |
| `test/panda_portions_a11y_flow_test.dart` | The de-CH check expected the misspelling "Brueche"; it now expects "Brüche", which this phase introduced as the correct spelling. See §7 |
| New: `docs/l10n_review/swiss_phase3/` | `README.md`, `P1_APPLIED_<locale>.csv` (one row per Phase 3 value), and `APPROVAL_RECORD_TEMPLATE_<locale>.json` covering all 530 / 508 / 432 required keys. These templates supersede the Phase 2 ones, which list only the 754 Phase 2 keys |
| New: `docs/qa/SWISS_L10N_PHASE3_P1_ACCEPTANCE.md` | This report |

The Phase 2 packages and their SHA-256 handoff manifest are unchanged.

## 7. Verification

| Check | Result |
|---|---|
| ARBs parse; no keys outside the template; no key removed | Pass (de 1,694, fr 1,693, it 1,693 keys) |
| Placeholders: every English placeholder is present in every Swiss value | Pass |
| fr-CH non-breaking space before `? ! : ;` in every Phase 3 value | Pass |
| Only P1 keys changed (values and `@key` metadata) relative to `a2f60b0` | Pass, in all three locales |
| P2 keys and the P1 "no change" keys untouched | Pass |
| Pending markers equal `required_keys.json`; all 754 Phase 2 keys still marked | Pass |
| `flutter gen-l10n` run twice, and once more after the metadata-only label fix | Identical hashes each time |
| Approval-gate tests `test_l10n_approval_gate.py` | 22/22 OK |
| Release wrapper tests `test_release_build_gate.py` | 26/26 OK |
| Other script tests (autofill, KS5, split, translate packs, CH workflow) | 3 + 3 + 3 + 4 + 5 OK |
| `check_enabled_l10n.py --env prod` | Exit 1 as expected: 26 / 27 / 27 untranslated; 1,470 pending, 0 approved |
| `l10n_approval_gate.py --env prod / uat / dev` | 1 / 0 / 0 |
| `flutter analyze` | No issues found |
| Full selected Flutter suite (260 files except `practice_screen_continue_learning_resume_test.dart`, in 7 batches of up to 40) | **3,291 passed, 0 failed** after one test fix: 647 + 372 + 368 + 446 + 687 + 724 + 47 |
| **Production build wrapper, real toolchain** | Run from a throwaway clone at the same folder depth, with the changes committed only there; the clone was deleted afterwards. The repository, locale-configuration, pub get, gen-l10n and generated-localisations-current steps passed. **Blocked at completeness-and-approval** (26/27/27 untranslated; 1,470 pending, 0 approved). No Flutter build started and no artefact exists |

**The one test failure, and why the test was changed.** In the first full run, `panda_portions_a11y_flow_test.dart` "regional English intros match and stay claim-free" failed for de_CH.
- The test looked for "Brueche", the ASCII spelling the de_CH ARB used before.
- Phase 3 corrects that spelling to "Brüche" (umlaut-digraph correction, G-3), so the test now expects "Brüche".
- That file then passed 17/17, and its batch reran 446/446.
- No other test expects the old spelling.

## 8. Recommendation

- **Engineering integration: GO, after review.** The change is limited to translation data, generated files, manifests, documentation and pinned test counts. The gates stay strict, and all tests pass.
- **Linguistic approval: not started.** 1,470 drafts await native-speaker review.
- **Production release: NO-GO.** The blockers are:
  - 1,470 unapproved translations;
  - 26 / 27 / 27 untranslated keys (P2 and D-1);
  - the open decisions D-1 to D-9;
  - a direct `flutter build` is still possible without the wrapper.
