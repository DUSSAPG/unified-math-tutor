import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'math_magic_activity_scaffold.dart';

/// Explore odd + even patterns: pick two numbers, predict whether their sum
/// will be odd or even, then reveal it — no running score, just a one-off
/// guess-then-check on each pair, so curiosity stays the point rather than
/// a tally of right/wrong.
class ParityScreen extends StatefulWidget {
  const ParityScreen({super.key});

  @override
  State<ParityScreen> createState() => _ParityScreenState();
}

class _ParityScreenState extends State<ParityScreen> {
  int _a = 3;
  int _b = 4;
  bool? _guessedEven;

  bool get _aEven => _a.isEven;
  bool get _bEven => _b.isEven;
  int get _sum => _a + _b;
  bool get _sumEven => _sum.isEven;

  void _setA(int value) => setState(() {
        _a = value.clamp(0, 20);
        _guessedEven = null;
      });
  void _setB(int value) => setState(() {
        _b = value.clamp(0, 20);
        _guessedEven = null;
      });

  String _parityLabel(bool even) => even ? 'even' : 'odd';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final guessed = _guessedEven != null;
    final guessCorrect = guessed && _guessedEven == _sumEven;

    return MathMagicActivityScaffold(
      title: 'Parity',
      caption:
          'Every whole number is either odd or even. Pick two numbers, guess whether their sum will be odd or even, then check.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: AppSpacing.sm,
            children: [
              _NumberDial(
                  label: 'First number',
                  value: _a,
                  even: _aEven,
                  onChanged: _setA),
              _NumberDial(
                  label: 'Second number',
                  value: _b,
                  even: _bEven,
                  onChanged: _setB),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Will $_a + $_b be odd or even?',
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed:
                    guessed ? null : () => setState(() => _guessedEven = false),
                child: const Text('Odd'),
              ),
              OutlinedButton(
                onPressed:
                    guessed ? null : () => setState(() => _guessedEven = true),
                child: const Text('Even'),
              ),
            ],
          ),
          if (guessed) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: guessCorrect ? colors.success : colors.warning),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_a + $_b = $_sum, which is ${_parityLabel(_sumEven)}.',
                    style: TextStyle(
                        color: guessCorrect ? colors.success : colors.warning,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_parityLabel(_aEven)} + ${_parityLabel(_bEven)} is always ${_parityLabel(_aEven == _bEven)}.',
                    style: TextStyle(color: colors.secondaryText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => setState(() {
                _a = (_a + 3) % 21;
                _b = (_b + 5) % 21;
                _guessedEven = null;
              }),
              icon: const Icon(Icons.refresh),
              label: const Text('Try another pair'),
            ),
          ],
        ],
      ),
    );
  }
}

class _NumberDial extends StatelessWidget {
  const _NumberDial({
    required this.label,
    required this.value,
    required this.even,
    required this.onChanged,
  });

  final String label;
  final int value;
  final bool even;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tint = even ? colors.accent : colors.warning;
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: colors.secondaryText, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: tint, width: 2),
          ),
          alignment: Alignment.center,
          child: Text('$value',
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800)),
        ),
        Text(even ? 'even' : 'odd',
            style: TextStyle(color: tint, fontWeight: FontWeight.w700)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => onChanged(value - 1),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}
