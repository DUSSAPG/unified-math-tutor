import 'package:flutter/widgets.dart';

class AppResponsive {
  static const double tabletMaxWidth = 680;
  static const double desktopMaxWidth = 760;

  static bool isPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width < 1024;
  }

  /// Kept for call sites that only need a binary phone-or-bigger split (e.g.
  /// whether to give content its full unconstrained width).
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1024;
  }

  /// Phones get the screen's full width (no cap). Tablets and desktop get a
  /// comfortable capped reading width instead of stretching cards edge to
  /// edge or floating a phone-narrow column in the middle of a large screen.
  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) return width;
    if (width < 1024) return tabletMaxWidth;
    return desktopMaxWidth;
  }
}
