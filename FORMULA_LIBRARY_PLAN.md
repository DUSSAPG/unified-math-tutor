# Formula Library — Plan & Implementation Notes

## Goal

A lightweight, free, offline reference of key school-maths formulas. Explicitly **not** a Tutor
replacement — no AI, no network calls, English-only for v1.

## Architecture

Follows the same pattern already established by `TopicCatalogService` (`lib/services/
topic_catalog_service.dart`) for consistency with the rest of the codebase:

- **Asset:** `assets/config/formula_catalog.json` — already covered by the existing
  `assets/config/` wildcard entry in `pubspec.yaml`, so no packaging changes were needed.
- **Service:** `lib/services/formula_library_service.dart` — singleton, lazy-loads and caches the
  JSON on first use, validates every field on load (throws `FormatException` with a specific message
  if a required field is missing/wrong-typed, same convention as `TopicCatalogService`). Exposes
  `load()`, `categories()`, and `search(query, {category})`.
- **Screen:** `lib/screens/formulas/formula_library_screen.dart` — search bar + horizontal category
  chips + a single scrollable list of expandable cards (title/formula always visible; tapping a card
  expands to reveal meaning, variables, a plain-language explanation, and a worked example). No
  separate detail route — kept to one screen to stay "lightweight."
- **Entry point:** one new card on the Home screen (`_FormulaLibraryCard` in `home_shell.dart`),
  matching the existing Mental Math Vault card's visual style. Route: `/formulas`.
- **Test:** `test/formula_library_service_test.dart` validates every catalog entry is well-formed
  (non-empty required fields, unique ids) and that search/category filtering behaves correctly.

## Data Model

```json
{
  "id": "pythagoras_theorem",
  "category": "Pythagoras",
  "title": "Pythagoras' Theorem",
  "formula": "a² + b² = c²",
  "meaning": "Relates the three sides of a right-angled triangle.",
  "variables": [
    { "symbol": "a, b", "meaning": "The two shorter sides" },
    { "symbol": "c", "meaning": "The hypotenuse (longest side, opposite the right angle)" }
  ],
  "explanation": "The square of the hypotenuse equals the sum of the squares of the other two sides.",
  "example": "A right triangle has sides 3 cm and 4 cm. c² = 3² + 4² = 25, so c = 5 cm."
}
```

## Current Content (v1)

30 formulas across 11 categories:

| Category | Formulas included |
|---|---|
| Area | Rectangle, Triangle, Parallelogram, Trapezium |
| Volume | Cuboid, Cylinder, Sphere, Cone |
| Fractions | Adding, Multiplying, Dividing |
| Percentages | Percentage of an amount, Percentage change |
| Algebra | Difference of two squares, Perfect square expansion, Quadratic formula |
| Pythagoras | Pythagoras' theorem |
| Circle | Circumference, Area, Arc length |
| Trigonometry | SOHCAHTOA, Sine rule, Cosine rule |
| Coordinate Geometry | Gradient, Distance between two points, Midpoint |
| Probability | Basic probability, Combined probability (AND, independent) |
| Statistics | Mean, Range |

## Why This Shape

- **JSON + validated loader** matches the exact pattern already trusted elsewhere in the app
  (`topic_catalog_service.dart`, `mental_math_tricks_service.dart`), so there's no new architectural
  concept to learn or maintain.
- **Single-screen, expandable-card UI** avoids adding a new navigation concept (no detail route, no
  extra back-stack entries) — consistent with "keep it lightweight."
- **English-only for v1** avoids the locale-fallback complexity that the rest of the app's l10n system
  carries; this can be added later by giving `FormulaEntry` a `locales` map the same way
  `TopicCatalogService` does, without changing the JSON's top-level shape.

## Future Extensions (not built, intentionally deferred)

- Locale support (same pattern as `topic_catalog.json`'s `locales` map per entry).
- Linking a formula card to relevant Practice topics/questions.
- Bookmark/favorite formulas.
- Printable/exportable cheat-sheet (mirroring the existing `ParentReportService` PDF export pattern).
