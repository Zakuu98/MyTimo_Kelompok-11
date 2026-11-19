import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

/// Reusable input field widget styled according to Figma specifications
class AppTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Color? prefixIconColor;
  final double? prefixIconSize;
  final List<BoxShadow>? boxShadow;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.borderColor,
    this.borderRadius,
    this.labelStyle,
    this.hintStyle,
    this.prefixIconColor,
    this.prefixIconSize,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppSizes.roundedXL;
    final effectiveBorderColor = borderColor ?? AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ?? AppTextStyles.formLabel,
        ),
        const SizedBox(height: AppSizes.p8),
        Container(
          decoration: BoxDecoration(
            borderRadius: effectiveRadius,
            boxShadow: boxShadow,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle ?? AppTextStyles.formHint,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p14,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: prefixIconColor ?? AppColors.textMuted,
                      size: prefixIconSize ?? AppSizes.iconSizeMedium,
                    )
                  : null,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: effectiveRadius,
                borderSide: BorderSide(color: effectiveBorderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: effectiveRadius,
                borderSide: BorderSide(color: effectiveBorderColor, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: effectiveRadius,
                borderSide: BorderSide(color: effectiveBorderColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: effectiveRadius,
                borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: effectiveRadius,
                borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
