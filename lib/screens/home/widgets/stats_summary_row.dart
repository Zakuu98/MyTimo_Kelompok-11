import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';

/// Baris 3 kartu statistik kebun sesuai Desain Figma Frame: home
/// (Total Tanaman, Perlu Rawat, Daun Sehat)
class StatsSummaryRow extends StatelessWidget {
  const StatsSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final stat = dashboard.weatherStat;
        final totalTanaman = '${stat.totalDetections}';
        final perluRawat = '${stat.activeThreatCount}';
        final daunSehat = '${stat.totalDetections - stat.activeThreatCount}';

        return Row(
          children: [
            // Stat 1: Total Tanaman
            Expanded(
              child: _buildStatCard(
                value: totalTanaman,
                label: 'Total Tanaman',
                valueColor: AppColors.homeStatTotal,
              ),
            ),
            const SizedBox(width: 12),

            // Stat 2: Perlu Rawat
            Expanded(
              child: _buildStatCard(
                value: perluRawat,
                label: 'Perlu Rawat',
                valueColor: AppColors.homeStatCare,
              ),
            ),
            const SizedBox(width: 12),

            // Stat 3: Daun Sehat
            Expanded(
              child: _buildStatCard(
                value: daunSehat,
                label: 'Daun Sehat',
                valueColor: AppColors.homeStatHealthy,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: valueColor,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: AppColors.homeStatLabel,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
