import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/disease_model.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';

/// Bagian Pemeriksaan Terbaru sesuai Desain Figma Frame: home
/// Menampilkan kartu hasil deteksi visual (Tomat Cherry Blok A & Tomat Servo Bedeng 1)
/// serta mendukung navigasi detail penanganan penyakit (FR-05).
class RecentDiagnosisSection extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const RecentDiagnosisSection({
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Pemeriksaan Terbaru',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            GestureDetector(
              onTap: onSeeAll ??
                  () {
                    _showAllDiagnosesModal(context);
                  },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.homeSeeAllText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2 Side-by-side Cards
        Row(
          children: [
            // Card 1: Tomat Cherry Blok A (Early Blight)
            Expanded(
              child: _buildInspectionCard(
                context,
                imageAsset: 'assets/images/hero_tomatoes.webp',
                badgeText: 'Early Blight',
                badgeBg: AppColors.homeBadgeEarlyBlightBg,
                badgeTextColor: AppColors.homeBadgeEarlyBlightText,
                title: 'Tomat Cherry Blok A',
                subtitle: 'Hari ini • 94.2%',
                diseaseId: 'early_blight',
              ),
            ),
            const SizedBox(width: 10),

            // Card 2: Tomat Servo Bedeng 1 (Septoria)
            Expanded(
              child: _buildInspectionCard(
                context,
                imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
                badgeText: 'Septoria',
                badgeBg: AppColors.homeBadgeSeptoriaBg,
                badgeTextColor: AppColors.homeBadgeSeptoriaText,
                title: 'Tomat Servo Bedeng 1',
                subtitle: 'Kemarin • 88.0%',
                diseaseId: 'septoria',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInspectionCard(
    BuildContext context, {
    required String imageAsset,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String title,
    required String subtitle,
    required String diseaseId,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDiseaseDetails(context, diseaseId),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 152,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image with Badge
                SizedBox(
                  height: 92,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                          ),
                        ),
                      ),
                      // Badge
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.0,
                              fontWeight: FontWeight.w700,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Content
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDiseaseDetails(BuildContext context, String diseaseId) {
    final dashboard = context.read<DashboardProvider>();
    final disease = dashboard.diseases.firstWhere(
      (d) =>
          d.id.toLowerCase() == diseaseId.toLowerCase() ||
          d.localName.toLowerCase().contains(diseaseId.toLowerCase()) ||
          d.scientificName.toLowerCase().contains(diseaseId.toLowerCase()),
      orElse: () => dashboard.diseases.isNotEmpty
          ? dashboard.diseases.first
          : const DiseaseModel(
              id: 'early_blight',
              localName: 'Early Blight (Alternaria)',
              scientificName: 'Alternaria solani',
              category: 'Jamur / Fungi',
              description:
                  'Bercak cincin konsentris coklat kehitaman pada daun bagian bawah tanaman tomat.',
              treatmentSteps: [
                'Pangkas daun yang terinfeksi dan buang jauh dari area kebun',
                'Semprotkan fungisida kontak berbahan aktif Mankozeb 2-3 g/L',
                'Atur jarak tanam agar sirkulasi udara lebih lancar',
              ],
              preventionSteps: [
                'Lakukan rotasi tanaman non-Solanaceae minimal 2 musim',
                'Gunakan mulsa plastik perak untuk menekan percikan air tanah',
                'Hindari penyiraman daun secara langsung (overhead watering)',
              ],
              imagePath: 'assets/images/hero_tomatoes.webp',
            ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DiseaseDetailSheet(disease: disease),
    );
  }

  void _showAllDiagnosesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Semua Riwayat Pemeriksaan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEFDF64),
                    child: Icon(Icons.bug_report, color: Color(0xFFBA6900)),
                  ),
                  title: const Text('Tomat Cherry Blok A - Early Blight (94.2%)'),
                  subtitle: const Text('Hari ini, 08:30 WIB • Lahan A'),
                  onTap: () {
                    Navigator.pop(context);
                    _openDiseaseDetails(context, 'early_blight');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFB1B1),
                    child: Icon(Icons.coronavirus, color: Color(0xFFCC0000)),
                  ),
                  title: const Text('Tomat Servo Bedeng 1 - Septoria (88.0%)'),
                  subtitle: const Text('Kemarin, 15:20 WIB • Bedeng 1'),
                  onTap: () {
                    Navigator.pop(context);
                    _openDiseaseDetails(context, 'septoria');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DiseaseDetailSheet extends StatelessWidget {
  final DiseaseModel disease;

  const _DiseaseDetailSheet({required this.disease});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radius2XL),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSizes.p24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p16),

              // Title & Scientific Name
              Text(disease.localName, style: AppTextStyles.heading2),
              const SizedBox(height: AppSizes.p4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.tomatoRedLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      disease.category,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tomatoRed,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    disease.scientificName,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p12),

              // Description
              Text(disease.description, style: AppTextStyles.body),
              const SizedBox(height: AppSizes.p20),

              // Treatment Steps (FR-05)
              const Text('Langkah Penanganan (FR-05)', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSizes.p8),
              ...disease.treatmentSteps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.p6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primaryGreen,
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p10),
                      Expanded(child: Text(entry.value, style: AppTextStyles.body)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p20),

              // Prevention Steps
              const Text('Langkah Pencegahan', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSizes.p8),
              ...disease.preventionSteps.map(
                (step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.p4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: AppSizes.p8),
                      Expanded(child: Text(step, style: AppTextStyles.body)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p28),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Tutup Panduan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
