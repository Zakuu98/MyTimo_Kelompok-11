import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';

/// Header bagian atas Home sesuai Desain Figma Frame: home
/// Berisi Avatar, Greeting ("Selamat Datang," / "Pak Joko Santoso"), Bell Notifikasi, dan Search Bar
class HomeHeaderCard extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onNotificationTap;

  const HomeHeaderCard({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        final displayName = (user != null && user.name.trim().isNotEmpty)
            ? user.name.trim()
            : 'Pak Joko Santoso';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Avatar, Greeting & Bell
            Row(
              children: [
                // Avatar (46x46)
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.homeHeaderAvatarBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.homeHeaderAvatarBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/custom_assets/icons/ic_user.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Greeting & Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xE6FFFFFF), // rgba(255, 255, 255, 0.9)
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bell Notification with Red Badge (46x46)
                GestureDetector(
                  onTap: onNotificationTap ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak ada notifikasi baru saat ini.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.homeHeaderAvatarBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.homeHeaderAvatarBorder,
                        width: 1.0,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/custom_assets/icons/ic_bell.png',
                            width: 22,
                            height: 22,
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        // Red indicator dot with white border
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: AppColors.homeNotificationDot,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Search Bar (Height 48, radius 24)
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.homeSearchIcon,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Cari tanaman, penyakit, atau catatan…',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.homeSearchText,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
