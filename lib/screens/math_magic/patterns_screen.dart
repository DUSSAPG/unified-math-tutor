import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'math_magic_activity_scaffold.dart';

enum _PatternKind { triangular, square }

/// Grow a dot pattern step by step and watch the counting rule emerge —
/// triangular numbers (1, 3, 6, 10, ...) and square numbers (1, 4, 9, 16,
/// ...), each with a visual, self-verifying explanation for why the
/// formula works (no authored fact the learner has to just trust).
class PatternsScreen extends StatefulWidget {
  const PatternsScreen({super.key});

  @override
  State<PatternsScreen> createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsScreen> {
  _PatternKind _kind = _PatternKind.triangular;
  int _n = 4;

  int get _triangularCount => _n * (_n + 1) ~/ 2;
  int get _squareCount => _n * _n;
  int get _count =>
      _kind == _PatternKind.triangular ? _triangularCount : _squareCount;

  String get _formula => _kind == _PatternKind.triangular
      ? '1 + 2 + 3 + ... + $_n = $_n × ${_n + 1} ÷ 2 = $_count'
      : '$_n × $_n = $_count';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MathMagicActivityScaffold(
      title: 'Patterns',
      caption:
          'Some number sequences make a growing shape. Step through the pattern and watch the total, and the rule behind it, emerge.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<_PatternKind>(
            segments: const [
              ButtonSegment(
                  value: _PatternKind.triangular,
                  label: Text('Triangular numbers')),
              ButtonSegment(
                  value: _PatternKind.square, label: Text('Square numbers')),
            ],
            selected: {_kind},
            onSelectionChanged: (selection) =>
                setState(() => _kind = selection.single),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: SizedBox(
              height: 220,
              width: 220,
              child: Semantics(
                label:
                    '${_kind == _PatternKind.triangular ? "A triangle" : "A square"} made of $_count dots, for step $_n of the pattern.',
                image: true,
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: _DotPatternPainter(
                      n: _n,
                      triangular: _kind == _PatternKind.triangular,
                      dotColor: colors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Step $_n: $_count dots',
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          Slider(
            value: _n.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            label: '$_n',
            onChanged: (value) => setState(() => _n = value.round()),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Text(_formula,
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  const _DotPatternPainter({
    required this.n,
    required this.triangular,
    required this.dotColor,
  });

  final int n;
  final bool triangular;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    const dotRadius = 8.0;
    final spacing = (size.width - dotRadius * 2) / 8;
    final paint = Paint()..color = dotColor;

    if (triangular) {
      final totalHeight = (n - 1) * spacing;
      final startY = (size.height - totalHeight) / 2;
      for (var row = 0; row < n; row++) {
        final dotsInRow = row + 1;
        final rowWidth = (dotsInRow - 1) * spacing;
        final startX = (size.width - rowWidth) / 2;
        for (var col = 0; col < dotsInRow; col++) {
          canvas.drawCircle(
            Offset(startX + col * spacing, startY + row * spacing),
            dotRadius,
            paint,
          );
        }
      }
      return;
    }

    final total = (n - 1) * spacing;
    final start = (size.width - total) / 2;
    for (var row = 0; row < n; row++) {
      for (var col = 0; col < n; col++) {
        canvas.drawCircle(
          Offset(start + col * spacing, start + row * spacing),
          dotRadius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter oldDelegate) =>
      oldDelegate.n != n ||
      oldDelegate.triangular != triangular ||
      oldDelegate.dotColor != dotColor;
}
