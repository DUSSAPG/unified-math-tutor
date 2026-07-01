# Screenshot Manifest

Prepare export folders:

```powershell
.\scripts\prepare_store_screenshots.ps1
```

Capture these screens on a phone-sized device for UK, CH, US, and SG variants:

1. Welcome and market selection.
2. Practice setup.
3. Practice question with answer options.
4. Graph-reading question using `graph_read`.
5. Session summary.
6. Parent Cheat Sheet with topic drill suggestions.
7. Parent Cheat Sheet print mode.

Use a reviewed CH build for CH screenshots:

```powershell
flutter run --dart-define=ENV=prod --dart-define=ENABLE_CH_PACKS=true
```

Store final images under `docs/store_readiness/screenshots/<market>/`.
