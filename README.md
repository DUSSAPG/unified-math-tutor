# unified_math_tutor

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Topic localization

Topic card titles/subtitles are served from
`assets/config/topic_catalog.json`, not from pack labels or Dart display
constants. The catalog supports `en`, `en-GB`, `fr-CH`, `de-CH`, and `it-CH`
with language fallback before English fallback.

Maintenance commands:

```powershell
py scripts\topic_catalog.py export-template
py scripts\topic_catalog.py apply reports\topic_labels_template.csv
py scripts\topic_catalog.py check-no-english-leaks
```
