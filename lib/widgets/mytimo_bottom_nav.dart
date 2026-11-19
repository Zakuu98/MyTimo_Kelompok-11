import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable Bottom Navigation Bar sesuai desain Figma MyTimo
/// Dipakai di semua screen treatment (screen 21-26, 33)
class MyTimoBottomNav extends StatelessWidget {
  final int activeIndex; // 0=Beranda,1=Tanaman,2=Pindai,3=Riwayat,4=Monitor
  final VoidCallback? onPindaiTap;

  const MyTimoBottomNav({
    super.key,
    this.activeIndex = 1,
    this.onPindaiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              _buildNavItem('Beranda', Icons.home_rounded, 0, context),
              _buildNavItem('Tanaman', Icons.grass_rounded, 1, context),
              _buildPindaiButton(context),
              _buildNavItem('Riwayat', Icons.history_rounded, 3, context),
              _buildNavItem('Monitor', Icons.insights_rounded, 4, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, int index, BuildContext context) {
    final isActive = activeIndex == index;
    final color = isActive ? AppColors.primaryGreen : AppColors.textMuted;

    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (index == 1) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (index == 3) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        } else if (index == 4) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        }
      },
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
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPindaiButton(BuildContext context) {
    return GestureDetector(
      onTap: onPindaiTap ?? () => Navigator.of(context).pushNamed('/scan'),
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
                  color: AppColors.tomatoRed.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.crop_free_rounded, color: Colors.white, size: 24),
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
    );
  }
}
