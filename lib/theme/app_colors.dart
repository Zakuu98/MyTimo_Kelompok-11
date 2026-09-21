import 'package:flutter/material.dart';

/// Design tokens for MyTimo color palette extracted from Figma designs
class AppColors {
  AppColors._();

  // Primary Brand Colors (Farm / Agriculture Green)
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  static const Color primaryGreenLight = Color(0xFF4CAF50);
  static const Color primaryGreenSoft = Color(0xFFD4EAD9); // Secondary button on landing
  static const Color primaryGreenText = Color(0xFF1E6F29);
  static const Color greenBadgeBackground = Color(0xFFE8F5E9);

  // Tomato Accent Colors (AI / Alerts / Action)
  static const Color tomatoRed = Color(0xFFE53935);
  static const Color tomatoRedDark = Color(0xFFC62828);
  static const Color tomatoRedLight = Color(0xFFFFEBEE);
  static const Color tomatoBanner = Color(0xFFE04332);
  static const Color tomatoBannerDark = Color(0xFFCC3324);

  // Weather & Warnings
  static const Color warningOrange = Color(0xFFF57C00);
  static const Color warningOrangeLight = Color(0xFFFFF3E0);
  static const Color weatherCardBg = Color(0xFFE8F4EC);

  // Neutrals & Backgrounds
  static const Color background = Color(0xFFF8FAF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0D000000);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF2E7D32);
  static const Color divider = Color(0xFFEEEEEE);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient homeHeaderGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient scanBannerGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFEF5350)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient floatingScanGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
