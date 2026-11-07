import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/interactive_studios/interactive_studios_screen.dart';
import 'package:unified_math_tutor/services/football_studio_platform.dart';

class _FakeFootballStudioPlatform implements FootballStudioPlatform {
  _FakeFootballStudioPlatform({
    this.installed = true,
    this.launchFailure = false,
  });

  final bool installed;
  final bool launchFailure;
  var launches = 0;

  @override
  bool get supportsAndroid => true;

  @override
  Future<bool> isInstalled() async => installed;

  @override
  Future<bool> launch() async {
    launches++;
    if (launchFailure) {
      throw PlatformException(code: 'launch_failed');
    }
    return true;
  }
}

Future<void> _pumpScreen(
  WidgetTester tester,
  FootballStudioPlatform platform,
) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: InteractiveStudiosScreen(platform: platform),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('installed companion exposes a real open action', (tester) async {
    final platform = _FakeFootballStudioPlatform();
    await _pumpScreen(tester, platform);

    expect(find.text('Interactive Studios'), findsOneWidget);
    expect(find.text('Football Studio'), findsOneWidget);
    expect(
      find.text(
        'Football Studio includes applied-learning activities in Coordinates, '
        'Ratio & Scale, Angles, Distance-Time-Speed, Area, and Algebra.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Achievements and progress stay on this device in Football Studio '
        'for V1. Unified Math Tutor does not read or share them.',
      ),
      findsOneWidget,
    );
    expect(find.text('Open Football Studio'), findsOneWidget);

    await tester.tap(find.text('Open Football Studio'));
    await tester.pumpAndSettle();

    expect(platform.launches, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'unavailable companion shows install-needed state without a '
      'misleading open button', (tester) async {
    await _pumpScreen(tester, _FakeFootballStudioPlatform(installed: false));

    expect(
      find.text('Football Studio is not installed on this device.'),
      findsOneWidget,
    );
    expect(
      find.text('Install Football Studio separately to open these activities.'),
      findsOneWidget,
    );
    expect(find.text('Open Football Studio'), findsNothing);
  });

  testWidgets('launch failure is explicit and offers a retry', (tester) async {
    final platform = _FakeFootballStudioPlatform(launchFailure: true);
    await _pumpScreen(tester, platform);

    await tester.tap(find.text('Open Football Studio'));
    await tester.pumpAndSettle();

    expect(
      find.text('Football Studio is installed, but Android could not open it.'),
      findsOneWidget,
    );
    expect(find.text('Try opening again'), findsOneWidget);
    expect(platform.launches, 1);
  });
}
