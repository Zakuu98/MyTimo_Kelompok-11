import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography design tokens for MyTimo
/// Note: Adheres to PRD NFR-04 (minimum font size >= 14pt for field readability under sunlight)
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.35,
  );

  // Subtitles & Section Titles
  static const TextStyle subtitle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Body Texts (>= 14pt per PRD NFR-04)
  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  // Form Field Labels & Inputs
  static const TextStyle formLabel = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle formInput = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle formHint = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Button Texts
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryGreenText,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  // Badges & Metrics
  static const TextStyle metricValue = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle metricLabel = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static const TextStyle navItem = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
  );
}
