import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import 'home/home_screen.dart';

/// Main Navigation Screen with custom Bottom Navigation Bar and elevated Center Scan Button
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        return Scaffold(
          body: IndexedStack(
            index: nav.currentIndex,
            children: const [
              HomeScreen(),
              _PlaceholderTab(
                title: 'Kamus Penyakit',
                subtitle: 'Daftar lengkap gejala dan penanganan penyakit tomat.',
                icon: Icons.menu_book_rounded,
              ),
              _PlaceholderTab(
                title: 'Pemindaian Kamera (FR-02)',
                subtitle: 'Mode inferensi AI On-Device (TFLite) 100% offline.',
                icon: Icons.camera_alt_rounded,
              ),
              _PlaceholderTab(
                title: 'Riwayat Pemindaian',
                subtitle: 'Arsip log deteksi tersimpan lokal di perangkat.',
                icon: Icons.history_rounded,
              ),
              _PlaceholderTab(
                title: 'Profil Petani',
                subtitle: 'Pengaturan akun dan preferensi lahan pertanian.',
                icon: Icons.person_rounded,
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Tab 1: Beranda
                    _buildNavItem(
                      context,
                      index: 0,
                      label: 'Beranda',
                      icon: Icons.home_rounded,
                      isActive: nav.currentIndex == 0,
                      onTap: () => nav.setIndex(0),
                    ),

                    // Tab 2: Kamus
                    _buildNavItem(
                      context,
                      index: 1,
                      label: 'Kamus',
                      icon: Icons.menu_book_rounded,
                      isActive: nav.currentIndex == 1,
                      onTap: () => nav.setIndex(1),
                    ),

                    // Tab 3: Center Elevated Scan Button
                    GestureDetector(
                      onTap: () => _openScanner(context),
                      child: Container(
                        width: AppSizes.floatingScanButtonSize,
                        height: AppSizes.floatingScanButtonSize,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          gradient: AppColors.floatingScanGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tomatoRed.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.crop_free_rounded,
                          color: AppColors.textWhite,
                          size: 28,
                        ),
                      ),
                    ),

                    // Tab 4: Riwayat
                    _buildNavItem(
                      context,
                      index: 3,
                      label: 'Riwayat',
                      icon: Icons.history_rounded,
                      isActive: nav.currentIndex == 3,
                      onTap: () => nav.setIndex(3),
                    ),

                    // Tab 5: Profil
                    _buildNavItem(
                      context,
                      index: 4,
                      label: 'Profil',
                      icon: Icons.person_outline_rounded,
                      isActive: nav.currentIndex == 4,
                      onTap: () => nav.setIndex(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppColors.primaryGreen : AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primaryGreenSoft.withValues(alpha: 0.3),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
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
                      decoration: BoxDecoration(
                        color: AppColors.tomatoRedLight,
                        borderRadius: AppSizes.roundedM,
                      ),
                      child: const Icon(Icons.crop_free_rounded, color: AppColors.tomatoRed),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pemindaian Daun Tomat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Inferensi AI On-Device Offline', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka modul kamera TFLite (FR-02 & FR-03)...')),
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
  final IconData icon;

  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.surface,
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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreenSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 56, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
