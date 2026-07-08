import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';

class AppTextStyles {
  static TextStyle _bodyStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? _bodyLineHeight(fontSize),
      letterSpacing: letterSpacing ?? _bodyLetterSpacing(fontSize, fontWeight),
    );
  }

  static TextStyle _headingStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? _headingLineHeight(fontSize),
      letterSpacing: letterSpacing ?? _headingLetterSpacing(fontSize),
    );
  }

  static double _bodyLineHeight(double fontSize) {
    if (fontSize >= 18) return 1.35;
    return 1.55;
  }

  static double _headingLineHeight(double fontSize) {
    if (fontSize >= 32) return 1.08;
    if (fontSize >= 24) return 1.15;
    return 1.25;
  }

  static double _bodyLetterSpacing(double fontSize, FontWeight fontWeight) {
    if (fontSize <= 12 && fontWeight.index >= FontWeight.w500.index) return 0.6;
    return 0.1;
  }

  static double _headingLetterSpacing(double fontSize) {
    if (fontSize >= 32) return -1.1;
    if (fontSize >= 24) return -0.6;
    return -0.25;
  }

  static TextStyle get r12 => _bodyStyle(
        fontSize: AppScale.font(12),
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get r14 => _bodyStyle(
        fontSize: AppScale.font(14),
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get r16 => _bodyStyle(
        fontSize: AppScale.font(16),
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get m16 => _bodyStyle(
        fontSize: AppScale.font(16),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get sb18 => _headingStyle(
        fontSize: AppScale.title(),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get sb24 => _headingStyle(
        fontSize: AppScale.headline(),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get b32 => _headingStyle(
        fontSize: AppScale.displayMedium(),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get b48 => _headingStyle(
        fontSize: AppScale.displayLarge(),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextTheme get textTheme {
    final base = ThemeData.dark().textTheme;
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: b48,
      displayMedium: b32,
      headlineMedium: sb24,
      titleLarge: sb18,
      titleMedium: m16,
      bodyLarge: r16,
      bodyMedium: r14,
      bodySmall: r12,
      labelLarge: m16,
    );
  }
}
