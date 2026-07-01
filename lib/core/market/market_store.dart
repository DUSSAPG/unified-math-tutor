import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'canton.dart';

class MarketSelection {
  /// The UI market (country shell): GB, CH, US, SG.
  /// Nordic, KR, and AR markets remain UAT-only registry scaffolds.
  final String uiMarketId;

  /// The UI language/locale (Figma screens):
  /// en, en-GB, de-CH, fr-CH, it-CH
  final String uiLocale;

  /// Which content locale to load packs from (question bank)
  /// Start with en-GB everywhere (your plan).
  final String contentLocale;
  final Canton? selectedCanton;

  const MarketSelection({
    required this.uiMarketId,
    required this.uiLocale,
    required this.contentLocale,
    this.selectedCanton,
  });

  static MarketSelection? fromPrefs(SharedPreferences prefs) {
    final m = prefs.getString('uiMarketId');
    final ui = prefs.getString('uiLocale');
    final c = prefs.getString('contentLocale');
    if (m == null || ui == null || c == null) return null;
    return MarketSelection(
      uiMarketId: m,
      uiLocale: ui,
      contentLocale: c,
      selectedCanton: Canton.byId(prefs.getString('selectedCanton')),
    );
  }
}

class MarketStore {
  static const _kUiMarketId = 'uiMarketId';
  static const _kUiLocale = 'uiLocale';
  static const _kContentLocale = 'contentLocale';
  static const _kSelectedCanton = 'selectedCanton';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    final p = _prefs;
    if (p == null) {
      throw StateError(
        'MarketStore not initialized. Call await store.init() before use.',
      );
    }
    return p;
  }

  Future<MarketSelection?> load({Locale? deviceLocale}) async {
    if (_prefs == null) await init();
    final selection = MarketSelection.fromPrefs(_p);
    if (selection == null) return null;
    if (selection.uiMarketId != 'CH' || selection.selectedCanton != null) {
      return selection;
    }

    final canton = Canton.defaultForDeviceLocale(deviceLocale);
    await setSelectedCanton(canton);
    return MarketSelection(
      uiMarketId: selection.uiMarketId,
      uiLocale: selection.uiLocale,
      contentLocale: selection.contentLocale,
      selectedCanton: canton,
    );
  }

  Future<void> setMarketAndLocales({
    required String uiMarketId,
    required String uiLocale,
    required String contentLocale,
    Canton? selectedCanton,
  }) async {
    if (_prefs == null) await init();
    await _p.setString(_kUiMarketId, uiMarketId);
    await _p.setString(_kUiLocale, uiLocale);
    await _p.setString(_kContentLocale, contentLocale);
    if (uiMarketId == 'CH' && selectedCanton != null) {
      await _p.setString(_kSelectedCanton, selectedCanton.id);
    } else if (uiMarketId != 'CH') {
      await _p.remove(_kSelectedCanton);
    }
  }

  Future<Canton?> loadSelectedCanton({Locale? deviceLocale}) async {
    final selection = await load(deviceLocale: deviceLocale);
    return selection?.selectedCanton;
  }

  Future<void> setSelectedCanton(Canton canton) async {
    if (_prefs == null) await init();
    await _p.setString(_kSelectedCanton, canton.id);
  }

  Future<void> clear() async {
    if (_prefs == null) await init();
    await _p.remove(_kUiMarketId);
    await _p.remove(_kUiLocale);
    await _p.remove(_kContentLocale);
    await _p.remove(_kSelectedCanton);
  }
}
