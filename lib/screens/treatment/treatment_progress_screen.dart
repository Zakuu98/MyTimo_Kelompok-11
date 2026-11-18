import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'edit_treatment_screen.dart';

/// Screen 25: Tracking Progres Penanganan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentProgressScreen extends StatelessWidget {
  final String planId;

  const TreatmentProgressScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TreatmentProvider>(
      builder: (context, provider, _) {
        final plan = provider.getPlanById(planId);
        if (plan == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Progres Penanganan')),
            body: const Center(child: Text('Rencana tidak ditemukan')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.textWhite,
            title: const Text(
              'Progres Penanganan',
              style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: const IconThemeData(color: AppColors.textWhite),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: provider,
                        child: EditTreatmentScreen(plan: plan),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressHeader(plan),
                const SizedBox(height: AppSizes.p16),
                _buildInfoCard(plan),
                const SizedBox(height: AppSizes.p16),
                _buildStepsSection(context, plan, provider),
                const SizedBox(height: AppSizes.p24),
                if (plan.status != TreatmentStatus.selesai &&
                    plan.status != TreatmentStatus.dibatalkan)
                  AppButton(
                    label: plan.completedSteps == plan.totalSteps
                        ? '✓ Tandai Selesai'
                        : 'Perbarui Progres',
                    onPressed: () {
                      if (plan.completedSteps == plan.totalSteps) {
                        _markAllDone(context, provider, plan);
                      }
                    },
                  ),
                const SizedBox(height: AppSizes.p12),
                if (plan.status != TreatmentStatus.dibatalkan &&
                    plan.status != TreatmentStatus.selesai)
                  AppButton(
                    label: 'Batalkan Rencana',
                    variant: AppButtonVariant.danger,
                    onPressed: () => _cancelPlan(context, provider, plan),
                  ),
                const SizedBox(height: AppSizes.p24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressHeader(TreatmentPlan plan) {
    final percent = (plan.progressPercent * 100).toInt();
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.p20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.plantName, style: AppTextStyles.heading3),
                    const SizedBox(height: AppSizes.p4),
                    Text(plan.diseaseName, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
              _buildStatusChip(plan),
            ],
          ),
          const SizedBox(height: AppSizes.p20),
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: plan.progressPercent,
                        strokeWidth: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          plan.status == TreatmentStatus.selesai
                              ? AppColors.primaryGreen
                              : AppColors.primaryGreenLight,
                        ),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: AppTextStyles.metricValue.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.p20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${plan.completedSteps} dari ${plan.totalSteps} langkah',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.p6),
                    ClipRRect(
                      borderRadius: AppSizes.roundedFull,
                      child: LinearProgressIndicator(
                        value: plan.progressPercent,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreen,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p8),
                    if (plan.isOverdue)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p10, vertical: AppSizes.p4),
                        decoration: BoxDecoration(
                          color: AppColors.tomatoRedLight,
                          borderRadius: AppSizes.roundedFull,
                        ),
                        child: Text(
                          '⚠️ Terlambat dari target',
                          style: AppTextStyles.badgeText
                              .copyWith(color: AppColors.tomatoRed),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TreatmentPlan plan) {
    Color color;
    switch (plan.status) {
      case TreatmentStatus.sedangBerjalan:
        color = AppColors.primaryGreen;
        break;
      case TreatmentStatus.selesai:
        color = const Color(0xFF1565C0);
        break;
      case TreatmentStatus.dibatalkan:
        color = AppColors.textMuted;
        break;
      case TreatmentStatus.belumDimulai:
        color = AppColors.warningOrange;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p12, vertical: AppSizes.p6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppSizes.roundedFull,
      ),
      child: Text(
        plan.status.label,
        style: AppTextStyles.badgeText.copyWith(color: color),
      ),
    );
  }

  Widget _buildInfoCard(TreatmentPlan plan) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    String formatDate(DateTime d) =>
        '${d.day} ${months[d.month]} ${d.year}';

    return AppCard(
      child: Column(
        children: [
          _infoRow(Icons.calendar_today_rounded, 'Dibuat',
              formatDate(plan.createdAt)),
          const Divider(height: AppSizes.p20),
          _infoRow(Icons.flag_rounded, 'Target Selesai',
              formatDate(plan.targetDate)),
          const Divider(height: AppSizes.p20),
          _infoRow(Icons.priority_high_rounded, 'Prioritas',
              plan.priority.label),
          if (plan.notes.isNotEmpty) ...[
            const Divider(height: AppSizes.p20),
            _infoRow(Icons.notes_rounded, 'Catatan', plan.notes),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: AppSizes.p10),
        SizedBox(
          width: 90,
          child: Text(label, style: AppTextStyles.bodyMuted),
        ),
        Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
      ],
    );
  }

  Widget _buildStepsSection(
      BuildContext context, TreatmentPlan plan, TreatmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Langkah Tindakan', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        ...plan.steps.map((step) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.p8),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16, vertical: AppSizes.p12),
              backgroundColor: step.isCompleted
                  ? AppColors.greenBadgeBackground
                  : AppColors.surface,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: step.isCompleted,
                    onChanged: plan.status == TreatmentStatus.selesai ||
                            plan.status == TreatmentStatus.dibatalkan
                        ? null
                        : (val) {
                            provider.updateStepStatus(
                                plan.id, step.id, val ?? false);
                          },
                    activeColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSizes.p10),
                      child: Text(
                        step.description,
                        style: step.isCompleted
                            ? AppTextStyles.body.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textMuted,
                              )
                            : AppTextStyles.body,
                      ),
                    ),
                  ),
                  if (step.isCompleted)
                    const Padding(
                      padding: EdgeInsets.only(top: AppSizes.p10),
                      child: Icon(Icons.check_circle_rounded,
                          size: 18, color: AppColors.primaryGreen),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _markAllDone(BuildContext context, TreatmentProvider provider,
      TreatmentPlan plan) {
    for (final step in plan.steps) {
      if (!step.isCompleted) {
        provider.updateStepStatus(plan.id, step.id, true);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Rencana penanganan telah selesai!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _cancelPlan(BuildContext context, TreatmentProvider provider,
      TreatmentPlan plan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Batalkan Rencana?'),
        content:
            const Text('Rencana penanganan akan ditandai sebagai dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              provider.updatePlan(
                  plan.copyWith(status: TreatmentStatus.dibatalkan));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rencana telah dibatalkan')),
              );
            },
            child: const Text('Ya, Batalkan',
                style: TextStyle(color: AppColors.tomatoRed)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TreatmentProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Rencana?'),
        content: const Text(
            'Rencana penanganan ini akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.deletePlan(planId);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rencana berhasil dihapus'),
                  backgroundColor: AppColors.tomatoRed,
                ),
              );
            },
            child: const Text('Hapus',
                style: TextStyle(color: AppColors.tomatoRed)),
          ),
        ],
      ),
    );
  }
}

