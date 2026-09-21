import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

/// Reusable card container with subtle shadow, rounded corners, and customizable padding
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.p16),
    this.margin,
    this.backgroundColor = AppColors.surface,
    this.borderRadius,
    this.border,
    this.onTap,
    this.boxShadow = AppSizes.cardShadow,
  });

  @override
  Widget build(BuildContext context) {
    final cardRadius = borderRadius ?? AppSizes.roundedXL;

    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: cardRadius,
        border: border ?? Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: boxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: cardRadius,
          child: content,
        ),
      );
    }

    return content;
  }
}
