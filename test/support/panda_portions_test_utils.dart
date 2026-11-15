import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/panda_portions/panda_portions_content.dart';
import 'package:unified_math_tutor/screens/labs/panda_portions/panda_portions_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/panda_portions/apple_slice.dart';

/// Shared helpers for the Panda Portions widget tests. No `main()`.

final portionsL10n = lookupAppLocalizations(const Locale('en'));

const compactLandscape = Size(740, 360);

Future<void> pumpPortions(
  WidgetTester tester, {
  PortionPath? path,
  Size size = const Size(390, 844),
  ThemeMode themeMode = ThemeMode.light,
  double textScale = 1.0,
  Key? boundaryKey,
}) async {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(RepaintBoundary(
    key: boundaryKey,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: PandaPortionsScreen(initialPath: path),
    ),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

final Finder portionsDropTarget =
    find.byKey(const Key('pandaPortionsDropTarget'));
final Finder portionsFeedingArea =
    find.byKey(const Key('pandaPortionsFeedingArea'));

Finder pieceFinder(String id) => find.byKey(ValueKey('pandaPortionsPiece_$id'));

/// A point well inside piece [index] of [plate] (on its bisector), so taps
/// and drags land on the sector itself, not just its bounding box.
Offset pointInPiece(WidgetTester tester, PortionPlate plate, int index) {
  final plateFinder = find.descendant(
    of: find.byKey(ValueKey('pandaPortionsPlate_${plate.letter}')),
    matching: find.byType(InteractivePortionPlate),
  );
  final topLeft = tester.getTopLeft(plateFinder);
  final size = tester.getSize(plateFinder).width;
  final g = PieceGeometry(plate, index, size);
  return topLeft + g.center + bisector(g.start, g.sweep, g.radius * 0.6);
}

/// The round currently on screen, rebuilt from the content model.
PortionRound currentRound(PortionLessonId lesson, int variation) =>
    PortionRound.build(PandaPortionsContent.lesson(lesson), variation);

Future<void> dragPieceToPanda(
    WidgetTester tester, PortionPlate plate, int index) async {
  final from = pointInPiece(tester, plate, index);
  final gesture = await tester.startGesture(from);
  await gesture.moveBy(const Offset(0, 20));
  await tester.pump();
  await tester.ensureVisible(portionsFeedingArea);
  await tester.pump();
  final now =
      tester.getCenter(find.byKey(const Key('pandaPortionsDragFeedback')));
  await gesture.moveBy(tester.getCenter(portionsFeedingArea) - now);
  await tester.pump();
  await gesture.up();
  await tester.pump();
}

Future<void> tapPieceThenPanda(
    WidgetTester tester, PortionPlate plate, int index) async {
  await tester.ensureVisible(
      find.byKey(ValueKey('pandaPortionsPlate_${plate.letter}')));
  await tester.pump();
  await tester.tapAt(pointInPiece(tester, plate, index));
  await tester.pump();
  await tester.ensureVisible(portionsFeedingArea);
  await tester.pump();
  await tester.tap(portionsFeedingArea);
  await tester.pump();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final f = find.byKey(Key(key));
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await tester.pump();
}

void expectNoPortionsLayoutErrors(WidgetTester tester) {
  final e = tester.takeException();
  final detail = e is FlutterError
      ? e.diagnostics.map((d) => d.toString()).join(' | ')
      : '$e';
  expect(e, isNull, reason: detail);
}
