import 'package:flutter/foundation.dart';
import 'env.dart';

class BuildFlags {
  static bool get enableDevUi => Env.isUat || (Env.isDev && !kReleaseMode);
  static const bool _enableAllLocales =
      bool.fromEnvironment('ENABLE_ALL_LOCALES', defaultValue: false);
  static const bool enableChPacks =
      bool.fromEnvironment('ENABLE_CH_PACKS', defaultValue: false);

  static bool get enableAllLocales => _enableAllLocales;
  static bool get enableUatLocales => Env.isUat && _enableAllLocales;
}
