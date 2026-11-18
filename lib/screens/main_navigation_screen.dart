import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_colors.dart';
import 'history/scan_history_screen.dart';
import 'home/home_screen.dart';
import 'monitor/monitor_screen.dart';
import 'plants/plant_list_screen.dart';
import 'scan/camera_scan_screen.dart';

/// Main Navigation Screen with 5 Tabs and Center Floating Scan Button
/// Berdasarkan Screenshot Desain 08_plant_list, 11_plant_detail, dan 14_Riwayat_
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
              PlantListScreen(),
              SizedBox.shrink(), // Placeholder untuk Index 2 (Pindai - dibuka via Modal/Screen)
              ScanHistoryScreen(),
              MonitorScreen(),
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
                height: 66,
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

                    // Tab 2: Tanaman
                    _buildNavItem(
                      context,
                      index: 1,
                      label: 'Tanaman',
                      icon: Icons.grass_rounded,
                      isActive: nav.currentIndex == 1,
                      onTap: () => nav.setIndex(1),
                    ),

                    // Center Action: Pindai (Elevated Orange-Red Button)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CameraScanScreen(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: AppColors.floatingScanGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tomatoRed.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.crop_free_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Pindai',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tomatoRed,
                            ),
                          ),
                        ],
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

                    // Tab 5: Monitor
                    _buildNavItem(
                      context,
                      index: 4,
                      label: 'Monitor',
                      icon: Icons.insights_rounded,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
}
