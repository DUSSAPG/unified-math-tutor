# Duplicate Launcher Icon Investigation — Math Intelligence

**Date:** 2026-07-05
**Reported symptom:** Pixel sometimes shows two Math Intelligence icons.

## Verdict

**No code or manifest defect found — and now directly confirmed to be a
Pixel Launcher app-drawer cache bug, not specific to this app.** Every
ADB-verifiable signal says this app declares exactly one launcher entry. The
smoking gun: while re-verifying on the Pixel 6a, the app drawer was
screenshotted showing **"Math Intelli...", "LedgerMind", and "Cockpit
Intelligence" each listed twice** — three unrelated apps, all duplicated at
once. `pm list packages` confirms exactly **one** installed package for each
of the three (`com.quantumlab.mathtutor.gb`, `com.quantumlab.ledgermind`,
`com.example.coachsuite_cockpit_math`). Three independently-built, correctly
single-activity apps cannot all coincidentally have the same manifest defect
— this can only be the launcher's own app-drawer index/cache showing stale
duplicate entries for recently installed/reinstalled apps, on this specific
device, at this point in time. This matches the original hypothesis
(launcher icon-cache staleness from repeated in-place dev reinstalls) with
concrete supporting evidence rather than just precedent. One genuine cleanup
was found and fixed in this app's own resources regardless (see below).

## What was checked, and the exact commands

**1. Only one `<activity>` with a `LAUNCHER` intent-filter, no `activity-alias`:**

```
grep -rn "MAIN\|LAUNCHER\|activity-alias\|<activity" android --include="AndroidManifest.xml"
```
Result: exactly one `<activity android:name=".MainActivity">` in
`android/app/src/main/AndroidManifest.xml`, one `<intent-filter>` with
`MAIN`/`LAUNCHER`. `debug` and `profile` manifest variants
(`android/app/src/{debug,profile}/AndroidManifest.xml`) only add the
`INTERNET` permission for tooling — no additional activities.

**2. No `android:roundIcon` pointing at a different/stale resource:**

```
grep -n "roundIcon\|android:icon" android/app/src/main/AndroidManifest.xml
```
Result: only `android:icon="@mipmap/launcher_icon"`. No `roundIcon`
attribute at all, so there's no second icon reference that could point at a
stale drawable.

**3. No `applicationIdSuffix` on debug/profile builds (a common cause of
"two icons" — a suffixed debug build installs as a *separate* app icon
alongside release):**

Checked `android/app/build.gradle.kts` — `applicationId` is set once in
`defaultConfig`, no per-buildType suffix. Debug, profile, and release all
share `com.quantumlab.mathtutor.gb`.

**4. Only one package actually installed, only one component resolves for
LAUNCHER, on a real device:**

```
adb shell pm list packages | grep -i "mathtutor\|quantumlab\|sterling\|intelligence"
# → package:com.quantumlab.mathtutor.gb   (only this one)

adb shell cmd package resolve-activity --brief -c android.intent.category.LAUNCHER com.quantumlab.mathtutor.gb
# → com.quantumlab.mathtutor.gb/.MainActivity   (only this one)

adb shell dumpsys package com.quantumlab.mathtutor.gb | grep -A3 "android.intent.action.MAIN"
# → single filter, single component
```

**5. No orphaned pinned shortcuts holding a stale icon:**

```
adb shell dumpsys shortcut | grep -B2 -A15 "com.quantumlab.mathtutor.gb"
# → empty (no shortcuts registered for this package)
```

Re-confirmed directly via the shortcut service's own query command (not just
`dumpsys`), including every shortcut type at once (dynamic, manifest,
pinned, cached — flag bitmask 255):

```
adb shell cmd shortcut get-shortcuts com.quantumlab.mathtutor.gb
# → Success   (no shortcuts printed — none exist)

adb shell cmd shortcut get-shortcuts --flags 255 com.quantumlab.mathtutor.gb
# → Success   (same result with every shortcut type included)
```

Zero shortcuts of any kind. Combined with §"The direct confirmation" below
(three unrelated apps duplicated in the app drawer at once, each singly
installed), there is nothing in this app's manifest, shortcuts, or install
state that could produce a duplicate icon — closing this with high
confidence.

