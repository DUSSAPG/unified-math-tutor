# Release Build Notes

## Current Build Status

| Build Type | Command | Status | Date |
|---|---|---|---|
| Debug APK | `flutter build apk --debug` | ✅ Tested | 2026-05-23 |
| Release APK | `flutter build apk --release` | ⏳ Pending | — |
| Release AAB | `flutter build appbundle --release` | ⏳ Pending | — |
| iOS `.ipa` | `flutter build ipa --release` | ⏳ Pending | — |

## Debug APK Validation (Batch 1–4)

Confirmed passing after each batch:

| Batch | Focus | `flutter analyze` | `flutter build apk --debug` |
|---|---|---|---|
| Batch 1 | Core l10n foundation | ✅ No issues | ✅ Built |
| Batch 2 | UI polish + l10n wiring | ✅ No issues | ✅ Built |
| Batch 3 | App-store polish | ✅ No issues | ✅ Built |
| Batch 4 | Store shell docs | ✅ No issues | ✅ Built |

## Release Build Prerequisites (TODO)

Before building a signed release:

### Android
- [ ] Generate production keystore: `keytool -genkey -v -keystore upload.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000`
- [ ] Add keystore config to `android/key.properties` (do **not** commit this file)
- [ ] Update `android/app/build.gradle` to reference `key.properties`
- [ ] Set `minSdkVersion`, `targetSdkVersion`, `compileSdkVersion` to current Play Store requirements
- [ ] Verify `android/app/src/main/AndroidManifest.xml` permissions are minimal
- [ ] Enable R8/ProGuard if needed: `buildTypes { release { minifyEnabled true } }`

### iOS
- [ ] Create App Store distribution certificate in Apple Developer Portal
- [ ] Create provisioning profile for each Bundle ID
- [ ] Set `IPHONEOS_DEPLOYMENT_TARGET` to ≥ 12.0
- [ ] Configure `ExportOptions.plist` for App Store submission

### Both Platforms
- [ ] Remove all `debugPrint()` calls or wrap in `kDebugMode`
- [ ] Set `flutter run --release` and test on physical device
- [ ] Verify no hardcoded dev/staging URLs remain

## Release APK Command (when ready)

```bash
flutter build apk --release --split-per-abi
```

Produces three APKs (armeabi-v7a, arm64-v8a, x86_64) for Play Store upload or direct distribution.

## Release AAB Command (Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Version Bump Checklist

Before each store release, update in `pubspec.yaml`:

```yaml
version: 1.0.0+1   # format: <semver>+<build-number>
```

- Increment `+1` for every Play Store / App Store upload.
- Increment `1.0.x` for patch releases.
- Increment `1.x.0` for minor feature releases.

## Known Pending Items Before Release

- Launcher icons not yet generated (see `assets/icons/README.md`)
- Splash screen not yet configured (see `assets/splash/README.md`)
- Android product flavors not wired (see `FLAVOR_PLAN.md`)
- Privacy policy URL not yet live (see `docs/legal/PRIVACY_POLICY.md`)
- Terms of use URL not yet live (see `docs/legal/TERMS_OF_USE.md`)
- `support@mathtutor.app` email must be active before store submission
