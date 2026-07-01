# Splash Screen Assets

This directory will contain splash screen assets.

## TODO: Splash Screen Setup

To configure the splash screen:
1. Add `flutter_native_splash` to `dev_dependencies` in `pubspec.yaml`
2. Place the splash logo at `assets/splash/logo.png` (recommended: 192×192 px)
3. Add configuration to `pubspec.yaml`:
   ```yaml
   flutter_native_splash:
     color: "#0B1120"
     image: assets/splash/logo.png
     android_12:
       image: assets/splash/logo.png
       color: "#0B1120"
   ```
4. Run: `flutter pub run flutter_native_splash:create`

## Design Notes
- Background: `#0B1120` (app dark navy)
- Logo: MathTutor wordmark or icon mark in white / `#5B8EFF`
