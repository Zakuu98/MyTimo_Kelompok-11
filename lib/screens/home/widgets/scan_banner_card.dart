import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../widgets/app_button.dart';
import '../../scan/camera_scan_screen.dart';

/// Banner ajakan scan daun tomat sesuai desain Figma & PRD FR-01
class ScanBannerCard extends StatelessWidget {
  final VoidCallback? onScanPressed;

  const ScanBannerCard({
    super.key,
    this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p14,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.scanBannerGradient,
        borderRadius: AppSizes.roundedXL,
        boxShadow: [
          BoxShadow(
            color: AppColors.tomatoRed.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Camera Icon in container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: AppSizes.roundedL,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.textWhite,
              size: AppSizes.iconSizeLarge,
            ),
          ),
          const SizedBox(width: AppSizes.p12),

          // Text labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Foto Daun Tomat Sekarang',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.p2),
                Text(
                  'Ambil foto untuk diagnosis instan',
                  style: TextStyle(
                    color: AppColors.textWhite.withValues(alpha: 0.85),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.p8),

          // Pill Action Button: Scan
          AppButton.whitePill(
            label: 'Scan',
            height: 34,
            onPressed: onScanPressed ??
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CameraScanScreen(),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
