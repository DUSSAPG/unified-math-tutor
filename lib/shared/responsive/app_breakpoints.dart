import 'package:flutter/widgets.dart';

class AppResponsive {
  static const double mobileMaxWidth = 390;
  static const double tabletMaxWidth = 700;
  static const double desktopMaxWidth = 720;

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1024;
  }

  static double contentMaxWidth(BuildContext context) {
    return isMobile(context) ? mobileMaxWidth : desktopMaxWidth;
  }
}
