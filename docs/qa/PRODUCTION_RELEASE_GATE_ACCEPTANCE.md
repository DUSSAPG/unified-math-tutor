# Production release gate enforcement: acceptance report

| | |
|---|---|
| Baseline | `e94b740` (`feature/math-intelligence-v2`, PR #9 merge: Swiss Phase 2) |
| Branch / worktree | `release/production-gate-enforcement`, worktree `unified_math_tutor_production_release_gate` |
| State | **Uncommitted. Awaiting scope and test review.** Not pushed, not merged. |
| Production build result | **Blocked.** With the current translations the wrapper stops at the completeness and approval step and starts no Flutter build. |
| Device work | None (no Pixel or ADB, no APK or AAB built or installed). |

## 1. Summary

- **New required production-build entry point:** `scripts/build_release.ps1`. It is a thin PowerShell wrapper around `scripts/release_build_gate.py`, which holds the logic.
- **The wrapper makes the existing checks mandatory before any production build:** `check_enabled_l10n.py --env prod` (completeness and approval) and `l10n_approval_gate.py --env prod` (linguistic approval). Neither script, the gate rules nor the 272-key completeness requirement was changed.
- **There is no force, skip or bypass option.**
- **Each run writes a provenance record.**
- **Not protected:** a direct `flutter build` is still possible, and there is no CI. This is documented in `RELEASE_CHECKLIST.md`.

## 2. Files

| File | Change |
|---|---|
| `scripts/build_release.ps1` | New. Parameters: `-Environment` (ValidateSet `prod`), `-Target` (ValidateSet `appbundle`, `web`) and `-EnableChPacks`. Unknown or extra arguments are rejected by PowerShell parameter binding. |
| `scripts/release_build_gate.py` | New. The validation pipeline, the build call and the provenance record. |
| `scripts/test_release_build_gate.py` | New. 26 tests that use mocked `flutter` and `dart`. |
| `RELEASE_CHECKLIST.md` | The wrapper is now the required production-build entry point. Documents that direct `flutter build` is not protected, the four decision stages and the updated current state. Existing requirements are kept, including the readiness suite before building. |
| `docs/RC1_FEATURE_FREEZE.md` | §8 changelog entry. |
| `docs/qa/PRODUCTION_RELEASE_GATE_ACCEPTANCE.md` | This report. |

No app code, ARB, generated localisation, approval manifest, approval record, curriculum, question content, pack or service configuration was changed.

## 3. Pipeline

The steps run in order and stop at the first failure. Exit codes: 0 built; 1 blocked (no build started); 2 invalid arguments; 3 build failed.

| # | Step (`checks[].step` in provenance) | Fails closed on |
|---|---|---|
| 0 | arguments (argparse with `allow_abbrev=False`, plus the PowerShell ValidateSet) | environment other than `prod`, target other than `appbundle`/`web`, any unknown or extra option. Nothing runs and no provenance is written |
| 1 | `repository` | not run from the repository's own `scripts/` folder; any modified or untracked path; git unavailable |
| 2 | `locale-configuration` | `productionLocales` unreadable or empty; regional production locales not equal to the completeness check's `ENABLED` (de_CH, fr_CH, it_CH); a production, base-language or template ARB missing, unreadable or empty; `required_keys.json` missing, invalid JSON, wrong schema, no locales, a non-production locale, or an empty key list |
| – | stale artefact removal | the expected artefact (`build/app/outputs/bundle/release/app-release.aab` or `build/web`) is deleted first, so a blocked run cannot leave a release artefact |
| 3 | `toolchain` | `flutter` not on PATH (the version is recorded) |
| 4 | `pub-get`, `gen-l10n` | non-zero exit |
| 5 | `generated-localisations-current` | any change other than the known side-effect files (`untranslated_messages.txt` and the plugin registrants under `linux/`, `macos/`, `windows/`); this catches stale committed generated localisations |
| 6 | `completeness-and-approval` | `check_enabled_l10n.py --env prod` non-zero: untranslated template keys, pending markers, missing or stale approvals, invalid records, bad manifest |
| 7 | `approval-gate` | `l10n_approval_gate.py --env prod` non-zero |
| 8 | `packs` / `ch-packs` + `ch-content-quality` | pack validation, or the strict CH content gate with `-EnableChPacks` |
| 9 | `tree-unchanged-before-build` | anything changed during validation, or HEAD moved |
| 10 | `build` | `flutter build <target> --release --dart-define=ENV=prod`, plus `--dart-define=ENABLE_CH_PACKS=true` for CH; the expected artefact must then exist |

An unexpected exception during validation is recorded as `blocked` (`failed_step: internal`) and never leads to a build.

**Provenance** (`build/release_provenance/<UTC>_<commit12>_<target>_<status>.json`, schema `release-build-provenance/v1`) contains:
- start and finish times and the status;
- the commit and branch, and whether the tree was clean at the start;
- the configuration: environment, target, CH flag, build command and pubspec version;
- the Flutter, Dart and Python versions;
- every check with its command, exit code and duration;
- the untranslated counts per locale and the approval-gate counts (pending by locale, unapproved, invalid, configuration problems, approved);
- the artefact path with its SHA-256 and size.

It contains no environment variables, credentials or absolute paths, and it states that it is not an approval.

## 4. Fail-closed coverage (tests)

All 26 tests in `scripts/test_release_build_gate.py` pass. Each test builds a throwaway git repository in a temporary folder and puts mocked `flutter.bat` and `dart.bat` first on PATH; the mocks log their calls and create a fake artefact only on `build`. The approval records in the passing fixtures are synthetic and labelled `SYNTHETIC TEST FIXTURE`. They exist only in the temporary folder.

| Requirement | Tests |
|---|---|
| Successful validation pipeline | `test_successful_validation_pipeline_then_build` (exact call order and step list), `test_ch_release_runs_strict_content_gate_and_ch_build`, `test_web_target`, `test_ps1_wrapper_builds_after_validation` |
| Unapproved translations fail before build | `test_pending_marker_blocks_before_build`, `test_changed_translation_without_fresh_approval_blocks`, `test_invalid_approval_record_blocks` |
| Approval records absent | `test_missing_approval_records_block` |
| Required keys untranslated | `test_untranslated_required_key_blocks` |
| Malformed or missing configuration | `test_missing_required_keys_manifest_blocks`, `test_malformed_required_keys_manifest_blocks` (4 variants), `test_missing_production_arb_blocks`, `test_malformed_production_arb_blocks`, `test_unsupported_production_locale_configuration_blocks` (3 variants) |
| Repository state | `test_dirty_working_tree_blocks`, `test_untracked_file_blocks`, `test_stale_generated_localisations_block` |
| Other validation | `test_pack_validation_failure_blocks`, `test_ch_content_gate_failure_blocks`, `test_build_failure_is_reported` |
| Invalid build arguments, no bypass | `test_invalid_arguments_are_rejected_before_anything_runs` (9 variants, including `--env uat`, `--target apk`, `--force`, `--skip-gate` and a pass-through `--dart-define`), `test_no_force_skip_or_bypass_option_exists`, `test_ps1_wrapper_blocks_and_rejects_invalid_arguments` |
| Correct provenance | `test_provenance_record` (commit, configuration, toolchain, gate counts, artefact hash; no paths or secrets) |
| No artefact when validation fails | Every blocked test asserts no `flutter build` call and no artefact; `test_stale_artefact_is_removed_when_validation_fails` |
| Current repository blocks | `test_current_translations_block_before_any_build`: the real ARBs and approval manifest give 754 pending (267/256/231), 199/200/200 untranslated, and no build. Pinned like `EXPECTED_PENDING` in the gate tests |

**The tests were checked for sensitivity.** I temporarily removed the two localisation checks and the clean-tree check from the wrapper, and 12 tests failed. The file was then restored byte for byte.

## 5. Verification

| Check | Result |
|---|---|
| `scripts/test_release_build_gate.py` | 26/26 OK |
| `scripts/test_l10n_approval_gate.py` | 22/22 OK (gate unchanged) |
| Other script tests (`test_autofill_ch_translation_csv`, `test_generate_ks5_premium`, `test_split_ch_translation_template`, `test_translate_ch_packs`, `tools/test_ch_translation_workflow`) | 3 + 3 + 3 + 4 + 5 OK |
| `py scripts/check_enabled_l10n.py --env prod` | Exit 1 as expected: de_CH 199, fr_CH 200, it_CH 200 untranslated; 754 pending, 0 approved |
| `l10n_approval_gate.py --env prod / uat / dev` | 1 / 0 / 0 |
| `flutter analyze` | No issues found |
| Swiss-locale Dart regression tests (41 files) | 513/513 passed. No Dart code changed, so the full suite was not rerun |
| **Real end-to-end wrapper run** | Run from a throwaway clone at the same folder depth, because the app's path dependencies are relative, with the wrapper committed only in that clone. Real Flutter 3.41.2: `repository`, `locale-configuration`, `toolchain`, `pub-get`, `gen-l10n` and `generated-localisations-current` passed. **`completeness-and-approval` blocked (exit 1): 199/200/200 untranslated, 754 pending (de_CH 267, fr_CH 256, it_CH 231), 0 approved.** No Flutter build started and no artefact exists. The provenance record was written and contains no paths or credentials. The clone was deleted afterwards |

An earlier run from a scratchpad clone also failed closed, at `pub-get`, because the relative path dependencies could not be resolved there.

## 6. Limits

- **A direct `flutter build` is not protected.** The wrapper is enforced by procedure (`RELEASE_CHECKLIST.md`), not by Flutter or CI. Moving the check into Gradle or CI would be a separate decision.
- **The wrapper trusts the tools on PATH.** A substituted `flutter` could fake the build step. It cannot make the localisation checks pass, because those run in Python from the repository.
- **Side-effect files.** `pub get` and `gen-l10n` rewrite `untranslated_messages.txt` and the plugin registrants on this host. They must be restored (`git checkout -- linux macos windows untranslated_messages.txt`) before the next run, because each run requires a clean tree.
- **The readiness suite is still separate.** `release_readiness.ps1` (tests, analysis) is still a required step before building; the wrapper does not run `flutter test`.
- **Evidence, not quality.** The gate verifies approval evidence, not translation quality.

## 7. Release status

Production build: **blocked** by the current state (754 pending translations, 199/200/200 untranslated). Public release: **NO-GO**. No translation was approved and no approval record was created.
