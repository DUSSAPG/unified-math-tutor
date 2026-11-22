import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/create_angle/create_angle_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/create_angle/create_angle_pitch_painter.dart';

final createAngleL10n = lookupAppLocalizations(const Locale('en'));

final pitchFinder = find.byKey(const Key('createAnglePitch'));
final feedbackFinder = find.byKey(const Key('createAngleFeedbackText'));
final progressFinder = find.byKey(const Key('createAngleProgress'));
final completionFinder = find.byKey(const Key('createAngleCompletionCard'));

/// Pumps Create the Angle on its own with the real app themes.
Future<void> pumpCreateAngle(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
  bool dark = false,
  bool disableAnimations = false,
  bool highContrast = false,
  Locale locale = const Locale('en'),
  Key? boundaryKey,
  String? platformDefaultFont,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final app = MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: _withPlatformFont(AppTheme.light(), platformDefaultFont),
    darkTheme: _withPlatformFont(AppTheme.dark(), platformDefaultFont),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: disableAnimations,
        highContrast: highContrast,
      ),
      child: child!,
    ),
    home: const CreateAngleScreen(),
  );
  await tester.pumpWidget(
    boundaryKey == null ? app : RepaintBoundary(key: boundaryKey, child: app),
  );
  await tester.pumpAndSettle();
}

/// Screenshot evidence only: the app theme leaves the app bar title and
/// filled-button labels without a font family, so a device draws them in
/// its platform default (Roboto on Android) while a test draws boxes. Naming
/// that family explicitly makes captures match the device.
ThemeData _withPlatformFont(ThemeData theme, String? family) {
  if (family == null) return theme;
  final title = theme.appBarTheme.titleTextStyle;
  final button = theme.filledButtonTheme.style;
  return theme.copyWith(
    appBarTheme: theme.appBarTheme.copyWith(
      titleTextStyle: title?.copyWith(fontFamily: family),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: button?.copyWith(
        textStyle: WidgetStatePropertyAll(
          (button.textStyle?.resolve({}) ?? const TextStyle())
              .copyWith(fontFamily: family),
        ),
      ),
    ),
  );
}

CreateAnglePitchPainter pitchPainter(WidgetTester tester) => tester
    .widget<CustomPaint>(
      find
          .descendant(of: pitchFinder, matching: find.byType(CustomPaint))
          .first,
    )
    .painter! as CreateAnglePitchPainter;

/// Drags from the ball along the direction [degrees] above the baseline
/// (or below it, mirrored, when [below] is true), the full aim length.
Future<void> aimAt(
  WidgetTester tester,
  double degrees, {
  bool below = false,
}) async {
  final g = CreateAnglePitchGeometry(tester.getSize(pitchFinder));
  final origin = tester.getTopLeft(pitchFinder);
  final a = degrees * math.pi / 180;
  final vector =
      Offset(math.cos(a), below ? math.sin(a) : -math.sin(a)) * g.radius;
  await tester.dragFrom(origin + g.ball, vector);
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

String textOf(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;
