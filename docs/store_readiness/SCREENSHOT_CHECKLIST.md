# Screenshot Checklist — Store Listings

Screenshots must be taken at correct device sizes and in the correct locale before store submission.
Recommended tool: Flutter integration test + `screenshotter`, or manual capture on emulator/device.

---

## Device Sizes Required

| Store | Required Sizes |
|---|---|
| Google Play | Phone: 1080×1920 (portrait). Tablet 7": 1200×1920. Tablet 10": 1600×2560. |
| App Store | iPhone 6.7" (1290×2796), iPhone 6.5" (1242×2688), iPad Pro 12.9" (2048×2732). |

Minimum: **2 screenshots** per size. Recommended: **5–8 screenshots** showing the key flows.

---

## Screenshot Screens (all locales)

| # | Screen | Route | Notes |
|---|---|---|---|
| 1 | Home — greeting + streak | `/` (home tab) | Show streak badge + What's New card |
| 2 | Topics list | `/topics` | Show topic cards with progress bars |
| 3 | Practice setup | `/practice` | Mode selection screen |
| 4 | Practice session | `/practice` (in session) | MCQ question with options |
| 5 | Session summary | (after last question) | Show accuracy % + encouragement |
| 6 | Tutor — empty state | `/tutor` | Show How Tutor Works cards |
| 7 | Tutor — active chat | `/tutor` (after sending) | Show bot response bubble |
| 8 | Upgrade screen | `/upgrade` | Benefit cards + Early Access CTA |

---

## Locale: `en_GB`

**Flavor:** `gb` — **Language:** English (UK)

| # | Screen | Captured | File Name |
|---|---|---|---|
| 1 | Home | ⏳ | `en_GB_01_home.png` |
| 2 | Topics | ⏳ | `en_GB_02_topics.png` |
| 3 | Practice setup | ⏳ | `en_GB_03_practice_setup.png` |
| 4 | Practice session | ⏳ | `en_GB_04_practice_session.png` |
| 5 | Session summary | ⏳ | `en_GB_05_summary.png` |
| 6 | Tutor empty | ⏳ | `en_GB_06_tutor_empty.png` |
| 7 | Tutor active | ⏳ | `en_GB_07_tutor_active.png` |
| 8 | Upgrade | ⏳ | `en_GB_08_upgrade.png` |

---

## Locale: `de_CH`

**Flavor:** `ch` — **Language:** German (Switzerland)

| # | Screen | Captured | File Name |
|---|---|---|---|
| 1 | Home | ⏳ | `de_CH_01_home.png` |
| 2 | Topics | ⏳ | `de_CH_02_topics.png` |
| 3 | Practice setup | ⏳ | `de_CH_03_practice_setup.png` |
| 4 | Practice session | ⏳ | `de_CH_04_practice_session.png` |
| 5 | Session summary | ⏳ | `de_CH_05_summary.png` |
| 6 | Tutor empty | ⏳ | `de_CH_06_tutor_empty.png` |
| 7 | Tutor active | ⏳ | `de_CH_07_tutor_active.png` |
| 8 | Upgrade | ⏳ | `de_CH_08_upgrade.png` |

---

## Locale: `fr_CH`

**Flavor:** `ch` — **Language:** French (Switzerland)

| # | Screen | Captured | File Name |
|---|---|---|---|
| 1 | Home | ⏳ | `fr_CH_01_home.png` |
| 2 | Topics | ⏳ | `fr_CH_02_topics.png` |
| 3 | Practice setup | ⏳ | `fr_CH_03_practice_setup.png` |
| 4 | Practice session | ⏳ | `fr_CH_04_practice_session.png` |
| 5 | Session summary | ⏳ | `fr_CH_05_summary.png` |
| 6 | Tutor empty | ⏳ | `fr_CH_06_tutor_empty.png` |
| 7 | Tutor active | ⏳ | `fr_CH_07_tutor_active.png` |
| 8 | Upgrade | ⏳ | `fr_CH_08_upgrade.png` |

---

## Locale: `it_CH`

**Flavor:** `ch` — **Language:** Italian (Switzerland)

| # | Screen | Captured | File Name |
|---|---|---|---|
| 1 | Home | ⏳ | `it_CH_01_home.png` |
| 2 | Topics | ⏳ | `it_CH_02_topics.png` |
| 3 | Practice setup | ⏳ | `it_CH_03_practice_setup.png` |
| 4 | Practice session | ⏳ | `it_CH_04_practice_session.png` |
| 5 | Session summary | ⏳ | `it_CH_05_summary.png` |
| 6 | Tutor empty | ⏳ | `it_CH_06_tutor_empty.png` |
| 7 | Tutor active | ⏳ | `it_CH_07_tutor_active.png` |
| 8 | Upgrade | ⏳ | `it_CH_08_upgrade.png` |

---

## Locale: `ko_KR`

**Flavor:** `kr` — **Language:** Korean (South Korea)

| # | Screen | Captured | File Name |
|---|---|---|---|
| 1 | Home | ⏳ | `ko_KR_01_home.png` |
| 2 | Topics | ⏳ | `ko_KR_02_topics.png` |
| 3 | Practice setup | ⏳ | `ko_KR_03_practice_setup.png` |
| 4 | Practice session | ⏳ | `ko_KR_04_practice_session.png` |
| 5 | Session summary | ⏳ | `ko_KR_05_summary.png` |
| 6 | Tutor empty | ⏳ | `ko_KR_06_tutor_empty.png` |
| 7 | Tutor active | ⏳ | `ko_KR_07_tutor_active.png` |
| 8 | Upgrade | ⏳ | `ko_KR_08_upgrade.png` |

---

## Output Directory

Store screenshot assets under:

```
assets/screenshots/
  en_GB/
  de_CH/
  fr_CH/
  it_CH/
  ko_KR/
```

## Screenshot Review Checklist

Before uploading to stores:

- [ ] No debug banners visible (`flutter build` in release mode or `debugShowCheckedModeBanner: false`)
- [ ] Correct locale active in each screenshot
- [ ] No personal data or test credentials visible
- [ ] Status bar is clean (full battery, no notifications)
- [ ] All text is legible at thumbnail size
- [ ] Brand name consistent: "Sterling Math" (GB/CH) or "Sterling Math Korea" (KR)
