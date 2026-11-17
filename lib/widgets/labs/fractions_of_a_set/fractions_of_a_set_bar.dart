import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

/// Fractions of a Set: the bar model, the stacked fraction, and the spoken
/// form of a fraction. Fractions are shown as generated, never simplified.

/// Stands in for `fraction` and `fractionA` in a copy string, so the screen
/// can split the string and draw a stacked fraction there (brief §6.3).
const fosSentinelA = '';

/// Stands in for `fractionB`.
const fosSentinelB = '';

/// A fraction n/d as shown and spoken.
class FosFraction {
  const FosFraction(this.n, this.d);

  final int n;
  final int d;
}

/// The spoken form of n/d, e.g. "3 fifths", from the fraction-word keys only
/// (errata C-3).
String fractionWords(AppLocalizations l, int n, int d) => switch (d) {
      2 => l.labsFractionsOfASetHalves(n),
      3 => l.labsFractionsOfASetThirds(n),
      4 => l.labsFractionsOfASetQuarters(n),
      5 => l.labsFractionsOfASetFifths(n),
      6 => l.labsFractionsOfASetSixths(n),
      8 => l.labsFractionsOfASetEighths(n),
      10 => l.labsFractionsOfASetTenths(n),
      _ => throw ArgumentError.value(d, 'd'),
    };

/// A typeset fraction: numerator over a rule over denominator. Visual only;
/// the surrounding text carries the spoken label.
class FosStackedFraction extends StatelessWidget {
  const FosStackedFraction(this.fraction, {super.key, required this.style});

  final FosFraction fraction;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final small =
        style.copyWith(fontSize: (style.fontSize ?? 16) * .8, height: 1.05);
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${fraction.n}', textAlign: TextAlign.center, style: small),
              Container(
                height: 1.5,
                margin: const EdgeInsets.symmetric(vertical: 1),
                color: style.color,
              ),
              Text('${fraction.d}', textAlign: TextAlign.center, style: small),
            ],
          ),
        ),
      ),
    );
  }
}

/// Copy text containing one or two fractions. [text] is the l10n call with
/// its fraction arguments left open: the visible text gets the sentinels
/// (split into stacked fractions), and the semantics label gets the words.
/// No sentinel ever reaches rendered text or semantics.
class FosFractionText extends StatelessWidget {
  const FosFractionText({
    super.key,
    required this.text,
    required this.a,
    this.b,
    required this.style,
    this.liveRegion = false,
    this.header = false,
  });

  final String Function(String a, String b) text;
  final FosFraction a;
  final FosFraction? b;
  final TextStyle style;
  final bool liveRegion;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final spoken = text(
      fractionWords(l, a.n, a.d),
      b == null ? '' : fractionWords(l, b!.n, b!.d),
    );
    final shown = text(fosSentinelA, fosSentinelB);
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    void flush() {
      if (buffer.isEmpty) return;
      spans.add(TextSpan(text: buffer.toString()));
      buffer.clear();
    }

    for (final rune in shown.runes) {
      final ch = String.fromCharCode(rune);
      if (ch == fosSentinelA || (ch == fosSentinelB && b != null)) {
        flush();
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: FosStackedFraction(ch == fosSentinelA ? a : b!, style: style),
        ));
      } else if (ch != fosSentinelB) {
        buffer.write(ch);
      }
    }
    flush();
    return Semantics(
      label: spoken,
      liveRegion: liveRegion,
      header: header,
      container: true,
      excludeSemantics: true,
      child: Text.rich(TextSpan(children: spans), style: style),
    );
  }
}

/// A bar split into [parts] equal sections with [hatched] of them hatched.
/// Visual only; the reveal sentence carries the meaning.
class FosBarModel extends StatelessWidget {
  const FosBarModel({
    super.key,
    required this.parts,
    required this.hatched,
    required this.ink,
    required this.fill,
    required this.surface,
    this.height = 40,
    this.highContrast = false,
  });

  final int parts;
  final int hatched;
  final Color ink;
  final Color fill;
  final Color surface;
  final double height;
  final bool highContrast;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter:
                _BarPainter(parts, hatched, ink, fill, surface, highContrast),
          ),
        ),
      );
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.parts, this.hatched, this.ink, this.fill, this.surface,
      this.highContrast);

  final int parts;
  final int hatched;
  final Color ink;
  final Color fill;
  final Color surface;
  final bool highContrast;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width / parts;
    final stroke = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = highContrast ? 2.5 : 1.5;
    final base = Paint()..color = surface;
    final shade = Paint()
      ..color = fill.withValues(alpha: highContrast ? .6 : .35);
    final hatch = Paint()
      ..color = ink
      ..strokeWidth = highContrast ? 2 : 1.2;
    for (var k = 0; k < parts; k++) {
      final r = Rect.fromLTWH(k * w, 0, w, size.height);
      canvas.drawRect(r, base);
      if (k < hatched) {
        canvas.drawRect(r, shade);
        canvas.save();
        canvas.clipRect(r);
        for (var x = r.left - size.height; x < r.right; x += 8) {
          canvas.drawLine(
              Offset(x, size.height), Offset(x + size.height, 0), hatch);
        }
        canvas.restore();
      }
      canvas.drawRect(r.deflate(stroke.strokeWidth / 2), stroke);
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.parts != parts ||
      old.hatched != hatched ||
      old.ink != ink ||
      old.fill != fill ||
      old.surface != surface ||
      old.highContrast != highContrast;
}
