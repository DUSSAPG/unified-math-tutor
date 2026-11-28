# Swiss Phase 3 P1 review packages

These packages are for native-speaker reviewers of de-CH, fr-CH and it-CH. **Nothing here is approved.** Every value listed is in the app as a draft marked `PENDING LINGUISTIC REVIEW`.

| File | What it is |
|---|---|
| `P1_APPLIED_de_CH.csv`, `P1_APPLIED_fr_CH.csv`, `P1_APPLIED_it_CH.csv` | One row per P1 value written to the ARB in Phase 3 (263 / 252 / 201 rows), grouped by learning area. UTF-8 with BOM. |
| `APPROVAL_RECORD_TEMPLATE_<locale>.json` | A blank record in the gate's `l10n-approval-record/v1` format, listing **every** required key after Phase 3 (530 / 508 / 432). It is a template, not a record, and supersedes the Phase 2 templates, which list only the 754 Phase 2 keys. |

The P0 and AS-1 drafts are reviewed with the Phase 2 packages in `../swiss_phase2/`, which still apply unchanged. In those packages the rows marked "P1 proposal (NOT in ARB)" are now in the ARB as pending drafts. Review them here, using the text in `draft_in_arb`.

## Columns

| Column | Meaning |
|---|---|
| `area` | Panda Portions, Number sense, Abacus and place value, Fractions and ratios, Interactive labs, Other learning activities |
| `english_source` | Text in the template `lib/l10n/app_en.arb` (unchanged) |
| `draft_in_arb` | The pending draft now in the Swiss ARB |
| `previous_value` | Value before Phase 3 (empty for keys that were missing) |
| `change_type` | `added_missing` or `corrected (<kind>)` |
| `deviation_from_phase2_proposal` | Set only where the applied text differs from the Phase 2 proposal (one key, `abacusPlayParentNote`: register) |
| `translator_notes` | Drafting notes from Phase 2. **`COMPOSED`** means the string is put together at runtime from fragments; review it with its fragments. `REVIEW` and `DECISION` mark open points |
| `placeholders`, `format_requirements` | Must survive unchanged |
| `reviewer_outcome`, `reviewer_final_text`, `reviewer_comment` | **Reviewer fills in** |

## After the review (not part of Phase 3)

Follow `docs/l10n_approvals/README.md`:

1. Put any changed text into the ARB.
2. Create a real record in `docs/l10n_approvals/records/` from the template, then fill in the reviewer, date, ARB hash and each entry's outcome and text hash.
3. Remove markers for exactly the approved keys.
4. Run `py scripts/l10n_approval_gate.py --env prod`.

Never create a record, fill in a reviewer or date, or remove a marker on a reviewer's behalf.
