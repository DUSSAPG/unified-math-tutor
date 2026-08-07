import 'package:flutter/material.dart';

import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'spatial_activity_scaffold.dart';
import 'spatial_shape_painter.dart';
import 'spatial_shapes.dart';

/// A shape rotates about a fixed centre point — by a preset 90°/180°/270°
/// step or continuously via a slider — so the learner can see exactly how
/// rotation moves every point through the same angle.
class RotationsScreen extends StatefulWidget {
  const RotationsScreen({super.key});

  @override
  State<RotationsScreen> createState() => _RotationsScreenState();
}

class _RotationsScreenState extends State<RotationsScreen> {
  double _angle = 0;

  void _setAngle(double value) => setState(() => _angle = value % 360);
  void _step(double delta) => _setAngle(_angle + delta);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SpatialActivityScaffold(
      title: 'Rotations',
      caption:
          'Rotating a shape turns every point through the same angle around a fixed centre point. The shape\'s size and form never change — only its direction.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 240,
              width: 240,
              child: Semantics(
                label:
                    'An L-shaped tile, rotated ${_angle.round()} degrees from its starting position, with the original outline shown for comparison.',
                image: true,
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: SpatialShapePainter(
                      original: kLShape,
                      transformed: rotatedPoints(kLShape, _angle),
                      showOriginalOutline: true,
                      originalColor: colors.tertiaryText,
                      shapeColor: colors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Rotation: ${_angle.round()}°',
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          Slider(
            value: _angle,
            min: 0,
            max: 360,
            divisions: 72,
            label: '${_angle.round()}°',
            onChanged: _setAngle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                  onPressed: () => _step(90), child: const Text('+90°')),
              OutlinedButton(
                  onPressed: () => _step(180), child: const Text('+180°')),
              OutlinedButton(
                  onPressed: () => _step(270), child: const Text('+270°')),
              TextButton(
                  onPressed: () => _setAngle(0), child: const Text('Reset')),
            ],
          ),
        ],
      ),
    );
  }
}
