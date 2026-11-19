import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/mytimo_bottom_nav.dart';
import 'prevention_screen.dart';
import 'treatment_plan_screen.dart';

/// Screen 21: Rekomendasi Penanganan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class TreatmentRecommendationScreen extends StatelessWidget {
  final String diseaseName;
  final double confidence;
  final String plantName;

  const TreatmentRecommendationScreen({
    super.key,
    this.diseaseName = 'Early Blight',
    this.confidence = 94.2,
    this.plantName = 'Tomat Cherry Blok A',
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        'Pangkas Daun Bawah Berpenyakit',
        'Gunting tangkai daun berbercak dengan gunting bersih, masukkan kantong dan bakar di luar lahan.',
      ),
      (
        'Semprot Fungisida Tembaga (2g/L)',
        'Aplikasikan fungisida tembaga atau ekstrak nabati mimba pada pagi hari sebelum sinar matahari terik.',
      ),
      (
        'Atur Irigasi Pangkal Batang',
        'Siram langsung tanah pangkal tanaman. Jangan membasahi helai daun di sore atau malam hari.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        title: const Text(
          'Rekomendasi Penanganan',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Alert Card Merah Oranye - Penanganan Kuratif Segera
                  _buildAlertCard(),
                  const SizedBox(height: 16),
                  // Langkah-langkah penanganan
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: steps.asMap().entries.map((e) {
                        return _buildStepCard(e.key + 1, e.value.$1, e.value.$2);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol bawah
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Tombol Jadikan Rencana
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TreatmentPlanScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.assignment_outlined, color: Colors.white, size: 20),
                            label: const Text(
                              'Jadikan Rencana Penanganan (Plan)',
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
                        const SizedBox(height: 12),
                        // Tombol lihat pencegahan
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PreventionScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shield_outlined, color: AppColors.primaryGreen, size: 20),
                            label: const Text(
                              'Lihat Panduan Pencegahan',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyTimoBottomNav(activeIndex: 2),
    );
  }

  Widget _buildAlertCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFF57C00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PENANGANAN KURATIF SEGERA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$diseaseName • $plantName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(int number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
