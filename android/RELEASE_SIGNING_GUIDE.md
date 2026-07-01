# Android Release Signing Guide

**Status:** Gradle release signing is wired to `android/key.properties`.
The private upload keystore and local properties file are still required before
the first Play Store upload.

---

## 1. Generate the Upload Keystore

Run once on a secure machine. Store the output file **outside** the repository.

```bash
keytool -genkey -v \
  -keystore upload.jks \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

You will be prompted for:
- Keystore password (save this securely)
- Key alias password (can be the same)
- Distinguished Name fields (organisation, country, etc.)

**Recommended location:** `~/.android/upload.jks` or a secrets manager (e.g. GitHub Actions Secrets, 1Password).

> **Never commit `upload.jks` or its passwords to the repository.**

---

## 2. Create `android/key.properties`

Create this file manually. It is already listed in `.gitignore` (add it if not).

```properties
storePassword=<keystore-password>
keyPassword=<key-password>
keyAlias=upload
storeFile=<absolute-path-to-upload.jks>
```

Example:
```properties
storePassword=s3cr3t
keyPassword=s3cr3t
keyAlias=upload
storeFile=/Users/yourname/.android/upload.jks
```

> **Do not commit this file.** Add `android/key.properties` to `.gitignore`.

---

## 3. Gradle Wiring

This repository is already wired to load `android/key.properties` and use the
`release` signing configuration. Release builds fail explicitly when the file
or a required property is missing. The expected configuration is:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

---

## 4. Set Production `applicationId`

In `android/app/build.gradle.kts`, replace the placeholder:

```kotlin
defaultConfig {
    applicationId = "com.quantumlab.mathtutor.gb"  // or .ch / .kr per flavor
    // ...
}
```

See `docs/store_readiness/PACKAGE_ID_PLAN.md` for the full per-flavor package ID list.

---

## 5. Build Release AAB

Once signing is configured:

```bash
# Play Store upload (preferred)
flutter build appbundle --release

# Direct APK (QA / sideload)
flutter build apk --release --split-per-abi
```

Output:
- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APKs: `build/app/outputs/flutter-apk/app-release-arm64-v8a.apk` (etc.)

---

## 6. CI / GitHub Actions

For automated signing in CI, pass secrets as environment variables and write `key.properties` at build time:

```yaml
- name: Create key.properties
  run: |
    echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD }}"       >> android/key.properties
    echo "keyAlias=upload"                               >> android/key.properties
    echo "storeFile=$RUNNER_TEMP/upload.jks"             >> android/key.properties

- name: Decode keystore
  run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > $RUNNER_TEMP/upload.jks
```

---

## 7. Google Play App Signing

Google Play uses **two keys**:
- **Upload key** — the key you generate and use to sign the AAB before upload.
- **App signing key** — managed by Google; used to re-sign the final APK delivered to devices.

When you first upload an AAB, Google Play will prompt you to opt in to Play App Signing. Recommended: opt in, and keep your upload key separate from the app signing key.

---

## Checklist

- [ ] Keystore generated and stored securely (not in repo)
- [ ] `android/key.properties` created and added to `.gitignore`
- [x] `build.gradle.kts` updated with `signingConfigs.release`
- [ ] `applicationId` changed from `com.example.unified_math_tutor` to production ID
- [ ] Release AAB builds without error
- [ ] AAB uploaded to Play Console Internal Testing track first
