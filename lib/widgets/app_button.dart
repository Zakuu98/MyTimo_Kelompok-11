import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, whitePill, outlineWhite, danger, dangerOutline }

/// Reusable button widget adhering to MyTimo new design guidelines
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
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
    this.suffixIcon,
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
    this.suffixIcon,
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
    this.suffixIcon,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius,
  }) : variant = AppButtonVariant.whitePill;

  const AppButton.outlineWhite({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius,
  }) : variant = AppButtonVariant.outlineWhite;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius,
  }) : variant = AppButtonVariant.danger;

  const AppButton.dangerOutline({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius,
  }) : variant = AppButtonVariant.dangerOutline;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;
    TextStyle textStyle = AppTextStyles.buttonPrimary;
    BorderRadius effectiveRadius = borderRadius ?? BorderRadius.circular(AppSizes.radiusFull);

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
        foregroundColor = AppColors.primaryGreen;
        textStyle = AppTextStyles.buttonPrimary.copyWith(
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.w700,
        );
        break;
      case AppButtonVariant.outlineWhite:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.textWhite;
        borderSide = const BorderSide(color: Colors.white, width: 1.5);
        textStyle = AppTextStyles.buttonPrimary.copyWith(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
        );
        break;
      case AppButtonVariant.danger:
        backgroundColor = AppColors.tomatoRed;
        foregroundColor = AppColors.textWhite;
        textStyle = AppTextStyles.buttonPrimary;
        break;
      case AppButtonVariant.dangerOutline:
        backgroundColor = const Color(0xFFFFF5F5);
        foregroundColor = AppColors.tomatoRed;
        borderSide = const BorderSide(color: Color(0xFFFFCDD2), width: 1.2);
        textStyle = AppTextStyles.buttonPrimary.copyWith(
          color: AppColors.tomatoRed,
          fontWeight: FontWeight.w700,
        );
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
              Flexible(
                child: Text(
                  label,
                  style: textStyle.copyWith(color: foregroundColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: AppSizes.p8),
                suffixIcon!,
              ],
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
          elevation: variant == AppButtonVariant.whitePill ? 3 : 0,
          shadowColor: const Color(0x33000000),
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: effectiveRadius,
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p20,
            vertical: AppSizes.p10,
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}
