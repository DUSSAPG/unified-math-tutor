import 'package:flutter/material.dart';

import '../../../models/spatial_cube_orientation.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../lab_controls/lab_control_breakpoint.dart';
import '../lab_controls/lab_control_rail.dart';
import 'spatial_cube_controller.dart';

/// The shared control cluster every Spatial Cube Lab surface offers: four
/// camera snaps, Reset, and an auto-demonstration toggle (continuous spin,
/// or — under Reduce Motion — a manual step-through of
/// [kSpatialCubeDemoSteps]). Laid out in a [LabControlRail], side or
/// bottom depending on [breakpoint], matching every other Interactive
/// Lab's responsive control convention.
class SpatialCubeControls extends StatelessWidget {
  const SpatialCubeControls({
    super.key,
    required this.controller,
    required this.breakpoint,
    required this.reduceMotion,
    this.compact = false,
  });

  final SpatialCubeController controller;
  final LabControlBreakpoint breakpoint;
  final bool reduceMotion;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sideRail = labControlHasSideRailWidth(breakpoint);

    final buttons = [
      _SnapButton(
        icon: Icons.crop_square,
        label: 'Front',
        onPressed: () => controller.snapTo(CubeSnapTarget.front),
      ),
      _SnapButton(
        icon: Icons.vertical_align_top,
        label: 'Top',
        onPressed: () => controller.snapTo(CubeSnapTarget.top),
      ),
      _SnapButton(
        icon: Icons.view_sidebar,
        label: 'Side',
        onPressed: () => controller.snapTo(CubeSnapTarget.side),
      ),
      _SnapButton(
        icon: Icons.view_in_ar,
        label: 'Isometric',
        onPressed: () => controller.snapTo(CubeSnapTarget.isometric),
      ),
      _SnapButton(
        icon: Icons.replay,
        label: 'Reset',
        onPressed: controller.reset,
      ),
      ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _SnapButton(
          icon: reduceMotion
              ? Icons.skip_next
              : (controller.isAutoDemoRunning
                  ? Icons.stop_circle
                  : Icons.play_circle),
          label: reduceMotion ? 'Next face' : 'Demo',
          selected: controller.isAutoDemoRunning,
          onPressed: () {
            if (reduceMotion) {
              controller.stepAutoDemo();
            } else if (controller.isAutoDemoRunning) {
              controller.stopAutoDemo();
            } else {
              controller.startAutoDemo();
            }
          },
        ),
      ),
    ];

    final content = sideRail
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final button in buttons) ...[
                button,
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          )
        : Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            children: buttons,
          );

    return LabControlRail(
      position: sideRail
          ? LabControlRailPosition.right
          : LabControlRailPosition.bottom,
      semanticLabel: 'Cube view controls',
      compact: compact,
      child: DefaultTextStyle(
        style: TextStyle(color: colors.primaryText, fontSize: 11),
        child: content,
      ),
    );
  }
}

class _SnapButton extends StatelessWidget {
  const _SnapButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: label,
      selected: selected,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? colors.accent.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: colors.primaryText),
              const SizedBox(height: 2),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
