import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/mytimo_bottom_nav.dart';
import 'add_treatment_screen.dart';
import 'treatment_progress_screen.dart';

/// Screen 23: Daftar Rencana Penanganan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentPlanScreen extends StatefulWidget {
  const TreatmentPlanScreen({super.key});

  @override
  State<TreatmentPlanScreen> createState() => _TreatmentPlanScreenState();
}

class _TreatmentPlanScreenState extends State<TreatmentPlanScreen> {
  int _selectedTab = 0; // 0=Semua, 1=Aktif, 2=Selesai
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        title: const Text(
          'Rencana Penanganan',
          style: TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabFilter(),
          Expanded(child: _buildPlanList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<TreatmentProvider>(),
                child: const AddTreatmentScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add_rounded, color: AppColors.textWhite),
      ),
      bottomNavigationBar: const MyTimoBottomNav(activeIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.fromLTRB(
          AppSizes.p16, 0, AppSizes.p16, AppSizes.p16),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cari rencana atau tanaman...',
          hintStyle: AppTextStyles.formHint,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
          border: OutlineInputBorder(
            borderRadius: AppSizes.roundedXL,
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTabFilter() {
    return Consumer<TreatmentProvider>(
      builder: (context, provider, _) {
        final semua = provider.plans.length;
        final berjalan = provider.activePlans.length;
        final selesai = provider.completedPlans.length;
        final tabs = [
          ('Semua', semua),
          ('Berjalan', berjalan),
          ('Selesai', selesai),
        ];
        return Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16, vertical: AppSizes.p10),
          child: Row(
            children: tabs.asMap().entries.map((entry) {
              final isSelected = _selectedTab == entry.key;
              final label = entry.value.$1;
              final count = entry.value.$2;
              return Padding(
                padding: const EdgeInsets.only(right: AppSizes.p8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = entry.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p14, vertical: AppSizes.p8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : AppColors.background,
                      borderRadius: AppSizes.roundedFull,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : AppColors.border,
                      ),
                    ),
                    child: Text(
                      '$label ($count)',
                      style: AppTextStyles.badgeText.copyWith(
                        color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildPlanList() {
    return Consumer<TreatmentProvider>(
      builder: (context, provider, _) {
        List<TreatmentPlan> plans;
        switch (_selectedTab) {
          case 1:
            plans = provider.activePlans;
            break;
          case 2:
            plans = provider.completedPlans;
            break;
          default:
            plans = provider.plans.toList();
        }

        if (_searchQuery.isNotEmpty) {
          plans = plans
              .where((p) =>
                  p.plantName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  p.diseaseName.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
        }

        if (plans.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.p16),
          itemCount: plans.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSizes.p12),
          itemBuilder: (context, index) =>
              _buildPlanCard(context, plans[index], provider),
        );
      },
    );
  }

  Widget _buildPlanCard(
      BuildContext context, TreatmentPlan plan, TreatmentProvider provider) {
    final statusColor = _getStatusColor(plan.status);
    final priorityColor = _getPriorityColor(plan.priority);

    return AppCard(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.plantName, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppSizes.p2),
                    Text(plan.diseaseName, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
              _buildStatusBadge(plan.status.label, statusColor),
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppSizes.roundedFull,
                  child: LinearProgressIndicator(
                    value: plan.progressPercent,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      plan.status == TreatmentStatus.selesai
                          ? AppColors.primaryGreen
                          : AppColors.primaryGreenLight,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p10),
              Text(
                '${plan.completedSteps}/${plan.totalSteps}',
                style: AppTextStyles.metricLabel,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p10),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: AppSizes.p4),
              Text(
                'Target: ${_formatDate(plan.targetDate)}',
                style: AppTextStyles.metricLabel,
              ),
              const Spacer(),
              _buildStatusBadge(plan.priority.label, priorityColor),
            ],
          ),
          if (plan.isOverdue) ...[
            const SizedBox(height: AppSizes.p8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p10, vertical: AppSizes.p4),
              decoration: BoxDecoration(
                color: AppColors.tomatoRedLight,
                borderRadius: AppSizes.roundedFull,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.alarm_rounded,
                      size: 12, color: AppColors.tomatoRed),
                  const SizedBox(width: AppSizes.p4),
                  Text(
                    'Terlambat!',
                    style: AppTextStyles.badgeText
                        .copyWith(color: AppColors.tomatoRed),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p10, vertical: AppSizes.p4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppSizes.roundedFull,
      ),
      child: Text(
        label,
        style: AppTextStyles.badgeText.copyWith(color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p24),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreenSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined,
                  size: 56, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: AppSizes.p20),
            const Text('Belum Ada Rencana',
                style: AppTextStyles.heading3),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'Tambahkan rencana penanganan baru berdasarkan hasil diagnosis penyakit tanaman.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: AppSizes.p24),
            AppButton(
              label: '+ Buat Rencana Baru',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: context.read<TreatmentProvider>(),
                      child: const AddTreatmentScreen(),
                    ),
                  ),
                );
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TreatmentStatus status) {
    switch (status) {
      case TreatmentStatus.sedangBerjalan:
        return AppColors.primaryGreen;
      case TreatmentStatus.selesai:
        return const Color(0xFF1565C0);
      case TreatmentStatus.dibatalkan:
        return AppColors.textMuted;
      case TreatmentStatus.belumDimulai:
        return AppColors.warningOrange;
    }
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

  String _formatDate(DateTime date) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}

