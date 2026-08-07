import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'spatial_activity_scaffold.dart';
import 'spatial_shape_painter.dart';
import 'spatial_shapes.dart';

enum _TransformKind { translate, reflect, rotate, enlarge }

/// The 4 classic transformations (translate, reflect, rotate, enlarge),
/// each with its own simple parameter control, always shown against the
/// same original outline for direct before/after comparison — the same
/// grid convention Rotations already uses.
class TransformationsScreen extends StatefulWidget {
  const TransformationsScreen({super.key});

  @override
  State<TransformationsScreen> createState() => _TransformationsScreenState();
}

class _TransformationsScreenState extends State<TransformationsScreen> {
  _TransformKind _kind = _TransformKind.translate;

  double _translateX = 1;
  double _translateY = 0;
  bool _reflectInXAxis = true;
  double _rotateAngle = 90;
  double _scale = 1.5;

  List<Offset> get _transformed => switch (_kind) {
        _TransformKind.translate =>
          translatedPoints(kLShape, _translateX, _translateY),
        _TransformKind.reflect =>
          reflectedPoints(kLShape, inXAxis: _reflectInXAxis),
        _TransformKind.rotate => rotatedPoints(kLShape, _rotateAngle),
        _TransformKind.enlarge => scaledPoints(kLShape, _scale),
      };

  String get _kindLabel => switch (_kind) {
        _TransformKind.translate => 'Translation',
        _TransformKind.reflect => 'Reflection',
        _TransformKind.rotate => 'Rotation',
        _TransformKind.enlarge => 'Enlargement',
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SpatialActivityScaffold(
      title: 'Transformations',
      caption:
          'A transformation changes a shape\'s position, orientation or size in a precise, describable way. Choose a transformation to see the original (dashed) and the result (solid) on the same grid.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<_TransformKind>(
            segments: const [
              ButtonSegment(
                  value: _TransformKind.translate,
                  label: Text('Translate'),
                  icon: Icon(Icons.open_with)),
              ButtonSegment(
                  value: _TransformKind.reflect,
                  label: Text('Reflect'),
                  icon: Icon(Icons.flip)),
              ButtonSegment(
                  value: _TransformKind.rotate,
                  label: Text('Rotate'),
                  icon: Icon(Icons.rotate_right)),
              ButtonSegment(
                  value: _TransformKind.enlarge,
                  label: Text('Enlarge'),
                  icon: Icon(Icons.zoom_out_map)),
            ],
            selected: {_kind},
            onSelectionChanged: (selection) =>
                setState(() => _kind = selection.single),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: SizedBox(
              height: 240,
              width: 240,
              child: Semantics(
                label:
                    '$_kindLabel applied to an L-shaped tile, shown solid, with the original outline shown dashed for comparison.',
                image: true,
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: SpatialShapePainter(
                      original: kLShape,
                      transformed: _transformed,
                      showOriginalOutline: true,
                      originalColor: colors.tertiaryText,
                      shapeColor: colors.accent,
                      unitsAcross: _kind == _TransformKind.enlarge ? 6.5 : 4.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _controlsFor(context, colors),
        ],
      ),
    );
  }

  Widget _controlsFor(BuildContext context, AppSemanticColors colors) {
    switch (_kind) {
      case _TransformKind.translate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Move ${_translateX.round()} right, ${_translateY.round()} up',
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StepButton(
                    icon: Icons.arrow_upward,
                    onTap: () => setState(
                        () => _translateY = (_translateY + 1).clamp(-2, 2))),
                _StepButton(
                    icon: Icons.arrow_downward,
                    onTap: () => setState(
                        () => _translateY = (_translateY - 1).clamp(-2, 2))),
                _StepButton(
                    icon: Icons.west,
                    onTap: () => setState(
                        () => _translateX = (_translateX - 1).clamp(-2, 2))),
                _StepButton(
                    icon: Icons.east,
                    onTap: () => setState(
                        () => _translateX = (_translateX + 1).clamp(-2, 2))),
                TextButton(
                  onPressed: () => setState(() {
                    _translateX = 1;
                    _translateY = 0;
                  }),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        );
      case _TransformKind.reflect:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reflect in the:',
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('x-axis')),
                ButtonSegment(value: false, label: Text('y-axis')),
              ],
              selected: {_reflectInXAxis},
              onSelectionChanged: (selection) =>
                  setState(() => _reflectInXAxis = selection.single),
            ),
          ],
        );
      case _TransformKind.rotate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rotation: ${_rotateAngle.round()}°',
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
            Slider(
              value: _rotateAngle,
              min: 0,
              max: 360,
              divisions: 72,
              label: '${_rotateAngle.round()}°',
              onChanged: (value) => setState(() => _rotateAngle = value),
            ),
          ],
        );
      case _TransformKind.enlarge:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scale factor: ${_scale.toStringAsFixed(1)}×',
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
            Slider(
              value: _scale,
              min: 0.5,
              max: 2.5,
              divisions: 20,
              label: '${_scale.toStringAsFixed(1)}×',
              onChanged: (value) => setState(() => _scale = value),
            ),
          ],
        );
    }
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      child: OutlinedButton(
        onPressed: onTap,
        child: Icon(icon, size: 18),
      ),
    );
  }
}
