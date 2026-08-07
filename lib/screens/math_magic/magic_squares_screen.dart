import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'math_magic_activity_scaffold.dart';

const _target = 15;

/// A classic 3×3 magic square: place 1–9 so every row, column and diagonal
/// sums to 15. Tap a number to pick it up, tap a cell to place it (or tap a
/// filled cell to send its number back) — no drag gesture required, so it
/// works identically with touch, mouse, or keyboard/switch access. No
/// score, no timer: every line's sum is shown live, and the whole square
/// simply feels "solved" once everything turns green.
class MagicSquaresScreen extends StatefulWidget {
  const MagicSquaresScreen({super.key});

  @override
  State<MagicSquaresScreen> createState() => _MagicSquaresScreenState();
}

class _MagicSquaresScreenState extends State<MagicSquaresScreen> {
  List<int?> _cells = List.filled(9, null);
  int? _selectedNumber;

  List<int> get _availableNumbers => [
        for (var n = 1; n <= 9; n++)
          if (!_cells.contains(n)) n,
      ];

  bool get _isFull => !_cells.contains(null);

  bool get _isSolved =>
      _isFull && _allLineSums().every((sum) => sum == _target);

  List<int> _allLineSums() {
    int sum(List<int> indices) =>
        indices.fold(0, (acc, i) => acc + (_cells[i] ?? 0));
    return [
      sum([0, 1, 2]), sum([3, 4, 5]), sum([6, 7, 8]), // rows
      sum([0, 3, 6]), sum([1, 4, 7]), sum([2, 5, 8]), // columns
      sum([0, 4, 8]), sum([2, 4, 6]), // diagonals
    ];
  }

  void _tapCell(int index) {
    setState(() {
      if (_cells[index] != null) {
        // Filled cell: send its number back to the palette.
        _cells[index] = null;
        return;
      }
      if (_selectedNumber != null) {
        _cells[index] = _selectedNumber;
        _selectedNumber = null;
      }
    });
  }

  void _tapPaletteNumber(int number) {
    setState(() => _selectedNumber = _selectedNumber == number ? null : number);
  }

  void _clear() {
    setState(() {
      _cells = List.filled(9, null);
      _selectedNumber = null;
    });
  }

  void _reveal() {
    // One well-known solution — the "Lo Shu" square.
    setState(() {
      _cells = [4, 9, 2, 3, 5, 7, 8, 1, 6];
      _selectedNumber = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MathMagicActivityScaffold(
      title: 'Magic Squares',
      caption:
          'Place the numbers 1 to 9 so every row, column and diagonal adds up to the same total: 15. Tap a number, then tap a square to place it.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 210,
              height: 210,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => _Cell(
                  value: _cells[index],
                  onTap: () => _tapCell(index),
                  highlight: _isSolved,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_isSolved)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.success),
              ),
              child: Text(
                'Magic! Every row, column and diagonal adds up to 15.',
                style: TextStyle(
                    color: colors.success, fontWeight: FontWeight.w700),
              ),
            )
          else if (_isFull)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.divider),
              ),
              child: Text(
                'Not quite magic yet — some lines don\'t add up to 15. Tap a filled square to move a number.',
                style: TextStyle(color: colors.secondaryText),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Text('Numbers left to place:',
              style: TextStyle(color: colors.secondaryText, fontSize: 12)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final n in _availableNumbers)
                ChoiceChip(
                  label: Text('$n'),
                  selected: _selectedNumber == n,
                  onSelected: (_) => _tapPaletteNumber(n),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(onPressed: _clear, child: const Text('Clear')),
              TextButton(
                  onPressed: _reveal, child: const Text('Show me a solution')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(
      {required this.value, required this.onTap, required this.highlight});

  final int? value;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: highlight
          ? colors.success.withValues(alpha: 0.18)
          : colors.cardSurface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: highlight ? colors.success : colors.divider),
          ),
          child: Text(
            value?.toString() ?? '',
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
