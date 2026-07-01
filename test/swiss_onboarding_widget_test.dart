import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/core/market/market_store.dart';
import 'package:unified_math_tutor/features/onboarding/market_picker_screen.dart';
import 'package:unified_math_tutor/features/onboarding/swiss_canton_picker_screen.dart';
import 'package:unified_math_tutor/services/locale_service.dart';

void main() {
  testWidgets('CH onboarding shows Canton step for CH market', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
    final store = MarketStore();
    await store.init();

    await tester.pumpWidget(_MarketPickerHarness(store: store));
    await tester.tap(find.text('Switzerland'));
    await tester.pumpAndSettle();

    expect(find.text('Switzerland - choose canton'), findsOneWidget);
    expect(find.byKey(const ValueKey('canton-AG')), findsOneWidget);
  });

  testWidgets('non-CH onboarding skips Canton step', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
    final store = MarketStore();
    await store.init();

    await tester.pumpWidget(_MarketPickerHarness(store: store));
    await tester.tap(find.text('United States'));
    await tester.pumpAndSettle();

    expect(find.text('Switzerland - choose canton'), findsNothing);
    expect(find.text('Welcome'), findsOneWidget);
  });
}

class _MarketPickerHarness extends StatelessWidget {
  const _MarketPickerHarness({required this.store});

  final MarketStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => MarketPickerScreen(store: store),
        '/choose-canton-ch': (_) => SwissCantonPickerScreen(store: store),
        '/welcome': (_) => const Scaffold(body: Text('Welcome')),
      },
    );
  }
}
