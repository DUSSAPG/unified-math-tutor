import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/flight_approach_model.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/labs/lab_controls/lab_control_breakpoint.dart';
import '../../widgets/labs/flight_approach/flight_approach_controller.dart';
import '../../widgets/labs/flight_approach/flight_approach_controls.dart';
import '../../widgets/labs/flight_approach/flight_approach_view.dart';
import '../../widgets/shared/route_link_card.dart';

const _kDefaultAltitudeM = 300.0;
const _kDefaultGroundDistanceM = 5000.0;
const _kDefaultAirspeedMps = 60.0;

/// Aircraft Landing Lab landing page: a free-play side-profile preview
/// (starts already on the correct glide path, so dragging the angle/speed
/// sliders away and back is the first thing to try) plus route cards into
/// the four activities. Mirrors [SpatialCubeLabHubScreen]'s plain-hub
/// pattern rather than [LabScaffold] — no single mission to complete here.
class AircraftLandingLabHubScreen extends StatefulWidget {
  const AircraftLandingLabHubScreen({super.key});

  @override
  State<AircraftLandingLabHubScreen> createState() =>
      _AircraftLandingLabHubScreenState();
}

class _AircraftLandingLabHubScreenState
    extends State<AircraftLandingLabHubScreen>
    with SingleTickerProviderStateMixin {
  late final FlightApproachController _controller;

  @override
  void initState() {
    super.initState();
    const base = FlightApproachModel(
      startingAltitudeM: _kDefaultAltitudeM,
      groundDistanceM: _kDefaultGroundDistanceM,
      airspeedMps: _kDefaultAirspeedMps,
      descentAngleRadians: 0,
    );
    _controller = FlightApproachController(
      vsync: this,
      initialModel:
          base.copyWith(descentAngleRadians: base.requiredGlideAngleRadians),
    );
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
    final lab = context.labColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    _controller.motionEnabled = !reduceMotion;
    final breakpoint = resolveLabControlBreakpoint(context);
    final sideRail = labControlHasSideRailWidth(breakpoint);

    final preview = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlightApproachView(
          key: const Key('aircraftLandingHubPreview'),
          controller: _controller,
          axisColor: colors.divider,
          targetPathColor: lab.radarTarget,
          actualPathColor: lab.flightPath,
          aircraftColor: lab.radarLanding,
          runwayColor: lab.radarGrid,
          size: const Size(320, 200),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.labsAircraftLandingLabFreePlayCaption,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.secondaryText, fontSize: 12),
        ),
      ],
    );

    final controls = FlightApproachControls(
      controller: _controller,
      breakpoint: breakpoint,
      angleLabel: (degrees) =>
          l10n.labsAircraftLandingDescentAngleLabel(degrees),
      speedLabel: (mps) => l10n.labsAircraftLandingAirspeedLabel(mps),
      testButtonLabel: l10n.labsAircraftLandingTestApproachButton,
      onTestApproach: _controller.testApproach,
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
        title: Text(l10n.labsAircraftLandingLabTitle,
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
                    l10n.labsAircraftLandingLabIntro,
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
                    icon: LucideIcons.clock,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.labsAircraftLandingFindTheTimeTitle,
                    subtitle: l10n.labsAircraftLandingFindTheTimeSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/aircraft-landing-lab/find-the-time'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.trendingDown,
                    iconColor: const Color(0xFF5B8EFF),
                    title: l10n.labsAircraftLandingDescentLineTitle,
                    subtitle: l10n.labsAircraftLandingDescentLineSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/aircraft-landing-lab/follow-the-descent-line'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.planeLanding,
                    iconColor: const Color(0xFFFFBD00),
                    title: l10n.labsAircraftLandingGlidePathTitle,
                    subtitle: l10n.labsAircraftLandingGlidePathSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/aircraft-landing-lab/land-on-the-glide-path'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.moveDiagonal,
                    iconColor: const Color(0xFF7C5FFF),
                    title: l10n.labsAircraftLandingVectorApproachTitle,
                    subtitle: l10n.labsAircraftLandingVectorApproachSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/aircraft-landing-lab/vector-approach'),
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
