# Android Pixel Launch Fix

## Status

**BLOCKER for live Pixel validation**

The Android launcher package alignment is correct and the cleaned project rebuilds a debug APK. The remaining blocker is that Flutter/ADB cannot currently see Pixel 6a device `23291JEGR05756`, so the requested `flutter run -d 23291JEGR05756` launch check could not be completed in this session.

## Root Cause

The reported crash:

```text
java.lang.ClassNotFoundException:
Didn't find class "com.quantumlab.mathtutor.gb.MainActivity"
```

occurs when Android resolves the manifest launcher activity to `com.quantumlab.mathtutor.gb.MainActivity`, but the compiled Kotlin `MainActivity` class is in a different package.

The production package is:

```text
com.quantumlab.mathtutor.gb
```

With `android:name=".MainActivity"` in the manifest, Android expects:

```text
com.quantumlab.mathtutor.gb.MainActivity
```

## Current Alignment

Inspected files now align:

- `android/app/build.gradle.kts`
  - `namespace = "com.quantumlab.mathtutor.gb"`
  - `applicationId = "com.quantumlab.mathtutor.gb"`
- `android/app/src/main/AndroidManifest.xml`
  - launcher activity is `android:name=".MainActivity"`
- `android/app/src/main/kotlin/com/quantumlab/mathtutor/gb/MainActivity.kt`
  - Kotlin package is `package com.quantumlab.mathtutor.gb`

Current `MainActivity.kt`:

```kotlin
package com.quantumlab.mathtutor.gb

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
```

## Changed Files

No additional Android package changes were required in this pass because the namespace, application ID, manifest activity, Kotlin path, and Kotlin package already match.

Existing fixed Android activity:

- `android/app/src/main/kotlin/com/quantumlab/mathtutor/gb/MainActivity.kt`

Report updated:

- `ANDROID_PIXEL_LAUNCH_FIX.md`

## Validation

- `flutter clean`: **PASS**
- `flutter pub get`: **PASS**
- `flutter analyze`: **PASS**
  - `No issues found!`
- `flutter test --reporter compact`: **PASS**
  - `All tests passed!`
- `flutter build apk --debug`: **PASS**
  - Built `build/app/outputs/flutter-apk/app-debug.apk`
- `flutter run -d 23291JEGR05756`: **BLOCKED**
  - Flutter reported no supported device with ID `23291JEGR05756`.
  - Visible devices were Windows desktop, Chrome, and Edge only.
  - Retried with elevated ADB/Flutter access; the Pixel device was still not visible.

## PASS/BLOCKER

**Package alignment and rebuild: PASS**

**Live Pixel 6a launch validation: BLOCKER**

Blocker reason: Pixel 6a device `23291JEGR05756` is not currently visible to Flutter/ADB from this environment.
