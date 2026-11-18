import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'prevention_screen.dart';
import 'add_treatment_screen.dart';

/// Screen 21: Rekomendasi Penanganan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentRecommendationScreen extends StatelessWidget {
  final String diseaseName;
  final double confidence;

  const TreatmentRecommendationScreen({
    super.key,
    this.diseaseName = 'Bercak Kering (Early Blight)',
    this.confidence = 84.2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        title: const Text(
          'Rekomendasi Penanganan',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiseaseHeader(),
            const SizedBox(height: AppSizes.p16),
            _buildGejalaVisual(),
            const SizedBox(height: AppSizes.p16),
            _buildLangkahPenanganan(),
            const SizedBox(height: AppSizes.p16),
            _buildFaktorRisiko(),
            const SizedBox(height: AppSizes.p24),
            _buildBottomActions(context),
            const SizedBox(height: AppSizes.p24),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseHeader() {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.tomatoRedLight,
                  borderRadius: AppSizes.roundedM,
                ),
                child: const Icon(
                  Icons.bug_report_rounded,
                  color: AppColors.tomatoRed,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSizes.p12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Penyakit Terdeteksi', style: AppTextStyles.bodyMuted),
                    const SizedBox(height: AppSizes.p4),
                    Text(diseaseName, style: AppTextStyles.heading3),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p16),
          Row(
            children: [
              _buildBadge(
                '${confidence.toStringAsFixed(1)}% Akurat',
                AppColors.primaryGreen,
                AppColors.greenBadgeBackground,
                Icons.verified_rounded,
              ),
              const SizedBox(width: AppSizes.p8),
              _buildBadge(
                'Penanganan Diperlukan',
                AppColors.warningOrange,
                AppColors.warningOrangeLight,
                Icons.warning_amber_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color, Color bg, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p10,
        vertical: AppSizes.p6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSizes.roundedFull,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: AppSizes.p4),
          Text(
            label,
            style: AppTextStyles.badgeText.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildGejalaVisual() {
    final gejala = [
      (Icons.circle, 'Bercak coklat gelap berbentuk tidak beraturan pada daun'),
      (Icons.circle, 'Lingkaran kuning (halo) di sekitar bercak'),
      (Icons.circle, 'Daun menguning dan rontok secara bertahap'),
      (Icons.circle, 'Penyebaran dari daun bawah ke atas tanaman'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gejala Visual', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        AppCard(
          child: Column(
            children: gejala
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.p10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(item.$1, size: 8, color: AppColors.primaryGreen),
                          const SizedBox(width: AppSizes.p10),
                          Expanded(
                            child: Text(item.$2, style: AppTextStyles.body),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLangkahPenanganan() {
    final langkah = [
      'Pangkas dan buang daun yang terinfeksi segera',
      'Semprot fungisida berbahan aktif mankozeb atau klorotalonil setiap 7 hari',
      'Tingkatkan sirkulasi udara dengan mengatur jarak tanam',
      'Hindari penyiraman dari atas (gunakan drip irrigation)',
      'Tambahkan mulsa untuk mencegah percikan tanah ke daun',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Langkah Penanganan', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        AppCard(
          backgroundColor: AppColors.greenBadgeBackground,
          border: Border.all(color: AppColors.primaryGreenLight.withValues(alpha: 0.3)),
          child: Column(
            children: langkah.asMap().entries.map((entry) {
              final number = entry.key + 1;
              final text = entry.value;
              final isLast = entry.key == langkah.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$number',
                          style: AppTextStyles.badgeText.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSizes.p4),
                          child: Text(text, style: AppTextStyles.body),
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) const SizedBox(height: AppSizes.p12),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFaktorRisiko() {
    final risiko = [
      'Kelembaban tinggi (di atas 80%) mempercepat penyebaran spora',
      'Suhu 24–29°C adalah kondisi optimal perkembangan jamur',
      'Tanaman yang lemah akibat kekurangan nutrisi lebih rentan',
      'Rotasi tanaman tidak dilakukan sehingga inokulum bertahan di tanah',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Faktor Risiko Penyebaran', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.warningOrangeLight,
            borderRadius: AppSizes.roundedXL,
            border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warningOrange, size: 20),
                  const SizedBox(width: AppSizes.p8),
                  Text(
                    'Perhatian!',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warningOrange),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p12),
              ...risiko.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.p8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right_rounded, color: AppColors.warningOrange, size: 20),
                        const SizedBox(width: AppSizes.p6),
                        Expanded(child: Text(item, style: AppTextStyles.body)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: 'Buat Rencana Penanganan →',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<TreatmentProvider>(),
                  child: AddTreatmentScreen(initialDiseaseName: diseaseName),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSizes.p12),
        AppButton.secondary(
          label: 'Panduan Pencegahan →',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreventionScreen()),
            );
          },
        ),
      ],
    );
  }
}

