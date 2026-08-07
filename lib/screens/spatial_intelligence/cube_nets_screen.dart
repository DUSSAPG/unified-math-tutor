import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'spatial_activity_scaffold.dart';

class _Net {
  const _Net({
    required this.cells,
    required this.foldsIntoCube,
    required this.explanation,
  });

  /// (row, col) grid positions of the net's 6 unit squares.
  final List<(int, int)> cells;
  final bool foldsIntoCube;
  final String explanation;
}

/// 4 hand-picked, verified nets — 2 that fold into a closed cube with no
/// gaps or overlaps, 2 that don't — the standard textbook examples used to
/// teach "which nets fold into a cube," not a procedurally generated or
/// exhaustive set (there are 11 valid hexomino cube nets in total; covering
/// all of them is future backlog, not this activity's minimum).
const _nets = <_Net>[
  _Net(
    cells: [(0, 1), (1, 0), (1, 1), (1, 2), (1, 3), (2, 1)],
    foldsIntoCube: true,
    explanation:
        'Yes — this is the classic cross net. Each square becomes one face, and folding along every edge closes into a cube with no gaps or overlaps.',
  ),
  _Net(
    cells: [(0, 0), (1, 0), (1, 1), (2, 1), (2, 2), (3, 2)],
    foldsIntoCube: true,
    explanation:
        'Yes — this staircase shape also folds into a closed cube, even though it looks less symmetric than the cross.',
  ),
  _Net(
    cells: [(0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5)],
    foldsIntoCube: false,
    explanation:
        'No — a straight line of 6 squares folds back on itself: two faces end up trying to occupy the same side of the cube.',
  ),
  _Net(
    cells: [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2)],
    foldsIntoCube: false,
    explanation:
        'No — a solid 2×3 block overlaps two faces on top of each other when folded, and leaves one side of the cube open.',
  ),
];

const _faceColors = [
  Color(0xFF5B8EFF),
  Color(0xFF34C759),
  Color(0xFFFF9500),
  Color(0xFFE85DAA),
  Color(0xFF7C5FFF),
  Color(0xFF00BCD4),
];

/// "Does this net fold into a closed cube?" — a small fixed set of nets,
/// each answered true/false with immediate feedback and an explanation,
/// cycling through with "Next net".
class CubeNetsScreen extends StatefulWidget {
  const CubeNetsScreen({super.key});

  @override
  State<CubeNetsScreen> createState() => _CubeNetsScreenState();
}

class _CubeNetsScreenState extends State<CubeNetsScreen> {
  int _index = 0;
  bool? _answeredFoldsIntoCube;

  _Net get _net => _nets[_index];

  void _answer(bool guess) {
    setState(() => _answeredFoldsIntoCube = guess);
  }

  void _next() {
    setState(() {
      _index = (_index + 1) % _nets.length;
      _answeredFoldsIntoCube = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final answered = _answeredFoldsIntoCube != null;
    final correct = answered && _answeredFoldsIntoCube == _net.foldsIntoCube;

    return SpatialActivityScaffold(
      title: 'Cube Nets',
      caption:
          'A net is a 2D shape that folds up into a 3D solid. Decide whether each net below folds into a closed cube.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Net ${_index + 1} of ${_nets.length}',
              style: TextStyle(color: colors.secondaryText, fontSize: 12)),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: SizedBox(
              height: 220,
              width: 220,
              child: Semantics(
                label:
                    'A net made of 6 connected squares, arranged in a shape you must decide folds into a cube or not.',
                image: true,
                child: ExcludeSemantics(
                  child: CustomPaint(painter: _NetPainter(cells: _net.cells)),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Does this net fold into a closed cube?',
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            children: [
              _AnswerButton(
                label: 'Yes',
                selected: _answeredFoldsIntoCube == true,
                onTap: answered ? null : () => _answer(true),
              ),
              _AnswerButton(
                label: 'No',
                selected: _answeredFoldsIntoCube == false,
                onTap: answered ? null : () => _answer(false),
              ),
            ],
          ),
          if (answered) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: correct ? colors.success : colors.warning),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    correct ? 'Correct!' : 'Not quite.',
                    style: TextStyle(
                        color: correct ? colors.success : colors.warning,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(_net.explanation,
                      style: TextStyle(color: colors.secondaryText)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next net'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return selected
        ? FilledButton(onPressed: onTap, child: Text(label))
        : OutlinedButton(onPressed: onTap, child: Text(label));
  }
}

class _NetPainter extends CustomPainter {
  const _NetPainter({required this.cells});

  final List<(int, int)> cells;

  @override
  void paint(Canvas canvas, Size size) {
    final maxRow = cells.map((c) => c.$1).reduce((a, b) => a > b ? a : b);
    final maxCol = cells.map((c) => c.$2).reduce((a, b) => a > b ? a : b);
    final gridWidth = maxCol + 1;
    final gridHeight = maxRow + 1;
    final cellSize =
        (size.width / gridWidth).clamp(0.0, size.height / gridHeight);
    final offset = Offset(
      (size.width - cellSize * gridWidth) / 2,
      (size.height - cellSize * gridHeight) / 2,
    );

    for (var i = 0; i < cells.length; i++) {
      final (row, col) = cells[i];
      final rect = Rect.fromLTWH(
        offset.dx + col * cellSize,
        offset.dy + row * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRect(
        rect.deflate(1.5),
        Paint()..color = _faceColors[i % _faceColors.length],
      );
      canvas.drawRect(
        rect.deflate(1.5),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NetPainter oldDelegate) =>
      oldDelegate.cells != cells;
}
