# Math Intelligence reconciliation: acceptance (2026-11-22)

This report covers the merge of the Panda/Binomial/Angle integration line with the parent-led Early Maths lane.

| | |
|---|---|
| Branch | `integration/math-intelligence-reconciled-v1` (local only) |
| Worktree | `unified_math_tutor_math_intelligence_reconciled_v1` |
| Merge commit | `fe8aba5` |
| Cleanup commit | `da3a9f5` |
| Report commit | the commit that adds this file |
| Scope | Host verification only. No Pixel install, no push, no tag, no merge into `main`, `master` or `feature/math-intelligence-v2`. |

**Recommendation: GO for local integration, with one condition.** The reconciled tree has not been verified on a device. A Pixel UAT of the Early Maths hub (see section 9) is required before this branch is promoted any further.

## 1. Ancestry

```
master d9543bc ── … ── c7b3e7f ── … ── 922ce3d  integration/panda-binomial-angle-v1
                                         │       (Pixel acceptance GO, evidence preserved)
e019fe8 ── 5f49c50  feat(early-maths): parent-led lane foundation (local)
              │                          │
              └──────────┬───────────────┘
                         fe8aba5  merge: integrate parent-led early maths lane (--no-ff)
                         da3a9f5  chore: remove four accidental shell-output files
                         (this report)
```

- **First parent: `922ce3d`.** This is the integration line. Its accepted QA evidence is unchanged.
- **Second parent: `5f49c50`.** This is the local parent-led lane commit, as instructed.
- **Remote lane variant not used.** `91836a6` and `0cc3d3c` were not merged and nothing from them was copied.
- **Uncommitted main-checkout changes not used.** None of the 24 uncommitted changes in the main checkout were included. That checkout is still at `5f49c50` with the same 24 changes, and it was not touched.

There is one Flutter app throughout: a single `pubspec.yaml` (`name: unified_math_tutor`), a single `lib/main.dart` and a single Android app. The merge adds no second app or package.

## 2. Merge resolution

The textual conflicts were in `app_en.arb`, the 13 generated `app_localizations*.dart` files, and `early_maths_playground_hub_screen.dart`.

### Approved product decisions applied

| Decision | Result |
|---|---|
| Panda Portions belongs in Early Maths Play. | Early Maths Play shows Feed the Panda, Panda Portions and the parent-led section. |
| "I'm not sure" may recommend Panda Portions where its objective fits. | Product owner chose to keep **Feed the Panda only** for "I'm not sure" and no-choice. Counting comes before sharing into fractions. Panda Portions is offered once Early Maths Play is chosen. |
| No Panda Portions in KS1 Foundations without a verified curriculum mapping. | KS1 Foundations shows the abacus and the parent-led section only. |
| Preserve the closed activity-list architecture. | `EarlyMathsChildActivity` is still a closed enum. It now has exactly `feedThePanda`, `pandaPortions` and `abacus`, and a test fails if a member is added without review. |
| Hub introduction | Product owner chose **both, playground first**. The hub shows `earlyMathsPlaygroundIntro` (what the space is), then `earlyMathsEntryIntro` (how to start). |

### Code

- **`lib/models/early_maths_lane.dart`.**
  - `pandaPortions` is added to the closed enum, with a doc comment that records the placement rule.
  - `childActivities(earlyMathsPlay)` returns `[feedThePanda, pandaPortions]`.
  - `notSure` and `null` still return `[feedThePanda]`.
  - KS1 still returns `[abacus]`.
- **`lib/screens/labs/early_maths_playground_hub_screen.dart`.**
  - The lane chooser and parent-led section come from `5f49c50`.
  - A new `pandaPortions` card case uses key `pandaPortionsEntryCard` and the existing route `/math-studio/interactive-labs/early-maths-playground/panda-portions`. The route itself is unchanged.
  - The integration's back-button key (`earlyMathsPlaygroundBackButton`) and localised tooltip are restored. Taking the lane side of the conflict had dropped them.
- **Integration features untouched.** No Panda Portions, Feed the Panda, Binomial Volume, Create the Angle, Pitch Coordinates or Fractions of a Set source file changed. The merge's diff against `922ce3d` touches only the files listed in section 3.

## 3. Files changed

These are the changes against the first parent, `922ce3d → fe8aba5`: 29 files, +3,001 / −46.

