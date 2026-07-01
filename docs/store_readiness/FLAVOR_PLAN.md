# App Flavor Plan

## Overview

Three Flutter flavors map to three distinct store listings. Each flavor shares the same codebase; market-specific behavior is driven by locale defaults and l10n ARB files.

| Flavor | Package ID | Default Locale | App Name |
|---|---|---|---|
| `gb` | `com.quantumlab.mathtutor.gb` | `en_GB` | Sterling Math |
| `ch` | `com.quantumlab.mathtutor.ch` | `de_CH` | Sterling Math |
| `kr` | `com.quantumlab.mathtutor.kr` | `ko_KR` | Sterling Math Korea |

## Status

| Step | GB | CH | KR |
|---|---|---|---|
| ARB locale files | ✅ `en_GB` | ✅ `de_CH` / `fr_CH` / `it_CH` | ✅ `ko_KR` |
| `pubspec.yaml` locale list | ✅ | ✅ | ✅ |
| Android product flavors | ⏳ TODO | ⏳ TODO | ⏳ TODO |
| iOS schemes/targets | ⏳ TODO | ⏳ TODO | ⏳ TODO |
| Launcher icon per flavor | ⏳ TODO | ⏳ TODO | ⏳ TODO |
| Splash screen per flavor | ⏳ TODO | ⏳ TODO | ⏳ TODO |
| Store listing copy | ⏳ TODO | ⏳ TODO | ⏳ TODO |
| Screenshots uploaded | ⏳ TODO | ⏳ TODO | ⏳ TODO |

## Implementation Notes

### Flutter Flavor Entry Points (TODO)

Create `lib/main_gb.dart`, `lib/main_ch.dart`, `lib/main_kr.dart`:

```dart
// lib/main_gb.dart
import 'main.dart' as app;
void main() => app.main(flavor: 'gb');
```

### Locale Override per Flavor (TODO)

Pass a `defaultLocale` to `MaterialApp` based on flavor so the app defaults to the right language on first launch, before the user changes it.

### Build Commands (TODO)

```bash
# GB debug APK
flutter build apk --debug --flavor gb -t lib/main_gb.dart

# CH debug APK  
flutter build apk --debug --flavor ch -t lib/main_ch.dart

# KR release AAB
flutter build appbundle --release --flavor kr -t lib/main_kr.dart
```

### Current Build (no flavors wired)

```bash
flutter build apk --debug   # builds default, no flavor suffix
```

## Flavor Differences Summary

| Feature | GB | CH | KR |
|---|---|---|---|
| Curriculum tracks shown | KS2–KS5, GCSE | Standard, Premium | Korean stages |
| Onboarding stage labels | KS2/KS3/KS4/KS5 | KS2/KS3/KS4 | 10–12 / 13–15 / 16–20 |
| Oxford Track label | Oxford Track | Oxford Track | 옥스퍼드 트랙 |
| `onboardingShowLevelPicker` | `true` | `true` | `false` |
| Support email locale | English | DE/FR/IT | Korean |