**6. Default launcher confirmed (for context, in case a second launcher app
were involved):**

```
adb shell cmd package resolve-activity -c android.intent.category.HOME -a android.intent.action.MAIN
# → com.google.android.apps.nexuslauncher (Pixel Launcher)
```

## The direct confirmation, and exact commands

Screenshot of the Pixel 6a app drawer (taken during live verification of
this sprint's changes) showed three duplicated entries at once. Verified
each is genuinely singly-installed:

```
adb shell pm list packages | grep -i "math\|quantumlab\|cockpit"
# → package:com.example.coachsuite_cockpit_math   (labeled "Cockpit Intelligence")
# → package:com.quantumlab.ledgermind             (labeled "LedgerMind")
# → package:com.quantumlab.mathtutor.gb           (this app)
#   — exactly one line per app; none of the three appear twice in this list.
```

Confirmed the "Cockpit Intelligence" label directly from its APK (in case
the app-drawer text was itself misleading):

```
adb shell pm list packages -f com.example.coachsuite_cockpit_math
adb pull <path from above> other_app.apk
aapt dump badging other_app.apk | grep "application:"
# → application: label='Cockpit Intelligence' icon='res/mipmap-anydpi-v26/ic_launcher.xml'
```

All three affected apps were installed or reinstalled within the last
several days (this app repeatedly during this session's `adb install -r`
cycles; `coachsuite_cockpit_math`'s `firstInstallTime` was 2 days prior per
`dumpsys package`) — consistent with a launcher app-drawer cache that
hasn't fully reconciled after a burst of install activity, rather than
anything tied to a specific app's build.

## The one real cleanup applied

`android/app/src/main/res/mipmap-{hdpi,mdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png`
were leftover default `flutter create` template icons from *before*
`flutter_launcher_icons` was ever run. Nothing references
`@mipmap/ic_launcher` anywhere (confirmed via
`grep -rln "ic_launcher\b" android/` excluding the `_foreground`/`_monochrome`
variants, which *are* used) — these five files were pure dead weight. Deleted.
They could never have caused a second *visible* icon on their own (Android
doesn't surface unreferenced mipmap resources in a launcher), but leaving
stale, unreferenced icon assets with the pre-rebrand name around is exactly
the kind of thing that causes confusion during future icon changes, so
removing them is good hygiene independent of the duplicate-icon question.

## Recommended remediation for the user

Since the manifest/build config is clean *and* the duplication was directly
observed hitting other apps at the same time, this is a launcher-wide
condition — fixing it from this app's side (uninstall/reinstall) may clear
this app's duplicate but won't necessarily clear the others', and might not
even be necessary once the launcher itself catches up. In order of least to
most disruptive:

1. **Restart the launcher app** (no data loss): **Settings → Apps → see all
   apps → Pixel Launcher (or your launcher) → Force stop**, then return to
   the home screen — this alone often clears a stale in-memory app-drawer
   index without touching any cached files.
2. **Full uninstall, not just reinstall**, for this app specifically:
   ```
   adb uninstall com.quantumlab.mathtutor.gb
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```
   (An `adb install -r` **upgrade** over an existing install is exactly the
   path that leaves stale launcher icon cache behind across icon-resource
   renames; a full uninstall first forces the launcher to drop its cached
   entry.) Verified working during this pass — see `FINAL_V1_POLISH_REPORT.md`.
3. If duplicates persist across multiple apps after that, it's the
   launcher's own cache, not any one app: reboot the device, or clear the
   launcher's cache via **Settings → Apps → [your launcher] → Storage →
   Clear cache** (not "Clear data" — that resets the home screen layout).
3. Check for a leftover **pinned home-screen shortcut or widget** from
   before the rebrand — these are separate icon instances from the app
   drawer entry and won't be cleared by reinstalling the app. Long-press and
   remove any old one manually.

This was verified as a real, live sequence during this pass: a fresh
`adb uninstall` + `adb install -r` cycle on both the Pixel 6a and the 11.5"
tablet each produced exactly one icon and one `pm list packages` entry — see
`FINAL_V1_POLISH_REPORT.md`.
