import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';
import '../../scan/camera_scan_screen.dart';

/// Banner ajakan scan daun tomat sesuai Desain Figma Frame: home (Banner Scan)
class ScanBannerCard extends StatelessWidget {
  final VoidCallback? onScanPressed;

  const ScanBannerCard({
    super.key,
    this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 138,
      decoration: BoxDecoration(
        color: AppColors.homeBannerBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/hero_tomatoes.webp',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.homeBannerBg,
                ),
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.homeBannerOverlay,
                ),
              ),
            ),

            // Content Left Column
            Positioned(
              left: 18,
              top: 14,
              right: 110,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Pindai Daun Tomat',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Deteksi hama & jamur langsung di kebun dalam 2 detik',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xE6FFFFFF), // rgba(255, 255, 255, 0.90)
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),

                  // Pill Button "Buka Kamera"
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onScanPressed ?? () => _showScanPrompt(context),
                      borderRadius: BorderRadius.circular(17),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.homeBannerBtnText,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Buka Kamera',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.homeBannerBtnText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CameraScanScreen(),
                      ),
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
