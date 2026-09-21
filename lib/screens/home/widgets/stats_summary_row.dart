import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';

/// Baris 3 metrik statistik dashboard (Total Deteksi, Tanaman Sehat, Terkena Hama/Penyakit)
class StatsSummaryRow extends StatelessWidget {
  const StatsSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final stat = dashboard.weatherStat;

        return Row(
          children: [
            // Total Deteksi
            Expanded(
              child: _buildMetricCard(
                context,
                title: 'Total Deteksi',
                value: '${stat.totalDetections}',
                valueColor: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSizes.p10),

            // Tanaman Sehat
            Expanded(
              child: _buildMetricCard(
                context,
                title: 'Tanaman Sehat',
                value: '${stat.healthyPercentage}%',
                valueColor: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: AppSizes.p10),

            // Terkena Penyakit / Hama
            Expanded(
              child: _buildMetricCard(
                context,
                title: 'Penyakit Aktif',
                value: '${stat.activeThreatCount}',
                valueColor: AppColors.tomatoRed,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p8,
        vertical: AppSizes.p14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.roundedL,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.p6),
          Text(
            value,
            style: AppTextStyles.metricValue.copyWith(
              color: valueColor,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
