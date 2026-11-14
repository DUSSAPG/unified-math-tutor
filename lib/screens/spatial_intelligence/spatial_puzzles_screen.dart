import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'spatial_activity_scaffold.dart';

/// Which puzzles a visit shows. [all] is the Spatial Intelligence pillar's
/// original 5-puzzle set. [shapeProperties] is the Topic Hub's KS2
/// Geometry & Measures entry (Coverage Truth Repair V1): only the three
/// verified face/edge/vertex 3D-shape-property puzzles — the cube-counting
/// and mirror-image items have no single verified curriculum strand
/// (STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 6) and are excluded.
enum SpatialPuzzleSet {
  all,
  shapeProperties;

  static const shapePropertiesQueryValue = 'shape-properties';

  static SpatialPuzzleSet fromQuery(String? value) =>
      value == shapePropertiesQueryValue ? shapeProperties : all;
}

class _Puzzle {
  const _Puzzle({
    required this.id,
    required this.isShapeProperty,
    required this.prompt,
    required this.build,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;

  /// True only for face/edge/vertex questions about named 3D shapes.
  final bool isShapeProperty;
  final String prompt;
  final WidgetBuilder? build;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

/// A small fixed set of spatial-reasoning puzzles — cube counting, mirror
/// images and 3D-shape facts — each multiple choice with immediate
/// feedback, cycling with "Next puzzle". Not a scored quiz mode: there is
/// no running score, streak or timer, matching the calm, exploratory tone
/// the rest of Studio's untimed formats already use.
final _puzzles = <_Puzzle>[
  _Puzzle(
    id: 'stack-cube-count',
    isShapeProperty: false,
    prompt: 'How many cubes make up this stack?',
    build: (context) => const _StackedCubesDiagram(),
    options: const ['6', '8', '9', '10'],
    correctIndex: 1,
    explanation:
        'There are 4 cubes in the bottom layer and 4 on top of them: 4 + 4 = 8.',
  ),
  _Puzzle(
    id: 'mirror-image',
    isShapeProperty: false,
    prompt: 'Which shape is the mirror image of the shaded one?',
    build: (context) => const _MirrorChoiceDiagram(),
    options: const ['A', 'B', 'C'],
    correctIndex: 0,
    explanation:
        'A mirror image is flipped left-to-right, not rotated — shape A is the correct reflection.',
  ),
  _Puzzle(
    id: 'triangular-prism-faces',
    isShapeProperty: true,
    prompt: 'How many faces does a triangular prism have?',
    build: null,
    options: const ['4', '5', '6'],
    correctIndex: 1,
    explanation:
        'A triangular prism has 2 triangular faces (the ends) and 3 rectangular faces (the sides): 2 + 3 = 5.',
  ),
  _Puzzle(
    id: 'cube-vertices',
    isShapeProperty: true,
    prompt: 'How many vertices (corner points) does a cube have?',
    build: null,
    options: const ['6', '8', '12'],
    correctIndex: 1,
    explanation:
        'A cube has 8 corners — 4 on the top face and 4 directly below them on the bottom face.',
  ),
  _Puzzle(
    id: 'square-pyramid-edges',
    isShapeProperty: true,
    prompt: 'How many edges does a square-based pyramid have?',
    build: null,
    options: const ['6', '8', '10'],
    correctIndex: 1,
    explanation:
        'A square-based pyramid has 4 edges around its square base, plus 4 edges running up to the top point: 4 + 4 = 8.',
  ),
];

/// The puzzles shown for [set], in their original order.
List<String> spatialPuzzleIdsFor(SpatialPuzzleSet set) => [
      for (final p in _puzzlesFor(set)) p.id,
    ];

List<_Puzzle> _puzzlesFor(SpatialPuzzleSet set) => switch (set) {
      SpatialPuzzleSet.all => _puzzles,
      SpatialPuzzleSet.shapeProperties =>
        _puzzles.where((p) => p.isShapeProperty).toList(growable: false),
    };

class SpatialPuzzlesScreen extends StatefulWidget {
  const SpatialPuzzlesScreen({
    super.key,
    this.puzzleSet = SpatialPuzzleSet.all,
  });

  final SpatialPuzzleSet puzzleSet;

  @override
  State<SpatialPuzzlesScreen> createState() => _SpatialPuzzlesScreenState();
}

class _SpatialPuzzlesScreenState extends State<SpatialPuzzlesScreen> {
  int _index = 0;
  int? _selected;

  late final List<_Puzzle> _set = _puzzlesFor(widget.puzzleSet);

  _Puzzle get _puzzle => _set[_index];

  void _choose(int optionIndex) => setState(() => _selected = optionIndex);

  void _next() {
    setState(() {
      _index = (_index + 1) % _set.length;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final answered = _selected != null;
    final correct = answered && _selected == _puzzle.correctIndex;

    final shapeOnly = widget.puzzleSet == SpatialPuzzleSet.shapeProperties;
    return SpatialActivityScaffold(
      title: shapeOnly ? '3D Shape Properties' : 'Spatial Puzzles',
      caption: shapeOnly
          ? 'Count the faces, edges and vertices of 3D shapes — no timer, no score.'
          : 'Short spatial-reasoning puzzles — no timer, no score. Take your time and think it through.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Puzzle ${_index + 1} of ${_set.length}',
              style: TextStyle(color: colors.secondaryText, fontSize: 12)),
          const SizedBox(height: AppSpacing.sm),
          Text(_puzzle.prompt,
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          if (_puzzle.build != null) ...[
            Center(
              child: SizedBox(
                  height: 160, width: 200, child: _puzzle.build!(context)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _puzzle.options.length; i++)
                _OptionChip(
                  label: _puzzle.options[i],
                  selected: _selected == i,
                  isCorrectAnswer: answered && i == _puzzle.correctIndex,
                  isWrongSelection:
                      answered && _selected == i && i != _puzzle.correctIndex,
                  onTap: answered ? null : () => _choose(i),
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
                  Text(_puzzle.explanation,
                      style: TextStyle(color: colors.secondaryText)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next puzzle'),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.isCorrectAnswer,
    required this.isWrongSelection,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isCorrectAnswer;
  final bool isWrongSelection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    Color? borderColor;
    if (isCorrectAnswer) borderColor = colors.success;
    if (isWrongSelection) borderColor = colors.warning;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 56, minHeight: 48),
      child: OutlinedButton(
        onPressed: onTap,
        style: borderColor == null
            ? null
            : OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor, width: 2)),
        child: Text(label),
      ),
    );
  }
}

/// 4 cubes on the bottom layer, 4 stacked directly on top — a simple
/// isometric-style diagram, not a full 3D render.
class _StackedCubesDiagram extends StatelessWidget {
  const _StackedCubesDiagram();

  @override
  Widget build(BuildContext context) {
    final lab = context.labColors;
    return Semantics(
      label: 'Two stacked layers of 2 by 2 cubes, 8 cubes in total.',
      image: true,
      child: ExcludeSemantics(
        child: CustomPaint(
          painter: _StackedCubesPainter(cubeColor: lab.robotColor),
          size: const Size(double.infinity, double.infinity),
        ),
      ),
    );
  }
}

class _StackedCubesPainter extends CustomPainter {
  const _StackedCubesPainter({required this.cubeColor});
  final Color cubeColor;

  @override
  void paint(Canvas canvas, Size size) {
    const cube = 46.0;
    const skew = 18.0;
    void drawCube(double bx, double by) {
      final top = Path()
        ..moveTo(bx, by)
        ..lineTo(bx + cube, by)
        ..lineTo(bx + cube - skew, by - skew)
        ..lineTo(bx - skew, by - skew)
        ..close();
      final front = Path()
        ..moveTo(bx, by)
        ..lineTo(bx + cube, by)
        ..lineTo(bx + cube, by + cube)
        ..lineTo(bx, by + cube)
        ..close();
      final side = Path()
        ..moveTo(bx + cube, by)
        ..lineTo(bx + cube - skew, by - skew)
        ..lineTo(bx + cube - skew, by + cube - skew)
        ..lineTo(bx + cube, by + cube)
        ..close();
      canvas.drawPath(front, Paint()..color = cubeColor.withValues(alpha: 0.9));
      canvas.drawPath(top, Paint()..color = cubeColor.withValues(alpha: 0.6));
      canvas.drawPath(side, Paint()..color = cubeColor.withValues(alpha: 0.4));
      final outline = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawPath(front, outline);
      canvas.drawPath(top, outline);
      canvas.drawPath(side, outline);
    }

    final originX = size.width / 2 - cube;
    final bottomY = size.height - cube - skew;
    // Bottom layer: 2x2.
    drawCube(originX, bottomY);
    drawCube(originX + cube, bottomY - 8);
    drawCube(originX - skew, bottomY - skew);
    drawCube(originX + cube - skew, bottomY - skew - 8);
    // Top layer, offset upward by one cube height.
    drawCube(originX, bottomY - cube);
    drawCube(originX + cube, bottomY - 8 - cube);
    drawCube(originX - skew, bottomY - skew - cube);
    drawCube(originX + cube - skew, bottomY - skew - 8 - cube);
  }

  @override
  bool shouldRepaint(covariant _StackedCubesPainter oldDelegate) =>
      oldDelegate.cubeColor != cubeColor;
}

/// A shaded L-tromino next to 3 candidates (A, B, C) — only A is a true
/// mirror image (flipped), B is a rotation and C is unrelated, so the
/// puzzle actually tests "reflection vs. rotation," a common confusion.
class _MirrorChoiceDiagram extends StatelessWidget {
  const _MirrorChoiceDiagram();

  static const _original = [
    Offset(0, 0),
    Offset(2, 0),
    Offset(2, 1),
    Offset(1, 1),
    Offset(1, 2),
    Offset(0, 2),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LabeledShape(
            label: '',
            points: _original,
            color: colors.accent,
            showLabel: false),
        _LabeledShape(
            label: 'A',
            points: [for (final p in _original) Offset(2 - p.dx, p.dy)],
            color: colors.secondaryText),
        _LabeledShape(
            label: 'B',
            points: [for (final p in _original) Offset(p.dy, 2 - p.dx)],
            color: colors.secondaryText),
        _LabeledShape(
            label: 'C',
            points: const [
              Offset(0, 0),
              Offset(2, 0),
              Offset(2, 2),
              Offset(0, 2),
            ],
            color: colors.secondaryText),
      ],
    );
  }
}

class _LabeledShape extends StatelessWidget {
  const _LabeledShape({
    required this.label,
    required this.points,
    required this.color,
    this.showLabel = true,
  });

  final String label;
  final List<Offset> points;
  final Color color;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CustomPaint(
            painter: _SimplePolygonPainter(points: points, color: color),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: context.appColors.primaryText,
                  fontWeight: FontWeight.w700)),
        ],
      ],
    );
  }
}

class _SimplePolygonPainter extends CustomPainter {
  const _SimplePolygonPainter({required this.points, required this.color});
  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const scale = 14.0;
    final path = Path()
      ..moveTo(points.first.dx * scale, size.height - points.first.dy * scale);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx * scale, size.height - p.dy * scale);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.7));
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _SimplePolygonPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
