import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/labs/lab_controls/lab_control_breakpoint.dart';
import '../../widgets/labs/spatial_cube/spatial_cube_controller.dart';
import '../../widgets/labs/spatial_cube/spatial_cube_controls.dart';
import '../../widgets/labs/spatial_cube/spatial_cube_widget.dart';
import '../../widgets/shared/route_link_card.dart';

/// Spatial Cube Lab landing page: a free-play preview of the reusable
/// [SpatialCube] engine (doubles as the "optional automatic
/// demonstration" the brief calls for) plus route cards into the four
/// activities. Mirrors [InteractiveLabsHubScreen]/[SpatialIntelligenceScreen]'s
/// plain-hub pattern rather than [LabScaffold] — there's no single mission
/// to complete here, just an entry point.
class SpatialCubeLabHubScreen extends StatefulWidget {
  const SpatialCubeLabHubScreen({super.key});

  @override
  State<SpatialCubeLabHubScreen> createState() =>
      _SpatialCubeLabHubScreenState();
}

class _SpatialCubeLabHubScreenState extends State<SpatialCubeLabHubScreen>
    with TickerProviderStateMixin {
  late final SpatialCubeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpatialCubeController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    final breakpoint = resolveLabControlBreakpoint(context);
    final sideRail = labControlHasSideRailWidth(breakpoint);

    final preview = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SpatialCube(
            key: const Key('spatialCubeHubPreview'),
            controller: _controller,
            size: 220,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.labsSpatialCubeLabFreePlayCaption,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.secondaryText, fontSize: 12),
        ),
      ],
    );

    final controls = SpatialCubeControls(
      controller: _controller,
      breakpoint: breakpoint,
      reduceMotion: reduceMotion,
      compact: true,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/math-studio/interactive-labs'),
        ),
        title: Text(l10n.labsSpatialCubeLabTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labsSpatialCubeLabIntro,
                    style: TextStyle(
                        color: colors.secondaryText, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  sideRail
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: preview),
                            const SizedBox(width: AppSpacing.md),
                            controls,
                          ],
                        )
                      : Column(
                          children: [
                            preview,
                            const SizedBox(height: AppSpacing.md),
                            controls,
                          ],
                        ),
                  const SizedBox(height: AppSpacing.lg),
                  RouteLinkCard(
                    icon: LucideIcons.shuffle,
                    iconColor: const Color(0xFFE53935),
                    title: l10n.labsSpatialCubeWhichFaceOppositeTitle,
                    subtitle: l10n.labsSpatialCubeWhichFaceOppositeSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/spatial-cube-lab/which-face-opposite'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.rotateCw,
                    iconColor: const Color(0xFF5B8EFF),
                    title: l10n.labsSpatialCubeRotateToMatchTitle,
                    subtitle: l10n.labsSpatialCubeRotateToMatchSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/spatial-cube-lab/rotate-to-match'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.eyeOff,
                    iconColor: const Color(0xFF7C5FFF),
                    title: l10n.labsSpatialCubeHiddenFaceTitle,
                    subtitle: l10n.labsSpatialCubeHiddenFaceSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/spatial-cube-lab/hidden-face'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.boxes,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.labsSpatialCubeNetExplorerTitle,
                    subtitle: l10n.labsSpatialCubeNetExplorerSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/spatial-cube-lab/cube-net-explorer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
