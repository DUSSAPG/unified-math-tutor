import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/widgets/visual_assets/visual_asset_view.dart';

Widget _app(Widget child, {bool reduceMotion = false}) {
  return MaterialApp(
    builder: (context, widget) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
      child: widget!,
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('renders the SVG for a known asset id', (tester) async {
    await tester.pumpWidget(
        _app(const VisualAssetView(assetId: 'diagram-area-triangle')));
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('Diagram unavailable'), findsNothing);
  });

  testWidgets(
      'renders a labeled fallback tile — never a broken-image glyph — for an unknown id',
      (tester) async {
    await tester
        .pumpWidget(_app(const VisualAssetView(assetId: 'does-not-exist')));
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsNothing);
    expect(find.text('Diagram unavailable'), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
  });

  testWidgets('exposes the accessibility description as a semantic label',
      (tester) async {
    await tester.pumpWidget(
        _app(const VisualAssetView(assetId: 'diagram-area-triangle')));
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel(
        'A triangle with its base and perpendicular height labelled, illustrating area equals a half times base times height.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders without error under Reduce Motion', (tester) async {
    await tester.pumpWidget(
      _app(
        const VisualAssetView(assetId: 'diagram-area-triangle'),
        reduceMotion: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'animate: false renders the SVG immediately with no entrance transition',
      (tester) async {
    await tester.pumpWidget(
      _app(
        const VisualAssetView(assetId: 'diagram-area-triangle', animate: false),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
