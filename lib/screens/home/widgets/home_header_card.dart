import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';

/// Header bagian atas Home dengan profil petani dan status kebun
class HomeHeaderCard extends StatelessWidget {
  const HomeHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        final farmerName = user?.name ?? 'Pak Budi';
        final farmLocation = user?.farmLocation ?? 'Kebun Lembang 0.8 Ha';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar & Welcome Info
            Row(
              children: [
                Container(
                  width: AppSizes.avatarSize + 4,
                  height: AppSizes.avatarSize + 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textWhite, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      user?.avatarPath ?? 'assets/images/farmer_avatar.webp',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryGreenDark,
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.textWhite,
                            size: 26,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo $farmerName',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textWhite,
                        fontSize: 17.0,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p2),
                    Text(
                      farmLocation,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textWhite.withValues(alpha: 0.85),
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Notification Bell with indicator badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textWhite,
                      size: AppSizes.iconSizeMedium,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak ada notifikasi baru saat ini.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.tomatoRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.textWhite, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
