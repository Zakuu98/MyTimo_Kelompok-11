import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_button.dart';

/// Banner ajakan scan daun tomat sesuai desain Figma
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
                  _showScanPrompt(context);
                },
          ),
        ],
      ),
    );
  }

  void _showScanPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radius2XL)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.p20),
                const Text(
                  'Pilih Sumber Foto Tomat',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppSizes.p6),
                const Text(
                  'Pastikan daun atau buah tomat terlihat jelas dan fokus',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: AppSizes.p20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryGreen),
                  ),
                  title: const Text('Ambil Foto dari Kamera', style: AppTextStyles.bodyMedium),
                  subtitle: const Text('Gunakan framing guide untuk fokus akurat', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka kamera dengan Framing Guide...')),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrangeLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.warningOrange),
                  ),
                  title: const Text('Unggah dari Galeri', style: AppTextStyles.bodyMedium),
                  subtitle: const Text('Pilih foto daun yang sudah tersimpan', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka galeri perangkat...')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