| Area | Files |
|---|---|
| Lane (from `5f49c50`) | `lib/models/early_maths_lane.dart`, `lib/services/early_maths_lane_preference_service.dart`, `docs/learning_architecture/EARLY_MATHS_AVAILABILITY_GAPS_BACKLOG_V1.md` |
| Hub (resolved) | `lib/screens/labs/early_maths_playground_hub_screen.dart` |
| Localisation | `lib/l10n/app_en.arb`, 13 generated `lib/l10n/app_localizations*.dart`, `untranslated_messages.txt` |
| Lane tests (from `5f49c50`, adjusted) | `test/early_maths_entry_{portrait,compact_landscape,large_text_reduce_motion,panda_progress_preserved,topic_hub_isolation}_test.dart`, `test/early_maths_lane_{model,preference_service}_test.dart`, `test/support/early_maths_entry_test_utils.dart` |
| New test | `test/early_maths_entry_panda_portions_route_test.dart` |
| Integration test (adjusted) | `test/feed_the_hungry_panda_widget_test.dart` |

### Test adjustments, and why each one is honest

1. **The lane model and entry tests now expect Panda Portions in Early Maths Play only.**
   - New: Panda Portions appears only in Early Maths Play.
   - New: every lane shows only members of the closed list.
   - The closed-list test now expects three members.
   - The not-sure assertions are unchanged: `{feedThePanda}`.
   - The KS1 assertions are unchanged: `{abacus, parent}`.
2. **The model test's stale comment was corrected.** It called `earlyMathsPlaygroundIntro` "retired", but the hub shows it again. The key stays out of the entry-copy claim check because its "no scores" wording is a deliberate disclaimer. Its own scope is checked by `panda_portions_a11y_flow_test.dart`.
3. **A defect in `5f49c50` was fixed.** The portrait test looked for "Slide beads across the bar", but the abacus card shows `earlyMathsAbacusScope` ("…tap or drag beads…"). The test fails at `5f49c50` itself, as reproduced in a throwaway worktree that has since been removed. It now checks for the copy the app actually shows, which the model test already requires.
4. **Feed the Panda navigation tests now scroll the card into view first.** This applies to the entry-card navigation test and the reachability test that runs in each of 5 locales. With both intros and the lane chooser, the card starts below the fold at 390×844 when no lane is chosen. The tests tapped it without scrolling, so they now call `ensureVisible` first. This is a real layout effect; see section 9.

## 4. Parent-led lane preservation

These behaviours from `5f49c50` are intact. All lane tests pass: 9 `early_maths_*` files, 42 tests.

- Three lanes with stable storage values. No lane is pre-assigned. Unknown values read as "no lane".
- The lane is presentation-only. It is not a manifest stage or a practice stage, as `early_maths_lane_model_test` checks.
- The parent-led Family Maths section is shown only for Early Maths Play and KS1. It is driven by catalogue ages.
- The lane preference is persisted, and Panda progress is kept across lane changes (`early_maths_entry_panda_progress_preserved_test`).
- The hub has no effect on Topic Hub (`early_maths_entry_topic_hub_isolation_test`).
- Portrait, compact landscape, large text and reduce motion are all covered.
- Copy-honesty guards still hold: no banned claims, age is described as a suggestion, and the Panda and abacus scopes are stated.

## 5. Panda Portions route tests

| Requirement | Test | Result |
|---|---|---|
| Appears in Early Maths Play | `early_maths_entry_panda_portions_route_test`, plus the portrait and compact-landscape Early Maths Play assertions | PASS |
| "I'm not sure" and no choice show Feed the Panda only (product decision) | the same route test, plus `early_maths_lane_model_test` | PASS |
| Not exposed in KS1 Foundations | the same route test, plus the lane model test and both layout tests | PASS |
| Closed-list protection | the lane model test (three members, every lane ⊆ closed list), plus `expectOnlyKnownCards` | PASS |
| Card opens the existing route on the real router | the route test reaches `PandaPortionsScreen` and the hub is gone | PASS |
| Existing Panda Portions flow and a11y | `panda_portions_a11y_flow_test` (17), including "intro names counting, sharing and early fractions only", which passes again now that the hub shows the playground intro | PASS |

## 6. Localisation verification

- **`app_en.arb` is the union of both sides.**
  - It has 3,330 entries: 3,292 from the integration side plus 38 from the lane side.
  - In messages, that is 1,690 + 19 = 1,709.
  - A three-way check against the merge base found no key changed on both sides, and the lane side changed no existing key.
  - The file parses as JSON and keeps CRLF line endings.
- **Generated files were regenerated, not hand-edited.**
  - They were produced by `flutter pub get` then `flutter gen-l10n`, in the reconciliation worktree only.
  - In every one of the 13 files, the member set equals union(`922ce3d`, `5f49c50`).
- **`untranslated_messages.txt`.**
  - The only additions are the 19 lane keys, for each of 19 locales.
  - Nothing was removed. The only other changes are two existing last-of-list keys (`labsFractionsOfASetTenths`, `pandaPortionsChoosePlate`) gaining a trailing comma.
