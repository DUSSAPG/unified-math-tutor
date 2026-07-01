# Unified Math Tutor Marketing Review

## Executive Summary

Unified Math Tutor has a credible core proposition: structured maths practice from KS2 through KS5, delivered from large bundled question packs that work without a network connection. The repository contains a polished student-facing shell, topic browsing, configurable practice sessions, immediate answer feedback, optional explanations, curriculum selection, multilingual UI scaffolding, and a practice-aware tutor interface.

The strongest near-term Play Store position is:

> Maths practice from KS2 to KS5, available anytime with focused sessions, instant feedback, and no advertising.

The strongest long-term institutional position is broader:

> A configurable, market-aware maths learning platform with local-first content delivery and a repeatable question-generation, verification, audit, and remediation pipeline.

The second statement is more defensible than a generic "AI tutor" claim. The repository includes evidence of a serious content pipeline, but it also contains unfinished product areas and pending question-bank remediation. Marketing must distinguish shipped capabilities from roadmap items.

## Repository Evidence

| Area | Evidence |
| --- | --- |
| Offline practice engine | `lib/screens/practice/practice_screen.dart` loads bundled JSONL assets with `rootBundle.loadString` |
| Curriculum breadth | `assets/pack_registry.json` exposes KS2, KS3, KS4, KS5, and merged packs |
| Pack size | `47,419` records in `ALL_merged_deduped.jsonl`; stage packs include `10,000` KS2, `10,000` KS3, `18,432` KS4, and `8,987` KS5 records |
| Topic breadth | Pack inspection found `3` KS2 skills, `6` KS3 skills, `24` KS4 skills, and `29` KS5 skills |
| Practice flow | Setup, question session, answer checking, explanation display, and summary views exist in `lib/screens/practice/practice_screen.dart` |
| Tutor UX | Practice-context banner, hint, explanation, step, and mistake-analysis actions exist in `lib/screens/tutor/tutor_screen.dart` |
| Markets | `assets/market_registry.json` defines UK, Switzerland, US, Sweden, Norway, Denmark, Korea, and Singapore |
| UI locales | The active app locale service supports English, German, French, Italian, and Korean |
| Verification pipeline | `content/verified/reports/` contains SymPy validation reports and reject outputs |
| Privacy positioning | `lib/screens/settings/privacy_data_screen.dart` presents minimal-data, no-advertising, and deletion-request messaging |

## 1. Unique Selling Propositions

### Market-Ready USPs

1. **KS2-to-KS5 coverage in one app**

   The included practice packs span primary, secondary, GCSE-level, and advanced maths. This is a stronger proposition than a single-age worksheet app.

2. **Large offline question library**

   The packaged registry exposes a merged library of `47,419` questions. Practice sessions load from bundled assets, so core practice does not depend on connectivity.

3. **Focused practice sessions with immediate feedback**

   Learners can select a stage, choose `10`, `20`, or `30` questions, answer MCQs, check results immediately, and view explanations where available.

4. **Topic-led discovery**

   The Topics screen presents a clear progression from number and fractions through algebra, geometry, statistics, trigonometry, and calculus.

5. **Child-oriented privacy stance**

   The repository consistently positions the product around minimal data, no advertising, optional parent email, and privacy controls.

6. **Multilingual and multi-market foundation**

   The UI already supports English, German, French, Italian, and Korean, with an architecture for additional country shells and locale-specific content routing.

### USPs To Use Only After Completion

- Live AI tutoring
- Personalized weakness detection
- Persistent progress analytics
- Parent progress reports
- Teacher dashboards or school administration
- GCSE Foundation, GCSE Higher, and Oxford Track premium packs
- Timed challenge and exam simulator behavior distinct from ordinary practice
- Fully localized question content for every configured market

## 2. Difficult-To-Copy Features

### Defensible Assets

