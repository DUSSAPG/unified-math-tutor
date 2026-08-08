import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared WCAG 2.1 relative-luminance/contrast-ratio helpers, plus a
/// resolved-widget contrast assertion, so every test that needs "is this
/// foreground actually readable on this background" — not just "does the
/// source code mention Colors.white" — can share one implementation
/// instead of each test file re-deriving its own.
///
/// https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
/// https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio
double relativeLuminance(Color color) {
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
  final l1 = relativeLuminance(a);
  final l2 = relativeLuminance(b);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

/// WCAG AA minimums: 4.5:1 for normal text, 3:1 for large (>=18pt, or
/// >=14pt bold) text and for meaningful UI/graphical components.
const double wcagNormalTextMinRatio = 4.5;
const double wcagLargeTextMinRatio = 3.0;

/// Asserts `foreground`/`background` meet at least `minRatio`, with a
/// failure message that states the actual ratio and the required one —
/// use this instead of a bare `expect` so every contrast failure in the
/// suite reads the same way.
void expectContrast(
  String label,
  Color foreground,
  Color background, {
  double minRatio = wcagNormalTextMinRatio,
}) {
  final ratio = contrastRatio(foreground, background);
  expect(ratio, greaterThanOrEqualTo(minRatio),
      reason:
          '$label contrast is ${ratio.toStringAsFixed(2)}:1 (foreground $foreground on background $background), needs >= $minRatio:1');
}

/// True if `element` sits inside a self-contained filled control (a button
/// or a chip) — these paint their own background (e.g. the brand-blue
/// "Reveal the answer" button), so their label's contrast must be checked
/// against *that* fill, not the page background behind the control. Those
/// pairs are covered separately (see app_theme_contrast_test.dart's
/// "primary action button"/"selected chip" checks) — a generic page-level
/// sweep must exclude them or it produces false positives for perfectly
/// legible white-on-blue button text.
bool _isInsideFilledControl(Element element) {
  bool found = false;
  element.visitAncestorElements((ancestor) {
    final widget = ancestor.widget;
    if (widget is ButtonStyleButton ||
        widget is Chip ||
        widget is RawChip ||
        widget is MaterialButton) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

/// Finds every [Text] widget currently in the tree — excluding any inside a
/// button or chip (see [_isInsideFilledControl]) — and asserts each one's
/// *effective* resolved color (its own [TextStyle.color] if set, else the
/// ambient [DefaultTextStyle] — the same resolution order Flutter itself
/// uses to paint it) contrasts sufficiently against `background`. Skips any
/// [Text] whose effective color is `null` (inherits the theme's default
/// body color, already covered by app_theme_contrast_test.dart) — this
/// only checks widgets that resolved to an explicit color, which is
/// exactly the class of bug a leftover `Colors.white` literal produces.
///
/// Returns the list of `(text, color, ratio)` tuples it actually checked,
/// so a test can additionally assert *how many* widgets were covered
/// (catching the case where a locator/finder silently matches nothing).
List<(String, Color, double)> expectAllTextContrastsOnBackground(
  WidgetTester tester,
  Color background, {
  double minRatio = wcagNormalTextMinRatio,
}) {
  final checked = <(String, Color, double)>[];
  for (final element in find.byType(Text).evaluate()) {
    if (_isInsideFilledControl(element)) continue;
    final widget = element.widget as Text;
    final data = widget.data ?? widget.textSpan?.toPlainText() ?? '';
    if (data.trim().isEmpty) continue;
    Color? color = widget.style?.color;
    if (color == null) {
      final ambient = DefaultTextStyle.of(element).style;
      color = ambient.color;
    }
    if (color == null) continue;
    final ratio = contrastRatio(color, background);
    checked.add((data, color, ratio));
    expect(ratio, greaterThanOrEqualTo(minRatio),
        reason:
            'Text "$data" resolves to color $color on background $background '
            '— contrast is ${ratio.toStringAsFixed(2)}:1, needs >= $minRatio:1. '
            'This is the exact "white/pale text on a light surface" defect '
            'class this check exists to catch.');
  }
  return checked;
}
