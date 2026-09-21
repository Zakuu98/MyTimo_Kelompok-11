import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, whitePill, danger }

/// Reusable button widget adhering to MyTimo design guidelines
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? prefixIcon;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.prefixIcon,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.whitePill({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.width,
    this.height = AppSizes.buttonHeightSmall,
    this.borderRadius,
  }) : variant = AppButtonVariant.whitePill;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;
    TextStyle textStyle = AppTextStyles.buttonPrimary;
    BorderRadius effectiveRadius = borderRadius ?? AppSizes.roundedXL;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primaryGreen;
        foregroundColor = AppColors.textWhite;
        textStyle = AppTextStyles.buttonPrimary;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = AppColors.primaryGreenSoft;
        foregroundColor = AppColors.primaryGreenText;
        textStyle = AppTextStyles.buttonSecondary;
        break;
      case AppButtonVariant.whitePill:
        backgroundColor = AppColors.surface;
        foregroundColor = AppColors.tomatoBannerDark;
        textStyle = AppTextStyles.buttonSmall.copyWith(
          color: AppColors.tomatoBannerDark,
          fontWeight: FontWeight.w700,
        );
        effectiveRadius = AppSizes.roundedFull;
        break;
      case AppButtonVariant.danger:
        backgroundColor = AppColors.tomatoRed;
        foregroundColor = AppColors.textWhite;
        textStyle = AppTextStyles.buttonPrimary;
        break;
    }

    final buttonContent = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: AppSizes.p8),
              ],
              Text(
                label,
                style: textStyle.copyWith(color: foregroundColor),
              ),
            ],
          );

    final effectiveWidth = width ?? (variant == AppButtonVariant.whitePill ? null : double.infinity);

    return SizedBox(
      width: effectiveWidth,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: variant == AppButtonVariant.whitePill ? 1 : 0,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: effectiveRadius,
            side: borderSide,
          ),
          padding: variant == AppButtonVariant.whitePill
              ? const EdgeInsets.symmetric(
                  horizontal: AppSizes.p14,
                  vertical: AppSizes.p6,
                )
              : const EdgeInsets.symmetric(
                  horizontal: AppSizes.p20,
                  vertical: AppSizes.p10,
                ),
        ),
        child: buttonContent,
      ),
    );
  }
}