- **No unrelated translation changed.** Of the 20 ARB files, only `app_en.arb` changed. The `en_GB`, `de_CH`, `fr_CH` and `it_CH` ARBs are byte-identical to `922ce3d`.
- **The lane strings have no translations yet.** The 19 lane keys fall back to English in non-English locales, exactly as they did at `5f49c50`.
- **Side note on the source commit.** At `5f49c50`, the committed generated l10n files were out of date against its own ARB: a test run there regenerated them. This does not affect the reconciled tree, which was regenerated from the merged ARB.

## 7. Four-file cleanup (`da3a9f5`)

`git rm` removed four files that were committed by mistake in `56c4506`. They are captured shell output and git warnings, named by stray redirects:

| File | Size |
|---|---|
| `git diff --cached --stat` | 2,637 B |
| `essions` | 2,637 B |
| `istence and anti-repetition patterns` | 17,517 B |
| `retrieval practice` | 17,517 B |

No code, asset or test refers to them. `.claude/settings.json` is unchanged. The QA evidence under `docs/qa/evidence/PANDA_BINOMIAL_ANGLE_2026-11-22/` is unchanged.

## 8. Regression results

All results are from the reconciliation worktree at `da3a9f5`, on the host only.

| Check | Result |
|---|---|
| `git diff --check 922ce3d HEAD` | clean |
| `git diff --cached --check` (before each commit) | clean |
| `flutter analyze` | No issues found |
| Conflict markers in `lib/` and `test/` | none |
| Lane tests (`early_maths_*`, 9 files) | 42 / 42 pass |
| Panda, Binomial and Angle protections, including `feed_the_hungry_panda_widget_test` (53), `panda_portions_a11y_flow_test` (17), `create_angle_*`, `binomial_*` and `fractions_of_a_set_distinction_guard_test` | all pass |
| **Full selected suite** | **2,761 passed, 0 failed, 0 skipped, in 249 files** |

How the suite was run:

- **Batches.** `flutter test --reporter json`, in 5 batches of up to 60 files, because of the Windows command-line limit.
- **Per-file check.** The results were aggregated per file: all 249 listed files reported tests.
- **Drift guard.** The guard "Panda, Create the Angle, Pitch and Binomial files are unchanged in this working tree" passes. It checks for uncommitted changes, so it failed only while the merge was uncommitted.

Exclusions:

1. `test/practice_screen_continue_learning_resume_test.dart`. It hangs in this environment, which is already known and unrelated to this work.
2. `test/support/*`. These are helpers with no `main()`, not tests.

The earlier 2,722 result belongs to `4494356` and does not apply here. The 39 additional tests come from the lane tests and the new route test.

Every run rewrites the 7 desktop plugin registrants, as test, build and analyze always do here. They were restored after confirming the diff was line endings only, and none of them is committed.

## 9. Open items

- **R-1: No Pixel UAT of the reconciled tree. This blocks promotion.** It should cover:
  - Early Maths hub at 390-dp portrait: both intros, then the lane chooser. Feed the Panda is below the fold with no lane chosen. Check that a parent can still find it by scrolling, and decide whether that is acceptable.
  - Each lane's cards; Panda Portions opening from Early Maths Play; back navigation.
  - TalkBack names for the lane tiles and the new card.
- **FU-1 (carried over, unchanged).** The Fractions of a Set feedback scroll (`fractions_of_a_set_screen.dart:102`) honours only `MediaQuery.disableAnimationsOf`, not the in-app Reduce Motion setting. This is not touched here.
- **FU-2 (carried over, unchanged).** `lib/main.dart:121` replaces the platform `textScaler` with Reading Size, whose maximum is 1.15×, so Android's font size has no effect in the app. The freeze document conflicts with this:
  - `docs/RC1_FEATURE_FREEZE.md` §6 counts overflow at 1.6× text scale as release-blocking.
  - With the override, a learner can never reach 1.6×, and Android's setting is ignored.
  - This needs a product decision on whether to combine the two scales or to restate the freeze requirement.
  - The lane's large-text test exercises the hub at large scale on the host only.
- **Lane translations.** The 19 lane strings are English-only in non-English locales, as they were at `5f49c50`.

## 10. Recommendation

**GO for local integration** of `integration/math-intelligence-reconciled-v1` at the report commit:

- The approved decisions are applied.
- The closed list is preserved.
- Localisation is a verified union.
- The cleanup is isolated.
- The host suite is fully green.

**NO-GO for promotion** to `feature/math-intelligence-v2`, `master` or `main` until R-1 (Pixel UAT) passes. Nothing has been pushed, tagged, deployed or installed.
