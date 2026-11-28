# Swiss Phase 2 reviewer handoff: manifest

**Approved translations: 0.** These files help reviewers organise their work. They are not approvals: they contain no reviewer identity, date or outcome, and no approval record exists. Production stays blocked until real records are added under `docs/l10n_approvals/records/` (see `README.md`).

Produced at commit `a983f10` by a read-only audit of the review packages, approval templates, ARBs and `required_keys.json`. No translation was generated or changed.

## Files and SHA-256

| File | SHA-256 of the original bytes (CRLF, as delivered) | SHA-256 with LF line endings (as stored by git) |
|---|---|---|
| `REVIEW_SEQUENCE_de_CH.csv` | `675a9c3701491d1d0cbd30c7f2553c962b3de8f4ea401f4676674a47509bd951` | `aa95d61a0ebabf3fc526e13bab5140ff913f13c7bde06a6cd41a8270e6cabd7e` |
| `REVIEW_SEQUENCE_fr_CH.csv` | `197e871a5c578cbe2a7d23f16b3e6a5c11877681e8ca8e0a4d294da0577a0d17` | `2e54a901c5f5996fabc7e21e3926d1412975f4a3dda52c34438eb64a19ed7a4e` |
| `REVIEW_SEQUENCE_it_CH.csv` | `56e399a3d8fdb2c19db3e2efa14199902370d51382d7ac7b9f848ac71e9873fd` | `df03ef8e5e6339a4e51131869954f0dbb64e1be023a5c86429347d84d97c5162` |
| `handoff_audit.json` | `816b61401f1e590e3081186c9807582456481343361fa1befb7b3003f8b0f343` | `f3d286256592fd014e15acaa6b8a0ebe68c849554cb95c61cc5ff2dd434e25a8` |

The repository uses `core.autocrlf=true`, so git stores these files with LF line endings and a Windows checkout restores CRLF. Compare against whichever column matches your checkout.

## Review sequence (the `batch` column)

| Batch | What it is | In the app? | de_CH | fr_CH | it_CH |
|---|---|---|---:|---:|---:|
| 1 | P0 drafts: navigation, accessibility, onboarding | Yes, marked pending | 86 | 83 | 84 |
| 2 | P0 drafts: parent-facing content and curriculum terminology | Yes, marked pending | 94 | 88 | 77 |
| 2b | P0 drafts: other primary screens | Yes, marked pending | 87 | 85 | 70 |
| 3 | **P1 proposals: not in the app** (Panda Portions and learning activities) | **No** | 263 | 252 | 201 |
| 4 | **Existing translations, not pending**, that need pronunciation review | Yes, already translated | 148 | 147 | 151 |

- Batches 1, 2 and 2b together are exactly the pending keys in `required_keys.json`: de_CH 267, fr_CH 256, it_CH 231, 754 in all.
- Batch 3 proposals are in the `REVIEW_<locale>.csv` packages only. They must be written to the ARB, marked pending and added to `required_keys.json` before they can be approved.
- Batch 4 means already-translated values that are read aloud by a screen reader or narration (key names containing `Semantics`, `A11y`, `Announce`, `Tooltip`, `Narration` or `VoiceCue`), or values containing maths notation or abbreviations (for example `×`, `°`, `2/3`, `z. B.`). The app's own text-to-speech is currently a no-op, so today these are heard only through screen readers. Batch 4 needs no approval record unless a value is changed.

## Unresolved terminology and legal decisions

The `decision_flags` column marks the affected keys. These decisions are open; no final translation has been chosen for any of them.

| Decision | Keys |
|---|---|
| D-1 Swiss Gymnasium | `practiceExamSwissGymnasium`: drafted in de-CH, blocked (no draft) in fr-CH and it-CH |
| G-1/G-2 GCSE, KS, 11+, Oxford | 37 keys (flag `G-1/G-2`) |
| D-2 Legal | `helpTermsBody` (pending in all three). Existing privacy claims for legal review: `helpPrivacyHeadline`, `profilePrivacyDataSub`, `helpPrivacyBullet2` |
| D-3 Decimal separator | `numberSenseHundredthsLineLabel` (P0) and 6 P1 keys. A decimal comma needs a separate implementation contract |
| D-4 fr-CH punctuation | 28 fr-CH keys (11 pending, 17 P1) |
| D-5 fr-CH 1990 spellings | 15 pending fr-CH keys |
| D-6 Panda Portions name | `pandaPortionsTitle` (P1) |
| D-7 Fluency | `ratioFoundationsRungFluency`, `ratioFoundationsFluencyProgress` (pending); check `entranceExamSkillNumberFluency` for consistency |
| D-8 Parent register | 62 parent-facing keys. Drafts use informal address throughout; the fr-CH "vous" in `familyStudioSectionConversationStartersSubtitle` is plural (parent and child). Reviewers should also check the generic masculine ("tuo figlio", "ce qu'il") |
| D-9 English source | `upgradeBenefit2Sub`, `footballStudioProgressOwnership`, `familyStudioTutorCompletionLabel` |

## Reading `handoff_audit.json`

- `locales`: the package completeness checks. Each pending key appears exactly once, every column is filled, the templates list exactly the pending keys, and no reviewer field is filled in.
- `template_raw_problem_*`: what the gate reports for each template as delivered. Only the blank reviewer, date, outcome and hash fields are flagged.
- `template_sim_filled_problems`: empty, meaning the template structure passes the gate's record check once those fields are filled. That check was run in memory only; no record was written.
- `decisions`: **broad candidate lists found by pattern matching**, wider than the curated table above. For example, `D-2` also lists `commonCancel` and the privacy screen strings. The table above is the reviewed version.
- `sequence`: the batch lists, the same as in the CSVs.
