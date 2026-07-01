# Launcher Icons

This directory will contain the app launcher icon assets.

## TODO: Launcher Icon Setup

To configure launcher icons:
1. Add `flutter_launcher_icons` to `dev_dependencies` in `pubspec.yaml`
2. Place source icon (1024×1024 px, PNG) at `assets/icons/icon.png`
3. Add configuration to `pubspec.yaml`:
   ```yaml
   flutter_launcher_icons:
     android: true
     ios: true
     image_path: "assets/icons/icon.png"
   ```
4. Run: `flutter pub run flutter_launcher_icons`

## Design Notes
- Background: `#0B1120` (app dark navy)
- Foreground: Math symbol or `Σ` glyph in `#5B8EFF` (accent blue)
- Style: rounded corners (Android adaptive icon), no padding for iOS
