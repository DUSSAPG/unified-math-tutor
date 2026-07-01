# Package Identity Plan

## Application IDs

| Market | Android Package ID | iOS Bundle ID | Store Target |
|---|---|---|---|
| UK / GB | `com.quantumlab.mathtutor.gb` | `com.quantumlab.mathtutor.gb` | Google Play (UK) / App Store (GB) |
| Switzerland | `com.quantumlab.mathtutor.ch` | `com.quantumlab.mathtutor.ch` | Google Play (CH) / App Store (CH) |
| South Korea | `com.quantumlab.mathtutor.kr` | `com.quantumlab.mathtutor.kr` | Google Play (KR) / App Store (KR) |

## Per-Market Details

### GB — United Kingdom
- **Package:** `com.quantumlab.mathtutor.gb`
- **Default locale:** `en_GB`
- **Curriculum:** KS2 · KS3 · KS4 (GCSE) · KS5
- **Store region:** Google Play — United Kingdom; App Store — United Kingdom
- **Age rating:** 4+ (Play) / 4+ (App Store)
- **Content:** GCSE exam packs, Oxford Track

### CH — Switzerland
- **Package:** `com.quantumlab.mathtutor.ch`
- **Default locale:** `de_CH` (also supports `fr_CH`, `it_CH`)
- **Curriculum:** Standard track adapted for Swiss curriculum
- **Store region:** Google Play — Switzerland; App Store — Switzerland
- **Age rating:** 4+ (Play) / 4+ (App Store)
- **Content:** Standard + premium tracks

### KR — South Korea
- **Package:** `com.quantumlab.mathtutor.kr`
- **Default locale:** `ko_KR`
- **Curriculum:** Korean school stages (10–12, 13–15, 16–20)
- **Store region:** Google Play — South Korea; App Store — South Korea
- **Age rating:** 4+ (Play) / 4+ (App Store)
- **Content:** Korean curriculum tracks, Suneung prep

## Android `applicationId` Wiring (TODO)

In `android/app/build.gradle`, add product flavors:

```groovy
flavorDimensions "market"
productFlavors {
    gb {
        dimension "market"
        applicationId "com.quantumlab.mathtutor.gb"
        resValue "string", "app_name", "Sterling Math"
    }
    ch {
        dimension "market"
        applicationId "com.quantumlab.mathtutor.ch"
        resValue "string", "app_name", "Sterling Math"
    }
    kr {
        dimension "market"
        applicationId "com.quantumlab.mathtutor.kr"
        resValue "string", "app_name", "Sterling Math Korea"
    }
}
```

## iOS Bundle ID Wiring (TODO)

In Xcode, create three targets or schemes under `Runner`:
- `Runner-GB` → Bundle ID `com.quantumlab.mathtutor.gb`
- `Runner-CH` → Bundle ID `com.quantumlab.mathtutor.ch`
- `Runner-KR` → Bundle ID `com.quantumlab.mathtutor.kr`

## Signing (TODO)

- Android: generate separate `.jks` keystores per flavor, or use a single shared keystore with different aliases.
- iOS: register each Bundle ID in Apple Developer Portal; create App Store Connect records before first upload.

## Pre-release Checklist

- [ ] Register `com.quantumlab.mathtutor.gb` on Google Play Console
- [ ] Register `com.quantumlab.mathtutor.ch` on Google Play Console
- [ ] Register `com.quantumlab.mathtutor.kr` on Google Play Console
- [ ] Register all three Bundle IDs in Apple Developer Portal
- [ ] Create App Store Connect app records for each
- [ ] Confirm package IDs are not already taken on both stores
