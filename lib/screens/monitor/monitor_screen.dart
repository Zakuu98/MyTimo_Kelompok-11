import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/curved_header.dart';

/// Halaman Monitoring & Analisis Tanaman sesuai PRD Modul 4 & Tab Bar Desain
class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final plants = plantProvider.allPlants;
    final totalPlants = plants.length;
    final healthyCount = plants.where((p) => p.status.toLowerCase() == 'sehat').length;
    final threatCount = totalPlants - healthyCount;
    final healthyRate = totalPlants > 0 ? ((healthyCount / totalPlants) * 100).round() : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Header
          CurvedHeader(
            title: 'Monitoring & Analisis',
            subtitle: 'Pantau rekap kesehatan kebun tomat Anda',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Health Summary Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Tanaman Sehat',
                          value: '$healthyRate%',
                          subtitle: '$healthyCount dari $totalPlants tanaman',
                          color: AppColors.primaryGreen,
                          icon: Icons.check_circle_outline_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Perlu Perhatian',
                          value: '$threatCount',
                          subtitle: 'Tanaman bergejala',
                          color: threatCount > 0 ? AppColors.tomatoRed : AppColors.primaryGreen,
                          icon: Icons.warning_amber_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p20),

                  // Section Title: Timeline Kondisi Tanaman (FR-09)
                  const Text(
                    'Timeline Kondisi Tanaman (FR-09)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rekap pemeriksaan berkala berdasarkan riwayat pemindaian dan identifikasi visual on-device.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),

                  // Plant Status Cards
                  ...plants.map((plant) {
                    final scans = plantProvider.getScansForPlant(plant.id);
                    final isHealthy = plant.status.toLowerCase() == 'sehat';

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.p12),
                      padding: const EdgeInsets.all(AppSizes.p14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: AppSizes.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                plant.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isHealthy ? AppColors.statusGreenBg : AppColors.statusYellowBg,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                ),
                                child: Text(
                                  plant.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isHealthy ? AppColors.statusGreen : AppColors.statusYellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Lokasi: ${plant.location} • Varietas: ${plant.variety.isNotEmpty ? plant.variety : "Umum"}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: isHealthy ? 1.0 : 0.6,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isHealthy ? AppColors.primaryGreen : const Color(0xFFFFA000),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${scans.length} kali pemindaian tercatat sejak ${plant.plantingDate}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppSizes.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
