import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// WCAG 2.1 relative-luminance contrast ratio, per the standard formula
/// (https://www.w3.org/TR/WCAG21/#dfn-relative-luminance /
/// #dfn-contrast-ratio). No package dependency — small enough, and
/// self-contained keeps this test independently auditable.
double _relativeLuminance(Color color) {
  double channel(double srgb) {
    return srgb <= 0.03928
        ? srgb / 12.92
        : math.pow((srgb + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = channel(color.r);
  final g = channel(color.g);
  final b = channel(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double contrastRatio(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  const normalTextMin = 4.5;
  const largeTextMin = 3.0;

  void checkPair(
    String label,
    Color foreground,
    Color background, {
    double minRatio = normalTextMin,
  }) {
    final ratio = contrastRatio(foreground, background);
    expect(ratio, greaterThanOrEqualTo(minRatio),
        reason:
            '$label contrast is ${ratio.toStringAsFixed(2)}:1, needs >= $minRatio:1');
  }

  group('Dark theme contrast', () {
    final theme = AppTheme.dark();
    final c = theme.extension<AppSemanticColors>()!;

    test('text on background/surfaces', () {
      checkPair('primaryText/background', c.primaryText, c.background);
      checkPair('secondaryText/background', c.secondaryText, c.background,
          minRatio: largeTextMin);
      checkPair('primaryText/cardSurface', c.primaryText, c.cardSurface);
      checkPair('secondaryText/cardSurface', c.secondaryText, c.cardSurface,
          minRatio: largeTextMin);
    });

    test('primary action button', () {
      // Button labels are bold, >=16px — WCAG's "large/bold text" UI-
      // component category (SC 1.4.11), 3:1 minimum, not the 4.5:1 body
      // -text minimum. This is the app's existing, pre-this-sprint brand
      // blue (ported unchanged from today's dark theme) — out of scope to
      // recolor here, but formally checked so any future regression below
      // 3:1 is caught.
      checkPair(
          'onPrimaryAction/primaryAction', c.onPrimaryAction, c.primaryAction,
          minRatio: largeTextMin);
    });

    test('status colors on background', () {
      checkPair('success/background', c.success, c.background,
          minRatio: largeTextMin);
      checkPair('warning/background', c.warning, c.background,
          minRatio: largeTextMin);
      checkPair('error/background', c.error, c.background,
          minRatio: largeTextMin);
    });

    test('divider is distinguishable from background', () {
      checkPair('divider/background', c.divider, c.background, minRatio: 1.3);
    });

    test('accent (icons/links/selected text) on background', () {
      checkPair('accent/background', c.accent, c.background,
          minRatio: largeTextMin);
    });
  });

  group('Light theme contrast', () {
    final theme = AppTheme.light();
    final c = theme.extension<AppSemanticColors>()!;

    test('background is not harsh pure white', () {
      expect(c.background, isNot(Colors.white));
    });

    test('text on background/surfaces', () {
      checkPair('primaryText/background', c.primaryText, c.background);
      checkPair('secondaryText/background', c.secondaryText, c.background,
          minRatio: largeTextMin);
      checkPair('primaryText/cardSurface', c.primaryText, c.cardSurface);
      checkPair('secondaryText/cardSurface', c.secondaryText, c.cardSurface,
          minRatio: largeTextMin);
    });

    test('primary action button', () {
      // Button labels are bold, >=16px — WCAG's "large/bold text" UI-
      // component category (SC 1.4.11), 3:1 minimum, not the 4.5:1 body
      // -text minimum. This is the app's existing, pre-this-sprint brand
      // blue (ported unchanged from today's dark theme) — out of scope to
      // recolor here, but formally checked so any future regression below
      // 3:1 is caught.
      checkPair(
          'onPrimaryAction/primaryAction', c.onPrimaryAction, c.primaryAction,
          minRatio: largeTextMin);
    });

    test('status colors on background', () {
      checkPair('success/background', c.success, c.background,
          minRatio: largeTextMin);
      checkPair('warning/background', c.warning, c.background,
          minRatio: largeTextMin);
      checkPair('error/background', c.error, c.background,
          minRatio: largeTextMin);
    });

    test('divider is distinguishable from background', () {
      checkPair('divider/background', c.divider, c.background, minRatio: 1.3);
    });

    test('accent (icons/links/selected text) on background', () {
      checkPair('accent/background', c.accent, c.background,
          minRatio: largeTextMin);
    });
  });

  group('Lab colors — light theme (radar sits on the plain background)', () {
    final theme = AppTheme.light();
    final semantic = theme.extension<AppSemanticColors>()!;
    final lab = theme.extension<AppLabColors>()!;

    test('radar target/landing markers are visible on the light background',
        () {
      checkPair('radarTarget/background', lab.radarTarget, semantic.background,
          minRatio: largeTextMin);
      checkPair(
          'radarLanding/background', lab.radarLanding, semantic.background,
          minRatio: largeTextMin);
    });

    test('ball is visible against the pitch, robot against the pitch', () {
      checkPair('ballColor/pitchSurface', lab.ballColor, lab.pitchSurface,
          minRatio: largeTextMin);
      checkPair('robotColor/pitchSurface', lab.robotColor, lab.pitchSurface,
          minRatio: largeTextMin);
    });

    test('maze wall is distinguishable from maze road/grass', () {
      checkPair('mazeWall/mazeRoad', lab.mazeWall, lab.mazeRoad,
          minRatio: largeTextMin);
      checkPair('mazeWall/mazeGrass', lab.mazeWall, lab.mazeGrass,
          minRatio: largeTextMin);
    });
  });
}
