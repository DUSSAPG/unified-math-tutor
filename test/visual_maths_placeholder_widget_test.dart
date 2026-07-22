import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/visual_maths/abacus_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/fraction_bars_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/place_value_explorer_screen.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );

  testWidgets('Fraction Bars shows the Preview badge and cycles captions on tap', (tester) async {
    await tester.pumpWidget(wrap(const FractionBarsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Interactive version coming in a future release.'), findsOneWidget);
    expect(find.text('1/2 is exactly half of the whole bar.'), findsOneWidget);

    await tester.tap(find.text('Try another example'));
    await tester.pumpAndSettle();

    expect(
      find.text('2/4 covers the same length as 1/2 — equivalent fractions.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Abacus shows the Preview badge and cycles captions on tap', (tester) async {
    await tester.pumpWidget(wrap(const AbacusScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('One bead moved in the ones column represents 1.'), findsOneWidget);

    await tester.tap(find.text('Try another example'));
    await tester.pumpAndSettle();

    expect(
      find.text('Ten ones regroup into a single bead in the tens column.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Place Value Explorer shows the Preview badge and cycles captions on tap',
      (tester) async {
    await tester.pumpWidget(wrap(const PlaceValueExplorerScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);
    expect(
      find.text('3,742 breaks into 3 thousands, 7 hundreds, 4 tens, 2 ones.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Try another example'));
    await tester.pumpAndSettle();

    expect(find.text('6.4 breaks into 6 ones and 4 tenths.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
