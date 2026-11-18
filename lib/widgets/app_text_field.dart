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
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isRequired;

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
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.formLabel.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.tomatoRed, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTextStyles.formInput.copyWith(fontSize: 14.5),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.formHint.copyWith(fontSize: 14),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: maxLines > 1 ? AppSizes.p14 : AppSizes.p14,
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
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
