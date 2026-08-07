import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/widgets/labs/lab_controls/lab_controls.dart';

/// Coverage for the reusable adaptive lab control primitives themselves —
/// independent of any specific lab — so Football Precision/Flight Path
/// Lab/Maze Driver's own tests only need to assert how they *use* these
/// primitives, not re-verify the primitives' own behavior each time.
void main() {
  Widget wrap(Widget child, {Size size = const Size(390, 844)}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  group('resolveLabControlBreakpoint', () {
    testWidgets('narrow phone portrait resolves to phonePortrait',
        (tester) async {
      late LabControlBreakpoint result;
      await tester.pumpWidget(wrap(
        Builder(builder: (context) {
          result = resolveLabControlBreakpoint(context);
          return const SizedBox.shrink();
        }),
        size: const Size(320, 568),
      ));
      expect(result, LabControlBreakpoint.phonePortrait);
      expect(labControlHasSideRailWidth(result), isFalse);
    });

    testWidgets('narrow phone landscape resolves to phoneLandscape',
        (tester) async {
      late LabControlBreakpoint result;
      await tester.pumpWidget(wrap(
        Builder(builder: (context) {
          result = resolveLabControlBreakpoint(context);
          return const SizedBox.shrink();
        }),
        size: const Size(568, 320),
      ));
      expect(result, LabControlBreakpoint.phoneLandscape);
      expect(labControlHasSideRailWidth(result), isTrue);
    });

    // A wide landscape phone (e.g. a Pixel 6a rotated, ~915x412) crosses the
    // same width threshold AppResponsive already uses app-wide to switch a
    // phone into the tablet-width bucket — this is existing, intentional
    // behavior (not introduced by the lab control system), so it's asserted
    // here rather than treated as a phoneLandscape case.
    testWidgets(
        'wide landscape phone resolves to tablet, matching AppResponsive',
        (tester) async {
      late LabControlBreakpoint result;
      await tester.pumpWidget(wrap(
        Builder(builder: (context) {
          result = resolveLabControlBreakpoint(context);
          return const SizedBox.shrink();
        }),
        size: const Size(844, 390),
      ));
      expect(result, LabControlBreakpoint.tablet);
    });

    testWidgets('Pixel 6a portrait resolves to phonePortrait', (tester) async {
      late LabControlBreakpoint result;
      await tester.pumpWidget(wrap(
        Builder(builder: (context) {
          result = resolveLabControlBreakpoint(context);
          return const SizedBox.shrink();
        }),
        size: const Size(412, 915),
      ));
      expect(result, LabControlBreakpoint.phonePortrait);
    });

    testWidgets('Android tablet resolves to tablet regardless of orientation',
        (tester) async {
      late LabControlBreakpoint result;
      await tester.pumpWidget(wrap(
        Builder(builder: (context) {
          result = resolveLabControlBreakpoint(context);
          return const SizedBox.shrink();
        }),
        size: const Size(800, 1280),
      ));
      expect(result, LabControlBreakpoint.tablet);
      expect(labControlHasSideRailWidth(result), isTrue);
    });

    testWidgets('web desktop width resolves to desktop', (tester) async {
      late LabControlBreakpoint result;
      await tester.pumpWidget(wrap(
        Builder(builder: (context) {
          result = resolveLabControlBreakpoint(context);
          return const SizedBox.shrink();
        }),
        size: const Size(1280, 800),
      ));
      expect(result, LabControlBreakpoint.desktop);
    });
  });

  group('LabControlRail', () {
    testWidgets('renders its child with a semantic container label',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(
        const LabControlRail(
          position: LabControlRailPosition.right,
          semanticLabel: 'Power control',
          child: Text('Power: 70%'),
        ),
      ));

      expect(find.text('Power: 70%'), findsOneWidget);
      // The container merges its own label with the child's semantics into
      // one announced node ("Power control, Power: 70%") — the intended
      // screen-reader behavior for a labeled control group, so this matches
      // the combined label rather than an exact "Power control" string.
      expect(find.bySemanticsLabel(RegExp('Power control')), findsOneWidget);
      handle.dispose();
    });
  });

  group('LabControlHandle', () {
    testWidgets('meets the 48x48 minimum touch target and fires onPressed',
        (tester) async {
      var pressed = false;
      await tester.pumpWidget(wrap(
        LabControlHandle(
          label: 'Show controls',
          onPressed: () => pressed = true,
        ),
      ));

      final size = tester.getSize(find.byType(LabControlHandle));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));

      await tester.tap(find.byType(LabControlHandle));
      expect(pressed, isTrue);
    });
  });

  group('LabCollapsibleControls', () {
    testWidgets('does not build the child at all while collapsed',
        (tester) async {
      await tester.pumpWidget(wrap(
        const LabCollapsibleControls(
          collapsed: true,
          semanticLabel: 'Secondary controls',
          child: Text('Secondary control content'),
        ),
      ));

      expect(find.text('Secondary control content'), findsNothing);
    });

    testWidgets('builds the child once expanded', (tester) async {
      await tester.pumpWidget(wrap(
        const LabCollapsibleControls(
          collapsed: false,
          semanticLabel: 'Secondary controls',
          child: Text('Secondary control content'),
        ),
      ));

      expect(find.text('Secondary control content'), findsOneWidget);
    });

    testWidgets('animates via AnimatedSize when motion is enabled',
        (tester) async {
      await tester.pumpWidget(wrap(
        const LabCollapsibleControls(
          collapsed: false,
          semanticLabel: 'Secondary controls',
          child: Text('Secondary control content'),
        ),
      ));

      expect(find.byType(AnimatedSize), findsOneWidget);
    });

    testWidgets('skips AnimatedSize entirely under Reduce Motion',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
              size: Size(390, 844), disableAnimations: true),
          child: MaterialApp(
            home: const Scaffold(
              body: LabCollapsibleControls(
                collapsed: false,
                semanticLabel: 'Secondary controls',
                child: Text('Secondary control content'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedSize), findsNothing);
      expect(find.text('Secondary control content'), findsOneWidget);
    });
  });

  group('LabBottomControlDrawer', () {
    testWidgets('starts collapsed by default and expands on tap',
        (tester) async {
      await tester.pumpWidget(wrap(
        const LabBottomControlDrawer(
          title: 'Previous attempts',
          child: Text('Attempt #1'),
        ),
      ));

      expect(find.text('Previous attempts'), findsOneWidget);
      expect(find.text('Attempt #1'), findsNothing);

      await tester.tap(find.text('Previous attempts'));
      await tester.pumpAndSettle();

      expect(find.text('Attempt #1'), findsOneWidget);
    });

    testWidgets('honors initiallyExpanded', (tester) async {
      await tester.pumpWidget(wrap(
        const LabBottomControlDrawer(
          title: 'Power',
          initiallyExpanded: true,
          child: Text('Power slider'),
        ),
      ));

      expect(find.text('Power slider'), findsOneWidget);
    });
  });
}
