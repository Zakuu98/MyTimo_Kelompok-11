import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/diagnosis_history_model.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';

/// Bagian Riwayat Diagnosa Terbaru yang menampilkan log deteksi tanaman tomat
class RecentDiagnosisSection extends StatelessWidget {
  const RecentDiagnosisSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final recentDiagnoses = dashboard.recentDiagnoses;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: AppColors.primaryGreen,
                  size: AppSizes.iconSizeMedium,
                ),
                const SizedBox(width: AppSizes.p8),
                Text(
                  'Riwayat Diagnosa Terbaru',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 15.5),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p12),

            // History Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentDiagnoses.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSizes.p10),
              itemBuilder: (context, index) {
                final item = recentDiagnoses[index];
                return _buildHistoryCard(context, item);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, DiagnosisHistoryModel item) {
    final statusBgColor =
        item.isHealthy ? AppColors.greenBadgeBackground : AppColors.tomatoRedLight;
    final statusTextColor =
        item.isHealthy ? AppColors.primaryGreen : AppColors.tomatoRed;
    final statusIcon = item.isHealthy ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final iconColor = item.isHealthy ? AppColors.primaryGreen : AppColors.tomatoRed;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.roundedL,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Icon Circle
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: statusBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: iconColor,
              size: AppSizes.iconSizeMedium + 2,
            ),
          ),
          const SizedBox(width: AppSizes.p12),

          // Title & Subtitle (Time & Location)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.p2),
                Text(
                  item.formattedSubtitle,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Confidence & Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p10,
              vertical: AppSizes.p6,
            ),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: AppSizes.roundedFull,
            ),
            child: Text(
              item.formattedBadge,
              style: AppTextStyles.badgeText.copyWith(
                color: statusTextColor,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
