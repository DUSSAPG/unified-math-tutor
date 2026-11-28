# Linguistic approval records

The production-release gate (`scripts/l10n_approval_gate.py`) reads this folder. It runs as part of `scripts/check_enabled_l10n.py` and `scripts/release_readiness.ps1`.

There are **no approval records yet.** None may be created without a real review.

## Files

| File | Purpose |
|---|---|
| `required_keys.json` | Production-locale keys that need an approval record before a production release. Keys stay listed after their draft marker is removed. Currently these are the 33 AS-1 keys plus the Swiss Phase 2 P0 drafts and corrections: de_CH 267, fr_CH 256 and it_CH 231 keys (see `docs/qa/SWISS_L10N_PHASE2_ACCEPTANCE.md`). |
| `SWISS_TERMINOLOGY_GUIDANCE.md` | Draft Swiss terminology conventions and open decisions (pending review). |
| `records/*.json` | One approval record per review: one locale, one reviewer, one date. Created only by, or on behalf of, the reviewer. |

## Approval record format

```json
{
  "schema": "l10n-approval-record/v1",
  "locale": "de_CH",
  "reviewer": "<reviewer's name or approved reviewer reference>",
  "review_date": "YYYY-MM-DD",
  "arb_file": "lib/l10n/app_de_CH.arb",
  "approved_arb_sha256": "<SHA-256 of the ARB file as reviewed>",
  "entries": [
    {
      "key": "accessibilityReadingSizeSmall",
      "outcome": "approved",
      "approved_text_sha256": "<SHA-256 of the approved UTF-8 text>"
    }
  ]
}
```

- **`outcome`** is `approved`, `approved_with_changes` (put the final text in the ARB first, then hash that text) or `rejected`.
- **`approved_arb_sha256`** identifies the reviewed version of the file, so it can be traced. The gate checks that it is a SHA-256 digest. It enforces approval per key through `approved_text_sha256`, so editing other keys later doesn't void an approval.

## What the gate enforces (production only)

1. **No draft markers:** no production ARB may contain a "PENDING LINGUISTIC REVIEW" marker.
2. **A valid record for every required key:** each key in `required_keys.json` needs a record whose approved text hash matches the key's current text.
   - **Manifest missing or malformed:** if `required_keys.json` is absent, unreadable, has the wrong schema or lists no locales, production fails closed.
   - **Marker removed, no record:** fails.
   - **Text edited after approval:** fails until it is reviewed again.
   - **Current text rejected:** fails.
3. **Well-formed records:** a record with a missing reviewer, a bad date (or one in the future), the wrong locale or file, or missing hashes fails the production gate.

With `--env dev` or `--env uat`, the same findings are reported but don't fail. The output lists locales, keys and record file names only, never translation text or reviewer identities.

## Order of steps for a reviewed locale

1. The reviewer reviews the drafts and decides an outcome for each key.
2. The record is added to `records/`.
3. The draft markers are removed from exactly the approved keys, and the AS-1 marker test (`test/as1_swiss_localisation_test.dart`) is updated in the same change, citing the record.
4. The gate must pass with `--env prod` before a production release is authorised.