1. **The content-production pipeline**

   The repository is not only an app UI. It contains raw generated banks, verified outputs, SymPy reports, rejects, audit exports, and remediation scripts. Building a repeatable maths-content pipeline with quality controls is harder to copy than building a quiz screen.

2. **Breadth across school stages**

   Competitors can copy isolated exercises quickly. Reproducing tens of thousands of structured questions across KS2-KS5, with stage, skill, difficulty, answer mapping, and explanation fields, is materially harder.

3. **Local-first delivery**

   Bundled packs reduce dependence on reliable internet access, lower backend cost, and make the product suitable for homes and schools with inconsistent connectivity.

4. **Market-aware architecture**

   The market registry separates UI market, UI locale, and content locale. This creates a practical foundation for national deployments without forking the entire application.

5. **Practice-context tutor design**

   The tutor UI can receive the active question context and offer targeted actions such as hint, explain, and check mistake. The current response engine is local and mocked, but the interaction design is a useful foundation for a future tutoring service.

### Important Caveat

The content moat is promising but not ready for an unqualified quality claim. The current audit found exponent-formatting issues, duplicate options, and placeholder questions. The remediation scripts exist, but production packs should be patched and revalidated before promoting "fully verified" or "exam-ready" language.

## 3. Play Store Screenshot Priorities

Use screenshots that show working product value. Avoid premium checkout, analytics, admin, and live-AI claims until those features are complete.

| Priority | Screen | Suggested Caption | Why It Matters |
| ---: | --- | --- | --- |
| 1 | Practice question after answer check | **Get instant feedback and clear explanations** | Shows the core learning loop |
| 2 | Practice setup | **Choose your level and start a focused session** | Shows KS2-KS5 range and flexible session length |
| 3 | Exam Packs screen | **Practice from primary maths through KS5** | Makes breadth concrete |
| 4 | Topics screen | **Build confidence topic by topic** | Shows algebra, geometry, statistics, calculus, and progression |
| 5 | Tutor screen with practice-context banner | **Ask for a hint when you get stuck** | Shows contextual help without overstating live AI |
| 6 | Home dashboard | **Keep learning with goals, streaks, and clear next steps** | Communicates motivation and routine |
| 7 | Onboarding language selector | **A learning experience designed for your language** | Useful for Swiss and Korean listings |
| 8 | Privacy & Data screen | **No advertising. Minimal data. Built for learners.** | Strong parent-facing trust signal |

### Screenshot Production Notes

- Capture a real corrected question with a non-empty explanation.
- Use KS2-KS5 labels only where appropriate for the UK listing.
- For non-UK listings, avoid implying that English question packs are localized until localized content is shipped.
- Do not feature Oxford Track, GCSE premium packs, tutor credits, or detailed analytics as available purchases yet.
- Do not label the current tutor as "AI-powered" in store screenshots.

## 4. Features That Could Appeal To Schools

### Available Or Nearly Available

- Offline practice sessions suitable for classroom devices and homework
- KS2-KS5 curriculum-stage switching
- Topic-led practice across foundational and advanced maths
- Session lengths of `10`, `20`, or `30` questions
- Immediate marking and explanation display
- No-advertising positioning
- Multi-market and multilingual UI foundation

### High-Value School Roadmap

- Teacher dashboard with class-level progress
- Assignment creation by stage, topic, and difficulty
- Managed learner profiles and roster import
- School-wide content-pack distribution
- Exportable attainment and intervention reports
- Safeguarding controls for tutor interactions
- Curriculum mapping by market and exam board

### School Positioning

Use:

> Structured offline maths practice that can support classroom reinforcement and independent study.

Avoid:

> Teacher analytics, assignments, or intervention dashboards are available today.

The current `AdminConsoleScreen` is a placeholder.

## 5. Features That Could Appeal To Parents

### Available Or Nearly Available

