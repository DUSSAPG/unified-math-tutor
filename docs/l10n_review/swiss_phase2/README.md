# Swiss Phase 2 linguistic review packages

These packages are for native-speaker reviewers of de-CH, fr-CH and it-CH. They contain no approvals: nothing here has been reviewed yet.

| File | What it is |
|---|---|
| `REVIEW_de_CH.csv`, `REVIEW_fr_CH.csv`, `REVIEW_it_CH.csv` | One row per string to review. UTF-8 with BOM, so Excel and LibreOffice show the accents correctly. |
| `APPROVAL_RECORD_TEMPLATE_<locale>.json` | A blank record in the gate's `l10n-approval-record/v1` format, listing every required key. It is a template, not a record. |
| `P2_UNREFERENCED_EVIDENCE.md` | Why the 37 P2 keys are left alone. |
| `../../l10n_approvals/SWISS_TERMINOLOGY_GUIDANCE.md` | The conventions (rules `G-…`) and open decisions (`D-…`) that the drafts follow. Read this first. |

## Sections in each CSV

| `section` | Rows (de / fr / it) | In the app now? | Needs an approval record? |
|---|---|---|---|
| AS-1 draft (unchanged in Phase 2) | 33 / 33 / 33 | Yes, marked pending | Yes |
| Phase 2 P0 (in ARB) | 234 / 223 / 198 | Yes, marked pending | Yes |
| Blocked: no draft written | 0 / 1 / 1 | No (English fallback) | Not until it is drafted (decision D-1) |
| P1 proposal (NOT in ARB) | 263 / 252 / 201 | **No.** A proposal only | Not yet. It must be written into the ARB, marked pending and added to `required_keys.json` first |
| P1 flag reviewed: no change proposed | 0 / 3 / 1 | Existing value | No |

The first two sections together are exactly the keys in `docs/l10n_approvals/required_keys.json`: de_CH 267, fr_CH 256, it_CH 231.

## Columns

| Column | Meaning |
|---|---|
| `priority` | P0 means on a primary or curriculum screen; P1 means inside a reachable activity. "not in backlog" marks AS-1 keys that had no other issue. |
| `english_source` | The text in the template `lib/l10n/app_en.arb`. |
| `proposed_translation` | The draft to review. For P0 it is the text currently in the ARB. |
| `previous_value` | The text before Phase 2, for corrections and replaced English copies. Empty for keys that were missing. |
| `change_type` | `added_missing`, `replaced_english_copy`, `corrected (diacritics / stale translation / curriculum terminology / Oxford naming)`, `as1_draft`, or a P1 proposal type. |
| `screens_or_context` | The Dart files that use the key. |
| `curriculum_notes` | England-curriculum and Oxford naming rules (G-1, G-2), stale-source notes, and legal review. |
| `translator_notes` | Choices made while drafting and points to check. **`COMPOSED`** means the string is put together at runtime from fragments. Review it together with its fragments (G-9). |
| `placeholders` | Placeholders that must survive unchanged. |
| `format_requirements` | ICU, notation, decimal, French punctuation and short-label constraints. |
| `reviewer_outcome` | **Reviewer fills in:** `approved`, `approved_with_changes` or `rejected`. |
| `reviewer_final_text` | **Reviewer fills in** for `approved_with_changes`. |
| `reviewer_comment` | **Reviewer fills in** (optional). |

## After the review (not part of Phase 2)

Follow `docs/l10n_approvals/README.md`:

1. Put any changed text into the ARB.
2. Create a real record in `docs/l10n_approvals/records/` from the template. Fill in the reviewer, date, ARB hash, and each entry's outcome and text hash, and leave out entries that were not reviewed.
3. Remove the markers for exactly the approved keys.
4. Run `py scripts/l10n_approval_gate.py --env prod`.

Never create a record, fill in a reviewer or date, or remove a marker on a reviewer's behalf without their review.
