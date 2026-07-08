import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Breakpoint-aware sizing that keeps mobile text and icons readable.
abstract final class AppScale {
  static double get _width => ScreenUtil().screenWidth;

  static bool get isMobile => _width < 600;
  static bool get isTablet => _width >= 600 && _width < 960;
  static bool get isDesktop => _width >= 960;

  static double font(double size) {
    if (isMobile) return size + 1.5;
    if (isTablet) return size + 0.5;
    return size * (_width / 1440).clamp(1.0, 1.12);
  }

  static double displayLarge() {
    if (isMobile) return 36;
    if (isTablet) return 42;
    return 48;
  }

  static double displayMedium() {
    if (isMobile) return 28;
    if (isTablet) return 30;
    return 32;
  }

  static double headline() {
    if (isMobile) return 22;
    if (isTablet) return 23;
    return 24;
  }

  static double title() {
    if (isMobile) return 18;
    if (isTablet) return 18;
    return 18;
  }

  static double icon(double size) {
    if (isMobile) return (size + 5).clamp(22, 30);
    if (isTablet) return size + 2;
    return size * (_width / 1440).clamp(0.95, 1.08);
  }

  static double w(double size) {
    if (isMobile) return size;
    if (isTablet) return size * 1.05;
    return size * (_width / 1440);
  }

  static double h(double size) {
    if (isMobile) return size * 0.7;
    if (isTablet) return size * 0.85;
    return size * (_width / 1440);
  }

  static double r(double size) {
    if (isMobile) return size * 0.95;
    if (isTablet) return size;
    return size * (_width / 1440).clamp(0.9, 1.0);
  }

  static double pagePaddingHorizontal() {
    if (isMobile) return 16;
    if (isTablet) return 20;
    return 24;
  }

  static double sectionPaddingVertical() {
    if (isMobile) return 36;
    if (isTablet) return 42;
    return 48;
  }

  static double heroPaddingVertical() {
    if (isMobile) return 48;
    if (isTablet) return 64;
    return 80;
  }

  static double contentMaxWidth() {
    if (isMobile) return _width;
    if (isTablet) return 920;
    return 1200;
  }

  static double contactMaxWidth() {
    if (isMobile) return _width;
    return 800;
  }

  static double navTopSpacer() {
    if (isMobile) return 92;
    return 96;
  }
}
