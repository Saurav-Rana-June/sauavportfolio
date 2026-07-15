import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Breakpoint-aware sizing that keeps mobile text and icons readable.
abstract final class AppScale {
  static double get _width => ScreenUtil().screenWidth;

  static bool get isMobile => _width < 600;
  static bool get isTablet => _width >= 600 && _width <= 1024;
  static bool get isDesktop => _width > 1024;

  static double font(double size) {
    if (isMobile) {
      final double scale = ScreenUtil().scaleText;
      final double t = (_width - 320) / (600 - 320);
      final double adaptedScale = (0.72 + t * (0.84 - 0.72)).clamp(0.70, 0.85);
      return ScreenUtil().setSp(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
    } else if (isTablet) {
      final double scale = ScreenUtil().scaleText;
      final double t = (_width - 600) / (1024 - 600);
      final double adaptedScale = (0.85 + t * (0.95 - 0.85)).clamp(0.85, 0.95);
      return ScreenUtil().setSp(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
    } else {
      // Restore desktop / web view font size calculation to exactly what it was before
      return size * (_width / 1440).clamp(1.0, 1.12);
    }
  }

  static double displayLarge() => font(48);

  static double displayMedium() => font(32);

  static double headline() => font(24);

  static double title() => font(18);

  static double icon(double size) {
    if (isMobile) return (size + 5).clamp(22.0, 30.0);
    if (isTablet) return size + 2;
    return size * (_width / 1440).clamp(0.95, 1.08);
  }

  static double w(double size) {
    final double scale = ScreenUtil().scaleWidth;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale;
    } else if (isTablet) {
      // Scale from 0.85 to 1.0
      final t = (_width - 600) / (1024 - 600);
      adaptedScale = 0.85 + t * (1.0 - 0.85);
    } else {
      // Mobile: scale from 0.65 to 0.85
      final t = (_width - 320) / (600 - 320);
      adaptedScale = 0.65 + t * (0.85 - 0.65);
      adaptedScale = adaptedScale.clamp(0.65, 0.9);
    }
    return ScreenUtil().setWidth(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  static double h(double size) {
    final double scale = ScreenUtil().scaleHeight;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale;
    } else if (isTablet) {
      // Scale from 0.80 to 0.95
      final t = (_width - 600) / (1024 - 600);
      adaptedScale = 0.80 + t * (0.95 - 0.80);
    } else {
      // Mobile: scale from 0.60 to 0.80
      final t = (_width - 320) / (600 - 320);
      adaptedScale = 0.60 + t * (0.80 - 0.60);
      adaptedScale = adaptedScale.clamp(0.60, 0.85);
    }
    return ScreenUtil().setHeight(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  static double r(double size) {
    final double scale = ScreenUtil().scaleWidth;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale.clamp(0.9, 1.0);
    } else if (isTablet) {
      adaptedScale = 0.9;
    } else {
      adaptedScale = 0.8;
    }
    return ScreenUtil().radius(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
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
