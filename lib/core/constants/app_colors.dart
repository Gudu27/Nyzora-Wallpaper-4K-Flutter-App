import 'package:flutter/material.dart';

/// Central color system — never hardcode hex in UI code.
abstract final class AppColors {
  // ── Dark (AMOLED default) ──────────────────────────────────────────
  static const Color appBackgroundDark = Color(0xFF000000);
  static const Color surfaceColorDark = Color(0xFF0D0D0D);
  static const Color surfaceVariantDark = Color(0xFF141414);
  static const Color surfaceHighlightDark = Color(0xFF1C1C1C);
  static const Color dividerColorDark = Color(0xFF1E1E1E);

  static const Color shimmerBaseDark = Color(0xFF1A1A1A);
  static const Color shimmerHighlightDark = Color(0xFF2C2C2C);

  static const Color textPrimaryDark = Color(0xFFF8F8F8);
  static const Color textSecondaryDark = Color(0xFF9B9BA0);
  static const Color textTertiaryDark = Color(0xFF5A5A60);
  static const Color textOnGradient = Color(0xFFFFFFFF);
  static const Color textDisabledDark = Color(0xFF3A3A3A);

  // ── Light ──────────────────────────────────────────────────────────
  static const Color appBackgroundLight = Color(0xFFF0F0F5);
  static const Color surfaceColorLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF8F8FC);
  static const Color textPrimaryLight = Color(0xFF0D0D1A);
  static const Color textSecondaryLight = Color(0xFF4A4A5A);

  // ── Accents (shared) ───────────────────────────────────────────────
  static const Color accentPrimary = Color(0xFF7C3AED);
  static const Color accentSecondary = Color(0xFF4F46E5);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentError = Color(0xFFEF4444);

  // ── Glass ────────────────────────────────────────────────────────────
  static const Color glassBackground = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const double glassBlurSigma = 20.0;

  // ── Gradients ────────────────────────────────────────────────────────
  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D0D2B), Color(0xFF000000)],
  );

  static const LinearGradient heroGradientLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8E8FF), Color(0xFFF0F0F5)],
  );

  static const LinearGradient accentGradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPrimary, accentSecondary],
  );

  static const LinearGradient accentGradient2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A3E), Color(0xFF0D0D1F)],
  );

  // ── Category gradients ───────────────────────────────────────────────
  static const Map<String, List<Color>> categoryGradients = {
    'nature': [Color(0xFF134E5E), Color(0xFF71B280)],
    'space': [Color(0xFF0F0C29), Color(0xFF302B63)],
    'abstract': [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    'animals': [Color(0xFF1A3A1A), Color(0xFF2D6A2D)],
    'city': [Color(0xFF1C1C2E), Color(0xFF3D3D5C)],
    'fantasy': [Color(0xFF2D1B69), Color(0xFF6B3FA0)],
    'minimal': [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    'dark': [Color(0xFF000000), Color(0xFF0D0D0D)],
    'neon': [Color(0xFF0D0221), Color(0xFF1A0533)],
    'architecture': [Color(0xFF1A1215), Color(0xFF3D1A28)],
    'ocean': [Color(0xFF0C3547), Color(0xFF1A6B8A)],
    'mountains': [Color(0xFF1B2838), Color(0xFF2A3F5F)],
    'flowers': [Color(0xFF2D1B1B), Color(0xFF6B2D3E)],
    'cars': [Color(0xFF0D0D0D), Color(0xFF1A1A2E)],
    'japanese': [Color(0xFF2D1515), Color(0xFF8B3A3A)],
    'patterns': [Color(0xFF1A0D2E), Color(0xFF3D1A5C)],
    'weather': [Color(0xFF0D1B2A), Color(0xFF1A3A5C)],
    'sunsets': [Color(0xFF2D1515), Color(0xFF8B4513)],
  };

  static LinearGradient categoryGradient(String key) {
    final colors = categoryGradients[key] ??
        categoryGradients['abstract']!;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  // ── Shadows ──────────────────────────────────────────────────────────
  static BoxShadow cardGlow = BoxShadow(
    color: accentPrimary.withValues(alpha: 0.2),
    blurRadius: 20,
    spreadRadius: 0,
  );

  static BoxShadow navBarShadow = const BoxShadow(
    color: Color(0x80000000),
    blurRadius: 20,
    offset: Offset(0, -4),
  );

  static BoxShadow dynamicGlow(Color color) => BoxShadow(
        color: color.withValues(alpha: 0.25),
        blurRadius: 30,
        spreadRadius: 0,
      );

  // Theme-aware helpers
  static Color appBackground(bool isDark, {bool amoled = true}) =>
      isDark ? (amoled ? appBackgroundDark : surfaceColorDark) : appBackgroundLight;

  static Color surfaceColor(bool isDark) =>
      isDark ? surfaceColorDark : surfaceColorLight;

  static Color surfaceVariant(bool isDark) =>
      isDark ? surfaceVariantDark : surfaceVariantLight;

  static Color surfaceHighlight(bool isDark) =>
      isDark ? surfaceHighlightDark : surfaceVariantLight;

  static Color dividerColor(bool isDark) =>
      isDark ? dividerColorDark : const Color(0xFFE0E0E8);

  static Color textPrimary(bool isDark) =>
      isDark ? textPrimaryDark : textPrimaryLight;

  static Color textSecondary(bool isDark) =>
      isDark ? textSecondaryDark : textSecondaryLight;

  static Color textTertiary(bool isDark) =>
      isDark ? textTertiaryDark : const Color(0xFF8A8A9A);

  static Color textDisabled(bool isDark) =>
      isDark ? textDisabledDark : const Color(0xFFB0B0BC);

  static LinearGradient heroGradient(bool isDark) =>
      isDark ? heroGradientDark : heroGradientLight;

  static Color shimmerBase(bool isDark) =>
      isDark ? shimmerBaseDark : const Color(0xFFE8E8EC);

  static Color shimmerHighlight(bool isDark) =>
      isDark ? shimmerHighlightDark : const Color(0xFFF5F5F8);
}
