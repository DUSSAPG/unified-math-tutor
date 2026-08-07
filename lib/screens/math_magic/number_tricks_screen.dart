import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'math_magic_activity_scaffold.dart';

/// The classic "1089 trick": pick any 3-digit number whose first and last
/// digits differ, reverse it, subtract the smaller from the larger,
/// reverse that result and add — the answer is always 1089. A genuine,
/// self-verifying mathematical curiosity (not a authored-fact claim the
/// learner has to trust), computed live from whatever digits they choose.
class NumberTricksScreen extends StatefulWidget {
  const NumberTricksScreen({super.key});

  @override
  State<NumberTricksScreen> createState() => _NumberTricksScreenState();
}

class _NumberTricksScreenState extends State<NumberTricksScreen> {
  int _hundreds = 5;
  int _tens = 3;
  int _units = 2;
  bool _revealed = false;

  int get _number => _hundreds * 100 + _tens * 10 + _units;
  int get _reversed => _units * 100 + _tens * 10 + _hundreds;
  int get _difference => (_number - _reversed).abs();
  String get _differenceDigits => _difference.toString().padLeft(3, '0');
  int get _differenceReversed =>
      int.parse(_differenceDigits.split('').reversed.join());
  int get _finalSum => _difference + _differenceReversed;

  void _setUnits(int value) {
    setState(() {
      _units = value;
      // The trick needs the first and last digit to differ — nudge units
      // away from hundreds instead of silently producing a broken result.
      if (_units == _hundreds) _units = (_units + 1) % 10;
      _revealed = false;
    });
  }

  void _setHundreds(int value) {
    setState(() {
      _hundreds = value.clamp(1, 9);
      if (_units == _hundreds) _units = (_units + 1) % 10;
      _revealed = false;
    });
  }

  void _setTens(int value) {
    setState(() {
      _tens = value;
      _revealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MathMagicActivityScaffold(
      title: 'Visual Number Tricks',
      caption:
          'Pick any 3-digit number where the first and last digit are different. Reverse it, find the difference, reverse that — and add. Try it below.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$_hundreds$_tens$_units',
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: AppSpacing.sm,
            children: [
              _DigitStepper(
                  label: 'Hundreds',
                  value: _hundreds,
                  min: 1,
                  max: 9,
                  onChanged: _setHundreds),
              _DigitStepper(
                  label: 'Tens',
                  value: _tens,
                  min: 0,
                  max: 9,
                  onChanged: _setTens),
              _DigitStepper(
                  label: 'Units',
                  value: _units,
                  min: 0,
                  max: 9,
                  onChanged: _setUnits),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!_revealed)
            FilledButton.icon(
              onPressed: () => setState(() => _revealed = true),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Reveal the magic'),
            )
          else ...[
            _Step(label: 'Your number', value: '$_number'),
            _Step(label: 'Reversed', value: '$_reversed'),
            _Step(
                label: 'Difference',
                value:
                    '${_number > _reversed ? _number : _reversed} − ${_number > _reversed ? _reversed : _number} = $_difference'),
            _Step(
                label: 'Reverse the difference', value: '$_differenceReversed'),
            _Step(
                label: 'Add them together',
                value: '$_difference + $_differenceReversed = $_finalSum'),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.accent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Always 1089!',
                      style: TextStyle(
                          color: colors.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    'Try different digits above — as long as the first and last digit differ, this always ends at 1089.',
                    style: TextStyle(color: colors.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DigitStepper extends StatelessWidget {
  const _DigitStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: colors.secondaryText, fontSize: 12)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => onChanged(value <= min ? max : value - 1),
            ),
            SizedBox(
              width: 20,
              child: Text('$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colors.primaryText, fontWeight: FontWeight.w700)),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(value >= max ? min : value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: colors.secondaryText)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
