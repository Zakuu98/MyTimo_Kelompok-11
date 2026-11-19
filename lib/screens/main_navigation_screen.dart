import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import 'home/home_screen.dart';
import 'plant_list/plant_list_screen.dart';
import 'scan/camera_scan_screen.dart';
import 'scan/scan_history_screen.dart';

/// Main Navigation Screen dengan custom Bottom Navigation Bar sesuai Desain Figma Frame: home
/// 5 Tab: Beranda, Tanaman, Pindai (Center Elevated FAB), Riwayat, Monitor
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        final bottomInset = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          backgroundColor: AppColors.homeBackground,
          body: IndexedStack(
            index: nav.currentIndex,
            children: const [
              HomeScreen(),
              PlantListScreen(),
              // Dummy slot for center FAB if ever indexed
              HomeScreen(),
              ScanHistoryScreen(isEmbeddedInNav: true),
              _PlaceholderTab(
                title: 'Monitoring Kesehatan',
                subtitle: 'Grafik tren kesehatan kebun dan jadwal perawatan.',
                iconAsset: 'assets/custom_assets/icons/ic_activity.png',
                fallbackIcon: Icons.show_chart_rounded,
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 86 + (bottomInset > 0 ? bottomInset - 10 : 0),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Bottom Bar Background
                Container(
                  height: 68 + bottomInset,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000), // rgba(0, 0, 0, 0.08)
                        blurRadius: 12,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Row(
                    children: [
                      // Tab 0: Beranda
                      Expanded(
                        child: _buildNavTab(
                          label: 'Beranda',
                          iconAsset: 'assets/custom_assets/icons/ic_home.png',
                          fallbackIcon: Icons.home_rounded,
                          isActive: nav.currentIndex == 0,
                          onTap: () => nav.setIndex(0),
                        ),
                      ),

                      // Tab 1: Tanaman
                      Expanded(
                        child: _buildNavTab(
                          label: 'Tanaman',
                          iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                          fallbackIcon: Icons.eco_outlined,
                          isActive: nav.currentIndex == 1,
                          onTap: () => nav.setIndex(1),
                        ),
                      ),

                      // Space for Center FAB (width ~ 72)
                      const SizedBox(width: 76),

                      // Tab 3: Riwayat
                      Expanded(
                        child: _buildNavTab(
                          label: 'Riwayat',
                          iconAsset: 'assets/custom_assets/icons/ic_clock.png',
                          fallbackIcon: Icons.history_rounded,
                          isActive: nav.currentIndex == 3,
                          onTap: () => nav.setIndex(3),
                        ),
                      ),

                      // Tab 4: Monitor
                      Expanded(
                        child: _buildNavTab(
                          label: 'Monitor',
                          iconAsset: 'assets/custom_assets/icons/ic_activity.png',
                          fallbackIcon: Icons.show_chart_rounded,
                          isActive: nav.currentIndex == 4,
                          onTap: () => nav.setIndex(4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Elevated Floating Action Button (FAB)
                Positioned(
                  top: 0,
                  child: GestureDetector(
                    onTap: () => _openScanner(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // White Ring (72x72)
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            // Gradient Circle (54x54)
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                gradient: AppColors.homeFabGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.crop_free_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Label "Pindai"
                        const Text(
                          'Pindai',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.homeFabScanText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavTab({
    required String label,
    required String iconAsset,
    required IconData fallbackIcon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppColors.homeNavActive : AppColors.homeNavInactive;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconAsset,
            width: 24,
            height: 24,
            color: color,
            errorBuilder: (context, error, stackTrace) => Icon(
              fallbackIcon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.0,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openScanner(BuildContext context) {
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE3E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.crop_free_rounded, color: AppColors.homeBannerBtnText),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pemindaian Daun Tomat',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Deteksi Hama & Jamur Instan (Offline AI)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreenSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryGreen),
                  ),
                  title: const Text('Buka Kamera dengan Framing Guide', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Arahkan kamera ke daun bergejala penyakit', style: TextStyle(fontSize: 12)),
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
                    decoration: const BoxDecoration(
                      color: AppColors.warningOrangeLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.warningOrange),
                  ),
                  title: const Text('Pilih dari Galeri Perangkat', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Gunakan foto yang sudah diambil sebelumnya', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka pemilih foto galeri...')),
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

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? iconAsset;
  final IconData fallbackIcon;

  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
    this.iconAsset,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE7FDDD), Color(0xFFC5F3C1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: iconAsset != null
                      ? Image.asset(
                          iconAsset!,
                          width: 38,
                          height: 38,
                          color: const Color(0xFF178401),
                          errorBuilder: (context, error, stackTrace) => Icon(
                            fallbackIcon,
                            size: 38,
                            color: const Color(0xFF178401),
                          ),
                        )
                      : Icon(
                          fallbackIcon,
                          size: 38,
                          color: const Color(0xFF178401),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
