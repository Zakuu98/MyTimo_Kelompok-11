import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'add_treatment_screen.dart';
import 'treatment_progress_screen.dart';

/// Screen 33: Status & Kendali Khusus
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentStatusScreen extends StatelessWidget {
  const TreatmentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        title: const Text(
          'Status & Kendali Khusus',
          style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      body: Consumer<TreatmentProvider>(
        builder: (context, provider, _) {
          final overdue = provider.overduePlans;
          final active = provider.activePlans;
          final completed = provider.completedPlans;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(
                    active.length, completed.length, overdue.length),
                const SizedBox(height: AppSizes.p16),
                if (overdue.isNotEmpty) ...[
                  _buildOverdueAlert(context, overdue, provider),
                  const SizedBox(height: AppSizes.p16),
                ],
                _buildNeedUpdateSection(context, active, provider),
                const SizedBox(height: AppSizes.p24),
                AppButton(
                  label: '+ Buat Rencana Baru',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: provider,
                          child: const AddTreatmentScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.p24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(int active, int completed, int overdue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ringkasan Status', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                label: 'Rencana Aktif',
                value: '$active',
                color: AppColors.primaryGreen,
                bgColor: AppColors.greenBadgeBackground,
                icon: Icons.play_circle_rounded,
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Expanded(
              child: _summaryCard(
                label: 'Selesai',
                value: '$completed',
                color: const Color(0xFF1565C0),
                bgColor: const Color(0xFFE3F2FD),
                icon: Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(width: AppSizes.p10),
            Expanded(
              child: _summaryCard(
                label: 'Terlambat',
                value: '$overdue',
                color: AppColors.tomatoRed,
                bgColor: AppColors.tomatoRedLight,
                icon: Icons.alarm_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSizes.roundedXL,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSizes.p8),
          Text(
            value,
            style: AppTextStyles.metricValue.copyWith(color: color),
          ),
          const SizedBox(height: AppSizes.p2),
          Text(
            label,
            style: AppTextStyles.metricLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueAlert(BuildContext context, List<TreatmentPlan> overdue,
      TreatmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_rounded,
                color: AppColors.tomatoRed, size: 18),
            const SizedBox(width: AppSizes.p6),
            const Text('Rencana Terlambat',
                style: AppTextStyles.sectionTitle),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.tomatoRedLight,
            borderRadius: AppSizes.roundedXL,
            border:
                Border.all(color: AppColors.tomatoRed.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${overdue.length} rencana melewati target tanggal selesai. Segera ambil tindakan!',
                style: AppTextStyles.body.copyWith(color: AppColors.tomatoRed),
              ),
              const SizedBox(height: AppSizes.p12),
              ...overdue.map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.p8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: provider,
                              child:
                                  TreatmentProgressScreen(planId: plan.id),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.p12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppSizes.roundedM,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(plan.plantName,
                                      style: AppTextStyles.bodyMedium),
                                  Text(plan.diseaseName,
                                      style: AppTextStyles.bodyMuted),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: AppColors.tomatoRed),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNeedUpdateSection(BuildContext context,
      List<TreatmentPlan> active, TreatmentProvider provider) {
    if (active.isEmpty) {
      return AppCard(
        child: Column(
          children: [
            const Icon(Icons.assignment_turned_in_rounded,
                color: AppColors.primaryGreen, size: 40),
            const SizedBox(height: AppSizes.p12),
            const Text('Semua rencana sudah diperbarui!',
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSizes.p4),
            const Text('Tidak ada rencana aktif yang perlu diperbarui.',
                style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rencana Aktif', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        ...active.map((plan) {
          final remaining =
              plan.totalSteps - plan.completedSteps;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.p10),
            child: AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: provider,
                      child: TreatmentProgressScreen(planId: plan.id),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenSoft,
                      borderRadius: AppSizes.roundedM,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: plan.progressPercent,
                          strokeWidth: 4,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen),
                        ),
                        Text(
                          '${(plan.progressPercent * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.plantName, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: AppSizes.p2),
                        Text(
                          '$remaining langkah tersisa',
                          style: AppTextStyles.bodyMuted,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p10, vertical: AppSizes.p4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(plan.priority)
                          .withValues(alpha: 0.1),
                      borderRadius: AppSizes.roundedFull,
                    ),
                    child: Text(
                      plan.priority.label,
                      style: AppTextStyles.badgeText.copyWith(
                          color: _getPriorityColor(plan.priority)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _getPriorityColor(TreatmentPriority priority) {
    switch (priority) {
      case TreatmentPriority.rendah:
        return AppColors.textSecondary;
      case TreatmentPriority.sedang:
        return AppColors.warningOrange;
      case TreatmentPriority.tinggi:
        return const Color(0xFFE65100);
      case TreatmentPriority.mendesak:
        return AppColors.tomatoRed;
    }
  }
}

