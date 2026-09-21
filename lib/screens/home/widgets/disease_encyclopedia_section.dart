import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/disease_model.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';

/// Bagian Ensiklopedia Penyakit dengan kartu visual penyakit tomat dan panduan penanganan
class DiseaseEncyclopediaSection extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const DiseaseEncyclopediaSection({
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final diseases = dashboard.diseases;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primaryGreen,
                      size: AppSizes.iconSizeMedium,
                    ),
                    const SizedBox(width: AppSizes.p8),
                    Text(
                      'Ensiklopedia Penyakit',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 15.5),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onSeeAll ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menampilkan seluruh ensiklopedia penyakit tomat...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p12),

            // Horizontal / Grid Cards
            Row(
              children: diseases.map((disease) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: disease == diseases.first ? AppSizes.p10 : 0,
                      left: disease != diseases.first ? AppSizes.p10 : 0,
                    ),
                    child: _buildDiseaseCard(context, disease),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDiseaseCard(BuildContext context, DiseaseModel disease) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.roundedL,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppSizes.roundedL,
          onTap: () => _showDiseaseDetail(context, disease),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusL),
                ),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.asset(
                    disease.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryGreenSoft,
                        child: const Icon(
                          Icons.spa_rounded,
                          color: AppColors.primaryGreen,
                          size: 36,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Disease Label & Tag
              Padding(
                padding: const EdgeInsets.all(AppSizes.p10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Tag
                    Text(
                      disease.category,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tomatoRed,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p2),
                    // Disease Local Name
                    Text(
                      disease.localName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiseaseDetail(BuildContext context, DiseaseModel disease) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radius2XL)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.92,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.p8,
                          vertical: AppSizes.p4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tomatoRedLight,
                          borderRadius: AppSizes.roundedS,
                        ),
                        child: Text(
                          disease.category,
                          style: const TextStyle(
                            color: AppColors.tomatoRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p8),
                      Text(
                        disease.scientificName,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p8),
                  Text(disease.localName, style: AppTextStyles.heading2),
                  const SizedBox(height: AppSizes.p12),
                  ClipRRect(
                    borderRadius: AppSizes.roundedL,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        disease.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  const Text('Deskripsi Gejala', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppSizes.p6),
                  Text(disease.description, style: AppTextStyles.bodyMuted),
                  const SizedBox(height: AppSizes.p16),
                  const Text('Langkah Penanganan (FR-05)', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppSizes.p8),
                  ...disease.treatmentSteps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(step, style: AppTextStyles.body)),
                          ],
                        ),
                      )),
                  const SizedBox(height: AppSizes.p12),
                  const Text('Langkah Pencegahan', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppSizes.p8),
                  ...disease.preventionSteps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✓ ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                            Expanded(child: Text(step, style: AppTextStyles.body)),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
