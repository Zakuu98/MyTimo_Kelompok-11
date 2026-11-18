import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

/// Reusable curved gradient header matching screens 08, 09, 10, 14, 15
class CurvedHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? bottomChild;
  final double? bottomRadius;

  const CurvedHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.bottomChild,
    this.bottomRadius,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final effectiveRadius = bottomRadius ?? AppSizes.radius2XL;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.greenHeaderGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(effectiveRadius),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F1B5E20),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: topPadding + AppSizes.p12,
        bottom: bottomChild != null ? AppSizes.p16 : AppSizes.p20,
        left: AppSizes.p16,
        right: AppSizes.p16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Navigation / Title Row
          Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Color(0xFFD4EAD9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ...?actions,
            ],
          ),

          // Optional Search Bar / Filters Row
          if (bottomChild != null) ...[
            const SizedBox(height: AppSizes.p12),
            bottomChild!,
          ],
        ],
      ),
    );
  }
}
