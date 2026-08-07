import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../lab_controls/lab_control_breakpoint.dart';
import '../lab_controls/lab_control_rail.dart';
import 'flight_approach_controller.dart';

/// The shared control cluster every Aircraft Landing Lab activity offers:
/// a descent-angle slider, an airspeed slider (either can be hidden per
/// activity — e.g. Vector Approach replaces both with its own component
/// sliders), and a "Test Approach" button. Labels are passed in
/// (already localized) rather than hardcoded, matching
/// `FlightPathLabScreen`'s existing localization convention for its own
/// heading/speed sliders.
class FlightApproachControls extends StatelessWidget {
  const FlightApproachControls({
    super.key,
    required this.controller,
    required this.breakpoint,
    required this.angleLabel,
    required this.speedLabel,
    required this.testButtonLabel,
    required this.onTestApproach,
    this.showAngleControl = true,
    this.showSpeedControl = true,
    this.minAngleDegrees = 1,
    this.maxAngleDegrees = 20,
    this.minSpeedMps = 30,
    this.maxSpeedMps = 100,
    this.testEnabled = true,
    this.semanticLabel = 'Approach controls',
  });

  final FlightApproachController controller;
  final LabControlBreakpoint breakpoint;
  final String Function(int degrees) angleLabel;
  final String Function(int metresPerSecond) speedLabel;
  final String testButtonLabel;
  final VoidCallback onTestApproach;
  final bool showAngleControl;
  final bool showSpeedControl;
  final double minAngleDegrees;
  final double maxAngleDegrees;
  final double minSpeedMps;
  final double maxSpeedMps;
  final bool testEnabled;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sideRail = labControlHasSideRailWidth(breakpoint);

    final content = ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final model = controller.model;
        final angleDegrees =
            model.descentAngleDegrees.clamp(minAngleDegrees, maxAngleDegrees);
        final speed = model.airspeedMps.clamp(minSpeedMps, maxSpeedMps);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAngleControl) ...[
              Text(
                angleLabel(angleDegrees.round()),
                style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              Slider(
                key: const Key('flightApproachAngleSlider'),
                value: angleDegrees,
                min: minAngleDegrees,
                max: maxAngleDegrees,
                divisions: (maxAngleDegrees - minAngleDegrees).round(),
                label: '${angleDegrees.round()}°',
                onChanged: (value) =>
                    controller.updateAngle(value * math.pi / 180),
              ),
            ],
            if (showSpeedControl) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                speedLabel(speed.round()),
                style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              Slider(
                key: const Key('flightApproachSpeedSlider'),
                value: speed,
                min: minSpeedMps,
                max: maxSpeedMps,
                divisions: ((maxSpeedMps - minSpeedMps) / 5).round(),
                label: '${speed.round()} m/s',
                onChanged: controller.updateSpeed,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: testEnabled ? onTestApproach : null,
                child: Text(testButtonLabel),
              ),
            ),
          ],
        );
      },
    );

    return LabControlRail(
      position: sideRail
          ? LabControlRailPosition.right
          : LabControlRailPosition.bottom,
      semanticLabel: semanticLabel,
      child: content,
    );
  }
}
