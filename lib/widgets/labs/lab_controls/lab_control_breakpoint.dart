import 'package:flutter/widgets.dart';

import '../../../shared/responsive/app_breakpoints.dart';

/// Device/viewport classes an adaptive lab control layout responds to.
/// Built on top of [AppResponsive] (the app-wide phone/tablet/desktop
/// split) rather than redefining width thresholds, adding only the
/// portrait/landscape distinction the lab control layouts need on phones.
enum LabControlBreakpoint { phonePortrait, phoneLandscape, tablet, desktop }

LabControlBreakpoint resolveLabControlBreakpoint(BuildContext context) {
  if (AppResponsive.isDesktop(context)) return LabControlBreakpoint.desktop;
  if (AppResponsive.isTablet(context)) return LabControlBreakpoint.tablet;
  final size = MediaQuery.sizeOf(context);
  return size.width >= size.height
      ? LabControlBreakpoint.phoneLandscape
      : LabControlBreakpoint.phonePortrait;
}

/// True for [LabControlBreakpoint.phoneLandscape], [.tablet] and
/// [.desktop] — the breakpoints with enough width for side rails, as
/// opposed to [.phonePortrait] which stacks controls vertically.
bool labControlHasSideRailWidth(LabControlBreakpoint breakpoint) =>
    breakpoint != LabControlBreakpoint.phonePortrait;
