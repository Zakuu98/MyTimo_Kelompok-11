import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/navigation_provider.dart';
import '../../../theme/app_colors.dart';

/// Bagian Menu Utama 4 fitur sesuai Desain Figma Frame: home
/// (Data Tanaman, Riwayat Scan, Rencana Rawat, Monitoring)
class MainMenuSection extends StatelessWidget {
  const MainMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'Menu Utama',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 12),

        // 4 Items Row
        Row(
          children: [
            // Item 1: Data Tanaman
            Expanded(
              child: _buildMenuItem(
                context,
                title: 'Data Tanaman',
                circleGradient: AppColors.homeMenuSproutGrad,
                iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                iconColor: AppColors.homeMenuSproutIcon,
                fallbackIcon: Icons.eco_outlined,
                onTap: () {
                  // Switch to Tanaman tab
                  context.read<NavigationProvider>().setIndex(1);
                },
              ),
            ),
            const SizedBox(width: 10),

            // Item 2: Riwayat Scan
            Expanded(
              child: _buildMenuItem(
                context,
                title: 'Riwayat Scan',
                circleGradient: AppColors.homeMenuClockGrad,
                iconAsset: 'assets/custom_assets/icons/ic_clock.png',
                iconColor: AppColors.homeMenuClockIcon,
                fallbackIcon: Icons.history_rounded,
                onTap: () {
                  // Switch to Riwayat tab
                  context.read<NavigationProvider>().setIndex(3);
                },
              ),
            ),
            const SizedBox(width: 10),

            // Item 3: Rencana Rawat
            Expanded(
              child: _buildMenuItem(
                context,
                title: 'Rencana Rawat',
                circleGradient: AppColors.homeMenuClipGrad,
                iconColor: AppColors.homeMenuClipIcon,
                fallbackIcon: Icons.assignment_outlined,
                onTap: () {
                  _showTreatmentPlanModal(context);
                },
              ),
            ),
            const SizedBox(width: 10),

            // Item 4: Monitoring
            Expanded(
              child: _buildMenuItem(
                context,
                title: 'Monitoring',
                circleGradient: AppColors.homeMenuActivityGrad,
                iconAsset: 'assets/custom_assets/icons/ic_activity.png',
                iconColor: AppColors.homeMenuActivityIcon,
                fallbackIcon: Icons.show_chart_rounded,
                onTap: () {
                  // Switch to Monitor tab
                  context.read<NavigationProvider>().setIndex(4);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required Gradient circleGradient,
    String? iconAsset,
    required Color iconColor,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle 44x44
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: circleGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: iconAsset != null
                      ? Image.asset(
                          iconAsset,
                          width: 24,
                          height: 24,
                          color: iconColor,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            fallbackIcon,
                            color: iconColor,
                            size: 24,
                          ),
                        )
                      : Icon(
                          fallbackIcon,
                          color: iconColor,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(height: 6),

              // Title
              Text(
                title.trim(),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTreatmentPlanModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3C4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.assignment_outlined,
                        color: Color(0xFFBA6900),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rencana Rawat Tanaman',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Jadwal tindakan penyemprotan & sanitasi kebun',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: Color(0xFF178401)),
                  title: const Text('Semprot Fungisida Mankozeb (Blok A)', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Jadwal: Pagi ini pukul 07:00 WIB', style: TextStyle(fontSize: 12)),
                ),
                ListTile(
                  leading: const Icon(Icons.schedule_rounded, color: Color(0xFFBA6900)),
                  title: const Text('Sanitasi Daun Terinfeksi (Bedeng 1)', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Jadwal: Besok sore pukul 16:00 WIB', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
