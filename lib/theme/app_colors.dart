import 'package:flutter/material.dart';

/// Design tokens warna MyTimo sesuai Screenshot Desain UI Baru & PRD
class AppColors {
  AppColors._();

  // Primary Brand Colors (Farm / Agriculture Green)
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  static const Color primaryGreenLight = Color(0xFF4CAF50);
  static const Color primaryGreenSoft = Color(0xFFD4EAD9);
  static const Color primaryGreenSurface = Color(0xFFE8F5E9);
  static const Color greenBadgeBackground = Color(0xFFE8F5E9);
  static const Color primaryGreenText = Color(0xFF1E6F29);

  // Tomato Accent Colors (AI / Alerts / Scan Action)
  static const Color tomatoRed = Color(0xFFE53935);
  static const Color tomatoRedDark = Color(0xFFC62828);
  static const Color tomatoRedLight = Color(0xFFFFEBEE);
  static const Color tomatoBanner = Color(0xFFE04332);
  static const Color tomatoBannerDark = Color(0xFFCC3324);

  // Status & Severity Badges
  static const Color statusGreen = Color(0xFF2E7D32);
  static const Color statusGreenBg = Color(0xFFE8F5E9);
  static const Color statusYellow = Color(0xFFE65100);
  static const Color statusYellowBg = Color(0xFFFFF8E1);
  static const Color statusRed = Color(0xFFD32F2F);
  static const Color statusRedBg = Color(0xFFFFEBEE);

  // Weather & Warnings
  static const Color warningOrange = Color(0xFFF57C00);
  static const Color warningOrangeLight = Color(0xFFFFF3E0);
  static const Color weatherCardBg = Color(0xFFE8F4EC);

  // Camera Overlay
  static const Color cameraGuideGreen = Color(0xFF00E676);

  // Neutrals & Backgrounds
  static const Color background = Color(0xFFF7FAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0A000000);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFEAEFEA);
  static const Color borderFocused = Color(0xFF2E7D32);
  static const Color divider = Color(0xFFEEEEEE);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient greenHeaderGradient = LinearGradient(
    colors: [Color(0xFF1E6334), Color(0xFF2E7D32)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient homeHeaderGradient = LinearGradient(
    colors: [Color(0xFF236B38), Color(0xFF2E7D32)],
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

  static const LinearGradient landingOverlayGradient = LinearGradient(
    colors: [
      Color(0x20000000),
      Color(0x80000000),
      Color(0xE60D1A10),
      Color(0xFA0A140D),
    ],
    stops: [0.0, 0.4, 0.75, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
