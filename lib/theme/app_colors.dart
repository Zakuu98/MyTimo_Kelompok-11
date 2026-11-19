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

  // Landing Page Design Tokens (Figma Frame 1)
  static const Color landingGreen = Color(0xFF178401);
  static const Color landingDarkOverlayTop = Color(0x7308330D); // rgba(8, 51, 13, 0.45)
  static const Color landingDarkOverlayBottom = Color(0xCC051F0A); // rgba(5, 31, 10, 0.80)
  static const Color landingButtonSecondaryBg = Color(0x2EFFFFFF); // rgba(255, 255, 255, 0.18)
  static const Color landingButtonSecondaryBorder = Color(0x80FFFFFF); // rgba(255, 255, 255, 0.50)

  static const LinearGradient landingLogoGradient = LinearGradient(
    colors: [Color(0xFFDF4B2C), Color(0xFFE89746)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient landingOverlayGradient = LinearGradient(
    colors: [
      Color(0x7308330D),
      Color(0xCC051F0A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Sign Up / Register Design Tokens (Figma Frame: sign_up)
  static const Color signUpBackground = Color(0xFFF3EDED);
  static const Color signUpInputBorder = Color(0xFFDF4B2C);
  static const Color signUpTextGray = Color(0xFF8E8E8E);

  static const LinearGradient signUpHeaderGradient = LinearGradient(
    colors: [
      Color(0x8008330D), // rgba(8, 51, 13, 0.50)
      Color(0xC7051F0A), // rgba(5, 31, 10, 0.78)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient signUpButtonGradient = LinearGradient(
    colors: [
      Color(0xFF389D33),
      Color(0xFF178401),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Login Design Tokens (Figma Frame: login)
  static const Color loginMyTimoOrange = Color(0xFFE89044);
  static const Color loginForgotPasswordGreen = Color(0xFF178401);

  static const LinearGradient loginOverlayGradient = LinearGradient(
    colors: [
      Color(0xD92C961B), // rgba(44, 150, 27, 0.85)
      Color(0xCC0B3D0B), // rgba(11, 61, 11, 0.80)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Forgot Password Design Tokens (Figma Frame: forgot_password)
  static const LinearGradient forgotPasswordHeaderGradient = LinearGradient(
    colors: [
      Color(0xFF599151),
      Color(0xFF2C961B),
      Color(0xFF6FBD5F),
    ],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Home Screen Design Tokens (Figma Frame: home)
  static const Color homeBackground = Color(0xFFF3EDED);
  static const Color homeHeaderAvatarBg = Color(0x40FFFFFF); // rgba(255, 255, 255, 0.25)
  static const Color homeHeaderAvatarBorder = Color(0x99FFFFFF); // rgba(255, 255, 255, 0.60)
  static const Color homeNotificationDot = Color(0xFFFF3B30);
  static const Color homeSearchText = Color(0x75000000); // rgba(0, 0, 0, 0.46)
  static const Color homeSearchIcon = Color(0xFF8E8E8E);

  static const LinearGradient homeHeaderGradientFigma = LinearGradient(
    colors: [
      Color(0xFF599151),
      Color(0xFF2C961B),
      Color(0xFFE7FDDD),
    ],
    stops: [0.03, 0.50, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Banner Scan
  static const Color homeBannerBg = Color(0xFF0B3D0B);
  static const LinearGradient homeBannerOverlay = LinearGradient(
    colors: [
      Color(0xEB0B3D0B), // rgba(11, 61, 11, 0.92)
      Color(0x8C178401), // rgba(23, 132, 1, 0.55)
      Color(0x0D178401), // rgba(23, 132, 1, 0.05)
    ],
    stops: [0.0, 0.60, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color homeBannerBtnText = Color(0xFFD91C1C);

  // Stats
  static const Color homeStatTotal = Color(0xFF178401);
  static const Color homeStatCare = Color(0xFFBA6900);
  static const Color homeStatHealthy = Color(0xFF389D33);
  static const Color homeStatLabel = Color(0xFF7E7E7E);

  // Menu Utama Circles
  static const LinearGradient homeMenuSproutGrad = LinearGradient(
    colors: [Color(0xFFE7FDDD), Color(0xFFC5F3C1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient homeMenuClockGrad = LinearGradient(
    colors: [Color(0xFFE7FDDD), Color(0xFFC5F3C1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient homeMenuClipGrad = LinearGradient(
    colors: [Color(0xFFFFF3C4), Color(0xFFEFDF64)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient homeMenuActivityGrad = LinearGradient(
    colors: [Color(0xFFFFE3E0), Color(0xFFFFB1B1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color homeMenuSproutIcon = Color(0xFF389D33);
  static const Color homeMenuClockIcon = Color(0xFF178401);
  static const Color homeMenuClipIcon = Color(0xFFBA6900);
  static const Color homeMenuActivityIcon = Color(0xFFD91C1C);

  // Pemeriksaan Terbaru
  static const Color homeSeeAllText = Color(0xFF287D38);
  static const Color homeBadgeEarlyBlightBg = Color(0xFFEFDF64);
  static const Color homeBadgeEarlyBlightText = Color(0xFFBA6900);
  static const Color homeBadgeSeptoriaBg = Color(0xFFFFB1B1);
  static const Color homeBadgeSeptoriaText = Color(0xFFCC0000);

  // Bottom Navigation
  static const Color homeNavActive = Color(0xFF178401);
  static const Color homeNavInactive = Color(0xFF8E8E8E);
  static const Color homeFabScanText = Color(0xFFDF4B2C);
  static const LinearGradient homeFabGradient = LinearGradient(
    colors: [
      Color(0xFFD9221E),
      Color(0xFFD46031),
      Color(0xFFE89A42),
    ],
    stops: [0.0, 0.50, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Plant List Design Tokens (Figma Frame: plant_list)
  static const Color plantListBackground = Color(0xFFF3EDED);
  static const Color plantListFilterBtnBg = Color(0x38FFFFFF); // rgba(255, 255, 255, 0.22)
  static const Color plantListFilterBtnBorder = Color(0x80FFFFFF); // rgba(255, 255, 255, 0.50)

  static const LinearGradient plantListChipActiveGradient = LinearGradient(
    colors: [Color(0xFF389D33), Color(0xFF178401)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color plantBadgeSehatBg = Color(0xFFC5F3C1);
  static const Color plantBadgeSehatText = Color(0xFF106804);
  static const Color plantBadgeEarlyBlightBg = Color(0xFFEFDF64);
  static const Color plantBadgeEarlyBlightText = Color(0xFFBA6900);
  static const Color plantBadgeLateBlightBg = Color(0xFFFFB1B1);
  static const Color plantBadgeLateBlightText = Color(0xFFCC0000);

  static const Color plantEmptyTitle = Color(0xFF111827);
  static const Color plantEmptyDesc = Color(0xFF6B7280);
  static const Color plantEmptyBtn = Color(0xFF2D7A42);

  // Tambah Tanaman Design Tokens (Figma Frame: Tambah_Tanaman)
  static const Color addPlantBackground = Color(0xFFF3EDED);
  static const Color addPlantInputBorder = Color(0xFFDF4B2C);
  static const Color addPlantHomeIndicator = Color(0xFFD1D5DB);

  static const LinearGradient addPlantHeaderGradient = LinearGradient(
    colors: [
      Color(0xFF599151),
      Color(0xFF2C961B),
      Color(0xFF6FBD5F),
    ],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient addPlantButtonGradient = LinearGradient(
    colors: [
      Color(0xFF389D33),
      Color(0xFF178401),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
