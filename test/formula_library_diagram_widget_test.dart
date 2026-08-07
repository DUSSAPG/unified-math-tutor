import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';

/// Covers the Visual Asset System's one concrete integration point: Formula
/// Library entries that set a `diagramAssetId` show their diagram when
/// expanded; every other entry (the vast majority) renders exactly as
/// before — no regression from adding the optional field.
void main() {
  Future<void> expand(WidgetTester tester, String title) async {
    await tester.enterText(find.byType(TextField), title);
    await tester.pumpAndSettle();
    // The typed search text and the matched formula card's title are
    // identical strings once the search narrows to one result — `.last`
    // targets the card's Text widget, not the TextField's own EditableText.
    await tester.tap(find.text(title).last);
    await tester.pumpAndSettle();
  }

  testWidgets('a formula with a diagramAssetId shows its VisualAssetView',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FormulaLibraryScreen())),
    );
    await tester.pumpAndSettle();

    await expand(tester, 'Area of a Triangle');

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets(
      'a formula with no diagramAssetId renders unchanged, with no diagram',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FormulaLibraryScreen())),
    );
    await tester.pumpAndSettle();

    await expand(tester, 'Area of a Rectangle');

    expect(find.byType(SvgPicture), findsNothing);
    expect(
        find.text(
            'The space enclosed by a rectangle with length l and width w.'),
        findsOneWidget);
  });
}
