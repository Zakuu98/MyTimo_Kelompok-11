import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

/// Screen 22: Panduan Pencegahan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class PreventionScreen extends StatelessWidget {
  const PreventionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textWhite,
          title: const Text(
            'Panduan Pencegahan',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.textWhite),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.textWhite,
            indicatorWeight: 3,
            labelColor: AppColors.textWhite,
            unselectedLabelColor: Color(0xAAFFFFFF),
            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            tabs: [
              Tab(text: 'Pencegahan'),
              Tab(text: 'Pemulihan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PencegahanTab(),
            _PemulihanTab(),
          ],
        ),
      ),
    );
  }
}

class _PencegahanTab extends StatelessWidget {
  const _PencegahanTab();

  @override
  Widget build(BuildContext context) {
    final tips = [
      (
        'Rotasi Tanaman Non-Solanaceae',
        'Lakukan rotasi tanaman dengan tanaman bukan solanaceae (bukan tomat, cabai, terong) minimal setiap musim tanam untuk memutus siklus penyakit.',
        Icons.autorenew_rounded,
      ),
      (
        'Jarak Tanam & Mulsa Plastik',
        'Pastikan jarak tanam minimal 50-60 cm antar tanaman. Gunakan mulsa plastik hitam perak untuk mencegah percikan tanah ke daun.',
        Icons.straighten_rounded,
      ),
      (
        'Penyiraman yang Tepat',
        'Siram di pagi hari menggunakan drip irrigation. Hindari membasahi daun karena kelembaban daun mempercepat sporulasi jamur.',
        Icons.water_drop_rounded,
      ),
      (
        'Pemupukan Kalium Seimbang',
        'Tingkatkan dosis pupuk kalium (K) untuk memperkuat dinding sel tanaman. Tanaman dengan kalium cukup lebih tahan terhadap infeksi jamur.',
        Icons.science_rounded,
      ),
      (
        'Fungisida Preventif',
        'Semprotkan fungisida protektif berbahan aktif tembaga atau mankozeb sebelum musim hujan atau ketika kelembaban tinggi.',
        Icons.sanitizer_rounded,
      ),
      (
        'Pemilihan Varietas Tahan Penyakit',
        'Pilih varietas tomat yang memiliki ketahanan terhadap Early Blight seperti varietas F1 hibrida yang sudah diuji.',
        Icons.eco_rounded,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSizes.p16),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.greenBadgeBackground,
            borderRadius: AppSizes.roundedXL,
            border: Border.all(color: AppColors.primaryGreenLight.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: AppSizes.p10),
              Expanded(
                child: Text(
                  'Pencegahan lebih efektif dan murah dibanding pengobatan. Terapkan langkah-langkah ini secara rutin.',
                  style: AppTextStyles.body.copyWith(color: AppColors.primaryGreenText),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        ...tips.asMap().entries.map((entry) {
          final i = entry.key + 1;
          final tip = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.p12),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenSoft,
                      borderRadius: AppSizes.roundedM,
                    ),
                    child: Icon(tip.$3, color: AppColors.primaryGreen, size: 22),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$i',
                                style: AppTextStyles.badgeText.copyWith(
                                  color: AppColors.textWhite,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.p8),
                            Expanded(
                              child: Text(
                                tip.$1,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.p6),
                        Text(tip.$2, style: AppTextStyles.bodyMuted),
                      ],
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
}

class _PemulihanTab extends StatelessWidget {
  const _PemulihanTab();

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        'Isolasi Tanaman Terinfeksi',
        'Segera pisahkan tanaman yang terinfeksi dari tanaman sehat untuk mencegah penyebaran lebih lanjut melalui angin atau percikan air.',
        Icons.shield_rounded,
        AppColors.tomatoRed,
        AppColors.tomatoRedLight,
      ),
      (
        'Pemangkasan Daun Sakit',
        'Pangkas seluruh daun dan bagian tanaman yang menunjukkan gejala penyakit. Bakar atau kubur jauh dari area pertanian.',
        Icons.content_cut_rounded,
        AppColors.warningOrange,
        AppColors.warningOrangeLight,
      ),
      (
        'Aplikasi Fungisida Kuratif',
        'Gunakan fungisida sistemik seperti azoksistrobin, difenokonazol, atau propikonazol. Ikuti dosis anjuran pada label produk.',
        Icons.local_pharmacy_rounded,
        AppColors.primaryGreen,
        AppColors.greenBadgeBackground,
      ),
      (
        'Perbaiki Nutrisi Tanaman',
        'Berikan pupuk daun kaya Kalium dan Kalsium untuk memperkuat sistem pertahanan tanaman. Tambahkan pupuk organik untuk memperbaiki kondisi tanah.',
        Icons.grass_rounded,
        AppColors.primaryGreen,
        AppColors.greenBadgeBackground,
      ),
      (
        'Monitoring Rutin',
        'Periksa kondisi tanaman setiap 3-5 hari setelah penanganan. Dokumentasikan perkembangan dan sesuaikan tindakan jika diperlukan.',
        Icons.monitor_heart_rounded,
        AppColors.primaryGreen,
        AppColors.greenBadgeBackground,
      ),
      (
        'Sterilisasi Alat & Lingkungan',
        'Bersihkan alat pertanian dengan larutan tembaga sulfat 1%. Sanitasi lahan dari sisa tanaman sakit setelah musim panen selesai.',
        Icons.cleaning_services_rounded,
        AppColors.warningOrange,
        AppColors.warningOrangeLight,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSizes.p16),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.tomatoRedLight,
            borderRadius: AppSizes.roundedXL,
            border: Border.all(color: AppColors.tomatoRed.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.healing_rounded, color: AppColors.tomatoRed, size: 20),
              const SizedBox(width: AppSizes.p10),
              Expanded(
                child: Text(
                  'Lakukan langkah pemulihan sesegera mungkin setelah diagnosis dikonfirmasi untuk meminimalkan kerugian panen.',
                  style: AppTextStyles.body.copyWith(color: AppColors.tomatoRed),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        ...steps.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.p12),
              child: AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.p10),
                      decoration: BoxDecoration(
                        color: step.$5,
                        borderRadius: AppSizes.roundedM,
                      ),
                      child: Icon(step.$3, color: step.$4, size: 22),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(step.$1, style: AppTextStyles.bodyMedium),
                          const SizedBox(height: AppSizes.p4),
                          Text(step.$2, style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

