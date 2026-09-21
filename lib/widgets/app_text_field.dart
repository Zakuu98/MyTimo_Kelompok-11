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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.formLabel,
        ),
        const SizedBox(height: AppSizes.p8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          style: AppTextStyles.formInput,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.formHint,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.textMuted,
                    size: AppSizes.iconSizeMedium,
                  )
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: AppSizes.roundedXL,
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSizes.roundedXL,
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSizes.roundedXL,
              borderSide: const BorderSide(color: AppColors.borderFocused, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSizes.roundedXL,
              borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSizes.roundedXL,
              borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
