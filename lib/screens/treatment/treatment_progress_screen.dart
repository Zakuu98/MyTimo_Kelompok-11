import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mytimo_bottom_nav.dart';
import 'edit_treatment_screen.dart';

/// Screen 25: Progres Penanganan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentProgressScreen extends StatelessWidget {
  final String planId;

  const TreatmentProgressScreen({super.key, required this.planId});

  String _formatDateTime(DateTime? d) {
    if (d == null) return '';
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return 'Selesai pada ${d.day} ${months[d.month]}, $hour:$minute';
  }

  String _formatDate(DateTime d) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TreatmentProvider>(
      builder: (context, provider, _) {
        final plan = provider.getPlanById(planId);
        if (plan == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Progres Penanganan'),
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: Text('Rencana tidak ditemukan')),
          );
        }

        final percent = (plan.progressPercent * 100).toInt();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
            title: const Text(
              'Progres Penanganan',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.textWhite),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: provider,
                      child: EditTreatmentScreen(plan: plan),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card - info progres
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.diseaseName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${plan.plantName} • Target: ${_formatDate(plan.targetDate)}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Status badge
                          _buildStatusBadge(plan.status),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: LinearProgressIndicator(
                                value: plan.progressPercent,
                                backgroundColor: AppColors.border,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryGreen),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$percent% Selesai',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kemajuan: ${plan.completedSteps} dari ${plan.totalSteps} selesai',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Checklist Section
                const Text(
                  'Checklist Tindakan Lapangan (Klik untuk update)',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                ...plan.steps.map((step) {
                  final isDone = step.isCompleted;
                  final isOverdue = !isDone && DateTime.now().isAfter(plan.targetDate);

                  return GestureDetector(
                    onTap: () {
                      if (plan.status != TreatmentStatus.selesai &&
                          plan.status != TreatmentStatus.dibatalkan) {
                        provider.updateStepStatus(plan.id, step.id, !isDone);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDone
                              ? AppColors.primaryGreen.withOpacity(0.3)
                              : isOverdue
                                  ? AppColors.tomatoRed.withOpacity(0.3)
                                  : AppColors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox icon
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppColors.primaryGreen
                                  : isOverdue
                                      ? AppColors.tomatoRedLight
                                      : AppColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDone
                                    ? AppColors.primaryGreen
                                    : isOverdue
                                        ? AppColors.tomatoRed
                                        : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: isDone
                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                : isOverdue
                                    ? const Icon(Icons.close, color: AppColors.tomatoRed, size: 16)
                                    : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isDone
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                if (isDone && step.completedAt != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '✓ ${_formatDateTime(step.completedAt)}',
                                    style: const TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontSize: 12,
                                    ),
                                  ),
                                ] else if (isOverdue) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '✗ Target: ${_formatDate(plan.targetDate)} (Belum Dilakukan)',
                                    style: const TextStyle(
                                      color: AppColors.tomatoRed,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Tombol Simpan Progres
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Progres tindakan berhasil disimpan!'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'Simpan Progres Tindakan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: const MyTimoBottomNav(activeIndex: 1),
        );
      },
    );
  }

  Widget _buildStatusBadge(TreatmentStatus status) {
    Color color;
    String label;
    switch (status) {
      case TreatmentStatus.sedangBerjalan:
        color = AppColors.primaryGreen;
        label = 'Berjalan';
        break;
      case TreatmentStatus.selesai:
        color = const Color(0xFF1565C0);
        label = 'Selesai';
        break;
      case TreatmentStatus.dibatalkan:
        color = AppColors.textMuted;
        label = 'Dibatalkan';
        break;
      case TreatmentStatus.belumDimulai:
        color = AppColors.warningOrange;
        label = 'Belum Mulai';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
