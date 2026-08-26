import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';

/// D2 locale-truthfulness disclosure tests. Deliberately fast/no-real-I/O:
/// these only need the setup screen to render (no session start, no real
/// pack load), unlike `practice_availability_resolver_test.dart`'s content
/// tests or the Continue Learning proof-flow files.
Widget _wrap(Locale locale) => MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: PracticeScreen()),
    );

const _noticeKey = Key('practiceEnglishContentNotice');

void main() {
  testWidgets('en-GB shows no English-content disclosure', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en', 'GB')));
    await tester.pumpAndSettle();
    expect(find.byKey(_noticeKey), findsNothing);
  });

  testWidgets('plain en shows no disclosure either', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.byKey(_noticeKey), findsNothing);
  });

  testWidgets(
      'fr-CH shows the English-content disclosure before a '
      'session begins', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('fr', 'CH')));
    await tester.pumpAndSettle();
    expect(find.byKey(_noticeKey), findsOneWidget);
    final l10n = lookupAppLocalizations(const Locale('fr', 'CH'));
    expect(find.text(l10n.practiceEnglishContentNotice), findsOneWidget);
  });

  testWidgets('de-CH shows the disclosure', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('de', 'CH')));
    await tester.pumpAndSettle();
    expect(find.byKey(_noticeKey), findsOneWidget);
  });

  testWidgets('it-CH shows the disclosure', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('it', 'CH')));
    await tester.pumpAndSettle();
    expect(find.byKey(_noticeKey), findsOneWidget);
  });

  testWidgets(
      'the disclosure text never claims translations are coming '
      'soon or that translated content is available', (tester) async {
    await tester.pumpWidget(_wrap(const Locale('fr', 'CH')));
    await tester.pumpAndSettle();
    final l10n = lookupAppLocalizations(const Locale('fr', 'CH'));
    final text = l10n.practiceEnglishContentNotice.toLowerCase();
    expect(text, isNot(contains('bientôt'))); // "soon" in French
    expect(text, isNot(contains('coming soon')));
  });
}