- Broad age range in one app
- Quick practice sessions that fit daily routines
- Immediate feedback after each answer
- Explanations where available
- Daily-goal and streak-oriented UI
- Optional parent or guardian onboarding path
- Privacy screen emphasizing minimal data and no advertising
- Offline practice without constant connectivity

### High-Value Parent Roadmap

- Verified parent progress emails
- Multiple child profiles
- Weekly progress summaries
- Weakness alerts and suggested revision topics
- Parent-controlled study goals
- Subscription controls and purchase approvals

### Parent Positioning

Use:

> A privacy-conscious maths practice app designed to help learners build a consistent study habit.

Avoid claiming parent reports are active. The onboarding email field is present, but report delivery is not implemented.

## 6. Features That Could Appeal To Government Education Departments

### Strategic Strengths

1. **Offline and low-bandwidth suitability**

   Local question packs are relevant to equitable-access programmes, device deployments, and regions with inconsistent connectivity.

2. **National localization architecture**

   The market registry supports country-specific UI shells, locales, and future content packs. This is a useful basis for curriculum localization.

3. **Repeatable content governance pipeline**

   Raw generation, symbolic verification, reject handling, auditing, remediation exports, backups, and post-patch validation are visible in the repository. This can become an auditable content-governance story.

4. **Privacy-first product direction**

   The current design avoids advertising and emphasizes minimal data collection. This aligns with child-safety expectations, subject to legal review and implementation verification.

5. **Broad attainment range**

   KS2-KS5 coverage makes the platform relevant across multiple school phases.

### Required Before Government Procurement Claims

- Complete legal review for each jurisdiction
- Publish final privacy policy and data-processing terms
- Complete accessibility implementation and testing
- Add administrative controls and reporting
- Establish content-review ownership and release sign-off
- Patch and revalidate question banks
- Produce curriculum-mapping evidence for each market
- Document hosting, support, incident response, retention, and deletion processes

### Government Positioning

Use:

> A local-first maths learning platform with configurable market support and an auditable content pipeline.

Avoid claiming regulatory certification, national curriculum alignment outside the implemented UK structure, or completed accessibility compliance.

## Claims Boundary

### Safe To Highlight Now

- Bundled offline maths practice
- KS2-KS5 stage selection
- Large question-pack inventory
- Immediate MCQ feedback
- Explanation display where available
- Topic browsing
- Multilingual UI foundation
- No-advertising product direction
- Privacy and data-control screens

### Show As Roadmap Or Early Access

- Oxford Track
- GCSE Foundation and Higher premium packs
- Tutor credits
- Live AI tutoring
- Deep mistake analysis
- Persistent progress analytics
- Weakness detection
- Parent reports
- Push reminders
- Multiple learner profiles
- Teacher and school dashboards

### Do Not Claim Yet

- Every question is verified
- Every configured market has localized question content
- Full GDPR, COPPA, PIPA, or accessibility compliance
- Exam simulator timing or exam-specific behavior
- Personalized recommendations based on learner history
- Production-ready parent monitoring

## Recommended Marketing Focus

### Play Store Short Description

> Offline maths practice from KS2 to KS5 with focused sessions, instant feedback, and no ads.

### Parent-Focused Message

> Build a daily maths habit with quick practice sessions, clear feedback, and a privacy-conscious experience.

### School-Focused Message

> Structured maths practice for classroom reinforcement and independent study, with offline-ready content from KS2 to KS5.

### Government-Focused Message

> A configurable local-first learning platform with broad maths coverage and an auditable path from content generation to validation.

## Recommended Next Marketing Actions

1. Apply the generated question-bank patch scripts and run validation before screenshot capture.
2. Capture the first five Play Store screenshots around the working practice loop, not roadmap features.
3. Replace generic or static dashboard values with persisted learner data before making progress claims.
4. Decide whether the tutor should be marketed as contextual help or upgraded to a real tutoring backend before using AI language.
5. Complete locale-specific question packs before launching non-English listings.
6. Publish legally reviewed privacy documents before using compliance language in procurement material.
