# Swiss terminology guidance (de-CH, fr-CH, it-CH)

**Status: DRAFT, PENDING LINGUISTIC REVIEW.** This guidance has not been approved by a native speaker or a Swiss mathematics educator. It records the conventions used for the Swiss Phase 2 drafts so that reviewers can accept, change or reject each one consistently. It is not an approval record and does not unblock the production gate.

Scope: `lib/l10n/app_de_CH.arb`, `app_fr_CH.arb` and `app_it_CH.arb`. Base files (`app_de.arb`, `app_fr.arb`, `app_it.arb`) are the fallback and are not changed by Phase 2.

Each rule has an ID (`G-…`). Review packages cite these IDs. Open decisions are marked **OPEN** and listed in [Open decisions](#open-decisions).

## G-1 Curriculum identity: England stays England

The app teaches the curriculum of **England**. Swiss copy must say so and must not invent Swiss equivalents.

| Rule | de-CH | fr-CH | it-CH |
|---|---|---|---|
| G-1a: GCSE stays "GCSE". Never "Kantonalprüfung", "Examen cantonal", "Matura" or "Maturité". | GCSE | GCSE | GCSE |
| G-1b: GCSE tiers keep their English names. | GCSE Foundation / GCSE Higher | GCSE Foundation / GCSE Higher | GCSE Foundation / GCSE Higher |
| G-1c: Key Stage labels keep "KS" and "Year" and name England. Never "Primarstufe", "Sekundarstufe", "Cycle", "Scuola media" or similar. | KS2 (Year 3–6, England) | KS2 (Year 3–6, Angleterre) | KS2 (Year 3–6, Inghilterra) |
| G-1d: A-Level stays "A-Level". | A-Level | A-Level | A-Level |
| G-1e: A curriculum reference names England. | englischer Lehrplan | programme anglais | programma inglese |
| G-1f: "11+" and "independent schools" refer to English schools and must say so. | Aufnahmeprüfungen englischer Privatschulen (Independent Schools) | examens d'entrée des écoles indépendantes anglaises (independent schools) | esami di ammissione alle scuole indipendenti inglesi (independent schools) |

These labels are display copy only. **Do not change curriculum mappings,** stage IDs, pack IDs or question tags (`assets/config/curriculum_manifest.json`, the stage packs and `lib/core/practice_topic_mapping.dart`). Phase 2 changed none of them.

## G-2 Oxford Track: no endorsement, no admission promise

"Oxford Track" is a product name for an Oxford-*style* course of challenge material. It is not run, endorsed or accredited by the University of Oxford, and it does not lead to admission.

| | de-CH | fr-CH | it-CH |
|---|---|---|---|
| Product name | Oxford-Track | Parcours Oxford | Percorso Oxford |
| "Oxford-style" | im Oxford-Stil | de style Oxford | in stile Oxford |

**Never use:**

- "Oxford-Lehrplan", "programme Oxford" or "programma di Oxford" (these suggest an official curriculum);
- "Oxford-Vorbereitung", "préparation à Oxford" or "preparazione per Oxford" (these suggest admission preparation);
- any wording that suggests partnership, certification or admission.

**English-source issue, out of scope:** the English template says "Oxford curriculum track" in some places. Phase 2 did not translate that implication. The product owner should review the English wording.

## G-3 Spelling and characters

| Rule | Detail |
|---|---|
| G-3a de-CH: no ß | Always "ss" (grösser, Ausreisser, einschliesslich). |
| G-3b de-CH: real umlauts | Use ä ö ü Ä Ö Ü, never the digraphs ae oe ue. Real "ue" words such as "neue", "aktuell" and "zueinander" are not changed. |
| G-3c fr-CH: full accents | Use é è ê à â î ô û ç and capital accents: "Égal", "À", "Échanger". |
| G-3d fr-CH: 1990 reform spellings | **OPEN (D-5).** Existing copy mixes "Entrainement" and "Entraînement". Pick one convention. |
| G-3e it-CH: final accents | Use più, può, ciò, finché, giù, metà, velocità, è. "e" (and) vs "è" (is) is decided by meaning. "po'" is correct and is not an accent error. |
| G-3f Dashes | Keep the en dash "–" or em dash "—" as the existing locale file uses it. Do not add new dash styles. |

## G-4 fr-CH punctuation on mobile

**Convention (subject to review, OPEN D-4):** a non-breaking space (U+00A0) before `? ! : ;`. For example, `Essaie : fais glisser…`.

- The non-breaking space keeps the mark from wrapping onto a new line on narrow phone screens.
- Swiss French often uses a thin non-breaking space (U+202F) or no space before `? ! ;`. The reviewer may choose either, but the same rule must apply in every fr-CH string.
- Phase 2 applied U+00A0 to every fr-CH value it wrote. Existing values that it did not touch may still differ. This is listed in the P1 review batch.

## G-5 Notation, numbers and placeholders

| Rule | Detail |
|---|---|
| G-5a: Placeholders | Every `{placeholder}` in the English source must appear unchanged. ICU `plural`/`select` structures must stay valid. The apply script and `scripts/check_enabled_l10n.py` enforce this. |
| G-5b: Notation | Keep `=`, `×`, `÷`, `<`, `>`, `/`, `°`, `m/s`, `km`, `tan(…)`, `y = mx + c` and fraction slashes ("3/4") exactly as in English. |
| G-5c: Decimal separator | **OPEN (D-3).** The app formats numbers with a decimal point ("6.4", "0.01"), and the existing Swiss copy follows that. Swiss school practice in de-CH and it-CH often uses a point, and fr-CH often a comma. Phase 2 keeps the point, so the text matches the numbers the app draws on screen. Changing it needs an engineering decision because the figures are not localised, not just a copy change. |
| G-5d: Numbers in words | Only where the English uses words ("three eighths" becomes "drei Achtel", "trois huitièmes", "tre ottavi"). |

## G-6 Product and mode names

| English | de-CH | fr-CH | it-CH | Note |
|---|---|---|---|---|
| Math Intelligence | Math Intelligence | Math Intelligence | Math Intelligence | Brand. Never translated. |
| Math Studio, Maths Journey, Learning Analytics, Family Studio, Football Studio, Adaptive Learning Intelligence, Captain Math, Flight Path Lab | unchanged | unchanged | unchanged | Existing accepted convention. |
| Journey (nav) | Journey ("Deine Journey") | as the existing copy | as the existing copy | Existing accepted copy. |
| Nyepi (Quiet Study mode inspiration) | Nyepi | Nyepi | Nyepi | G-6a: keep the name and its explanation as "a Balinese tradition". Do not translate it as "Ruhetag" or similar. |
| Family Maths | Familien-Mathe | Maths en famille | Matematica in famiglia | Accepted. |
| Recall Cards | Merkkarten | Cartes mémo | Schede mnemoniche | Accepted. |
| Formula Library | Formelsammlung | Formulaire | Formulario | |
| Panda Portions | Panda Portions | Panda Portions | Panda Portions | **OPEN (D-6)**, P1 only: keep the English name or translate it. |

## G-7 Mathematical terms (school register)

| English | de-CH | fr-CH | it-CH |
|---|---|---|---|
| fraction / numerator / denominator | Bruch / Zähler / Nenner | fraction / numérateur / dénominateur | frazione / numeratore / denominatore |
| equivalent fractions | gleichwertige Brüche | fractions équivalentes | frazioni equivalenti |
| unit fraction (P1 proposal) | Stammbruch | fraction unitaire | frazione unitaria |
| number line | Zahlenstrahl | droite numérique | retta numerica |
| ones / tens / hundreds (place value) | Einer / Zehner / Hunderter | unités / dizaines / centaines | unità / decine / centinaia |
| tenths / hundredths | Zehntel / Hundertstel | dixièmes / centièmes | decimi / centesimi |
| place value | Stellenwert | valeur de position | valore posizionale |
| bead (abacus) | Perle | boule | pallina |
| mean / median / outlier | Mittelwert / Median / Ausreisser | moyenne / médiane / valeur aberrante* | media / mediana / valore anomalo |
| bearing / heading | Peilung / Kurs | relèvement* / cap | rilevamento* / rotta |
| net (of a cube) | Netz | patron | sviluppo |
| Fluency (ratio ladder rung) | Automatisieren | Automatisation | Consolidamento |

\* Existing values that the reviewer should confirm. "Fluency" is **OPEN (D-7)**: there is no single standard school term, and the reviewer should confirm the rung name.

## G-8 Address and register

- Learner-facing copy uses the informal address: du / tu / tu.
- Parent-facing copy: **OPEN (D-8).** Most existing parent copy uses du / tu. Some newer strings use Sie / vous / voi. The reviewer should choose one register for parent screens.
- Gender: prefer neutral phrasing over masculine-only forms ("Envie d'un nouveau défi ?" rather than "Prêt pour…"). Reviewers should flag any masculine-only learner address.

## G-9 Strings assembled at runtime

Some strings are built from fragments, for example a fraction unit plus a direction word. The number-sense lab is the main case. Translators must review the fragment and its host string together. Grammar that cannot be expressed with plain placeholders (case, gender, plural agreement) needs an ICU `select`/`plural`, which is an engineering change. Such entries are flagged `COMPOSED` in the review packages and are not published in Phase 2.

## Open decisions

| ID | Decision | Owner | Blocks |
|---|---|---|---|
| D-1 | Swiss Gymnasium exam-pack label in fr-CH and it-CH ("Gymnase" or "Collège"? "Liceo"?). The cantonal names differ, and the pack is locked, so the label is not shown yet. | Swiss subject-matter reviewer | `practiceExamSwissGymnasium` fr/it (no draft written) |
| D-2 | Legal and commercial copy (`helpTermsBody`) needs legal review as well as linguistic review. | Product owner / legal | Production approval of that key |
| D-3 | Decimal separator (G-5c). | Product owner and engineering | Number-format localisation |
| D-4 | fr-CH space before `? ! : ;` (G-4). | fr-CH reviewer | All fr-CH entries |
| D-5 | fr-CH 1990 reform spellings (G-3d). | fr-CH reviewer | A few fr-CH entries |
| D-6 | Panda Portions activity name (G-6). | Product owner | P1 |
| D-7 | "Fluency" rung name (G-7). | Swiss maths educator | `ratioFoundationsRungFluency` |
| D-8 | Parent-screen register (G-8). | Reviewers in each locale | Parent copy |
| D-9 | English source: "Oxford curriculum track" wording, "Unified Math Tutor" in `footballStudioProgressOwnership`, and a missing plural in `familyStudioTutorCompletionLabel`. | Product owner (English copy) | The matching Swiss strings mirror the English |
