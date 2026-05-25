import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';

/// Typography system — Plus Jakarta Sans (UI) + Space Grotesk (display).
abstract final class AppTextStyles {
  static TextStyle _plusJakarta({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle _spaceGrotesk({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Display
  static TextStyle displayExtraBold(bool isDark, {Color? color}) =>
      _spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.textPrimary(isDark),
      );

  static TextStyle displayBold(bool isDark, {Color? color}) =>
      _spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary(isDark),
      );

  static TextStyle appBarTitle(bool isDark) => _spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle appBarTitleMedium(bool isDark) => _spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle appName(bool isDark) => _spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle splashTitle() => _spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textOnGradient,
      );

  static TextStyle categoryTitle() => _spaceGrotesk(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.textOnGradient,
      );

  static TextStyle categoryCardTitle() => _spaceGrotesk(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnGradient,
      );

  static TextStyle bannerTitle() => _spaceGrotesk(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnGradient,
      );

  static TextStyle detailTitle(bool isDark) => _spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle photographerName(bool isDark) => _spaceGrotesk(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(isDark),
      );

  // Section labels (ALL CAPS)
  static TextStyle sectionLabel(bool isDark) => _plusJakarta(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary(isDark),
        letterSpacing: 2.0,
      );

  static TextStyle settingsSectionHeader(bool isDark) => _plusJakarta(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary(isDark),
        letterSpacing: 2.0,
      );

  // Body
  static TextStyle bodyRegular(bool isDark, {Color? color}) => _plusJakarta(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary(isDark),
      );

  static TextStyle bodyMedium(bool isDark, {Color? color}) => _plusJakarta(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary(isDark),
      );

  static TextStyle bodySemiBold(bool isDark, {Color? color}) => _plusJakarta(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary(isDark),
      );

  static TextStyle tagline() => _plusJakarta(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
      );

  static TextStyle onboardingDesc() => _plusJakarta(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
        height: 1.5,
      );

  static TextStyle subtitle(bool isDark) => _plusJakarta(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary(isDark),
        height: 1.4,
      );

  static TextStyle settingLabel(bool isDark) => _plusJakarta(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle settingValue(bool isDark) => _plusJakarta(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary(isDark),
      );

  // Captions
  static TextStyle caption(bool isDark, {Color? color}) => _plusJakarta(
        fontSize: 11,
        fontWeight: FontWeight.w300,
        color: color ?? AppColors.textSecondary(isDark),
        letterSpacing: 1.2,
      );

  static TextStyle badge(bool isDark) => _plusJakarta(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnGradient,
      );

  static TextStyle chip(bool isDark, {bool active = false}) => _plusJakarta(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: active ? AppColors.textOnGradient : AppColors.textPrimary(isDark),
      );

  static TextStyle actionLabel(bool isDark) => _plusJakarta(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary(isDark),
      );

  static TextStyle rankBadge() => _plusJakarta(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnGradient,
      );

  static TextStyle seeAll(bool isDark) => _plusJakarta(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.accentPrimary,
      );

  static TextStyle buttonPrimary() => _plusJakarta(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnGradient,
      );

  static TextStyle statLabel(bool isDark) => _plusJakarta(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary(isDark),
      );

  static TextStyle statValue(bool isDark) => _plusJakarta(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle searchHint(bool isDark) => _plusJakarta(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary(isDark),
      );

  static TextStyle emptyTitle(bool isDark) => _spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle noInternetTitle() => _spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
      );
}
