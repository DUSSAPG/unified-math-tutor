import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_card_detail_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  // Pre-warm the catalog's in-memory cache once, outside any testWidgets
  // FakeAsync zone, so every test's byId() call below resolves from cache
  // synchronously rather than needing to complete real file I/O mid-pump.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
  });

  // Loading assets/config/discovery_cards.json is real file I/O; testWidgets
  // bodies run in a FakeAsync zone that never completes real I/O on its own,
  // so every interaction here must happen inside tester.runAsync().
  Future<void> pumpCard(WidgetTester tester, String cardId) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: DiscoveryCardDetailScreen(cardId: cardId),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'shows Think state first, then Reveal after tapping the reveal button',
      (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'shopping-percentage-discount');

      expect(find.text('Reveal the solution'), findsOneWidget);
      expect(find.text('Worked solution'), findsNothing);

      await tester.tap(find.text('Reveal the solution'));
      await tester.pumpAndSettle();

      expect(find.text('Worked solution'), findsOneWidget);
      expect(find.text("Where you'll use this"), findsOneWidget);
      expect(find.text('Try one yourself'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('follow-up question accepts a correct numeric answer',
      (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'shopping-percentage-discount');
      await tester.tap(find.text('Reveal the solution'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '90');
      await tester.ensureVisible(find.text('Check my answer'));
      await tester.tap(find.text('Check my answer'));
      await tester.pumpAndSettle();

      expect(find.text("Nice work — that's right."), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
      'follow-up question flags an incorrect numeric answer without punitive language',
      (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'shopping-percentage-discount');
      await tester.tap(find.text('Reveal the solution'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '1');
      await tester.ensureVisible(find.text('Check my answer'));
      await tester.tap(find.text('Check my answer'));
      await tester.pumpAndSettle();

      expect(find.text('Not quite — take another look at the steps above.'),
          findsOneWidget);
      expect(find.textContaining('wrong'), findsNothing);
      expect(find.textContaining('fail'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
      'renders professional math notation, not raw programming operators',
      (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'shopping-percentage-discount');
      await tester.tap(find.text('Reveal the solution'));
      await tester.pumpAndSettle();

      final rawAsterisk = find.textContaining('*');
      expect(rawAsterisk, findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
