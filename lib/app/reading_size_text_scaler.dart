import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../services/local_preferences_service.dart';

/// Combines Android's (or the platform's) accessibility text size with the
/// app's own Reading Size setting (Small 0.90, Default 1.00, Large 1.15).
///
/// Policy, applied separately for every font size so that non-linear
/// platform scaling (Android 14+) keeps its own curve:
///
/// * System text at or below the platform default: the Reading Size scales
///   the system size. At the default system setting this is exactly the
///   previous behaviour (0.90 / 1.00 / 1.15).
/// * System text larger than the default: the larger of the system size and
///   the Reading Size wins. Small and Default never shrink a larger system
///   accessibility setting, and the two are never multiplied, so the
///   effective size is the system size (up to the platform's own maximum,
///   2.0 on Android) or 1.15 for Large, whichever is bigger.
@immutable
class ReadingSizeTextScaler extends TextScaler {
  const ReadingSizeTextScaler({
    required this.system,
    required this.readingSize,
  }) : assert(readingSize > 0);

  /// The platform's text scaler, as received in [MediaQueryData.textScaler].
  final TextScaler system;

  /// The app's Reading Size factor (0.90, 1.00 or 1.15).
  final double readingSize;

  @override
  double scale(double fontSize) {
    final systemSize = system.scale(fontSize);
    if (systemSize > fontSize) {
      return math.max(systemSize, fontSize * readingSize);
    }
    return systemSize * readingSize;
  }

  /// Backward-compatibility estimate required by [TextScaler]; the app itself
  /// only ever calls [scale].
  @override
  double get textScaleFactor => scale(_referenceFontSize) / _referenceFontSize;

  static const double _referenceFontSize = 14;

  @override
  bool operator ==(Object other) =>
      other is ReadingSizeTextScaler &&
      other.system == system &&
      other.readingSize == readingSize;

  @override
  int get hashCode => Object.hash(system, readingSize);

  @override
  String toString() =>
      'ReadingSizeTextScaler(system: $system, readingSize: ${readingSize}x)';
}

/// The `MaterialApp.builder` used by the app: replaces the incoming
/// [MediaQueryData.textScaler] with a [ReadingSizeTextScaler] built from the
/// platform scaler and the saved Reading Size, rebuilding when either
/// changes.
Widget readingSizeAppBuilder(BuildContext context, Widget? child) {
  return ValueListenableBuilder<double>(
    valueListenable: LocalPreferencesService.instance.textScale,
    builder: (context, readingSize, child) {
      final mediaQuery = MediaQuery.of(context);
      return MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: ReadingSizeTextScaler(
            system: mediaQuery.textScaler,
            readingSize: readingSize,
          ),
        ),
        child: child!,
      );
    },
    child: child,
  );
}
