import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/plant_provider.dart';
import '../../../theme/app_colors.dart';

/// State Kosong (Empty State) Daftar Tanaman sesuai Desain Figma Frame: plant_list
/// Ditampilkan jika daftar tanaman kosong (user baru / seluruh tanaman telah dihapus).
class PlantEmptyState extends StatelessWidget {
  final VoidCallback onAddPlant;

  const PlantEmptyState({
    super.key,
    required this.onAddPlant,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Ilustrasi Pot Tanaman Kosong (72x69)
            Image.asset(
              'assets/custom_assets/images/illustration_empty_plant.png',
              width: 72,
              height: 69,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.eco_outlined,
                size: 64,
                color: Color(0xFF2D7A42),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Judul: "Belum Ada Data Tanaman"
            const Text(
              'Belum Ada Data Tanaman',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.plantEmptyTitle,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),

            // 3. Deskripsi Subtitle
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 290),
              child: const Text(
                'Tambahkan tanaman tomat pertama Anda untuk memulai pemantauan kesehatan dan riwayat pemindaian.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  color: AppColors.plantEmptyDesc,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Tombol Utama: "+ Tambah Tanaman Baru"
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: onAddPlant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.plantEmptyBtn,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  shadowColor: const Color(0x332D7A42),
                ),
                child: const Text(
                  '+ Tambah Tanaman Baru',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol opsional untuk kembalikan data dummy (Sangat berguna saat demo & testing)
            Consumer<PlantProvider>(
              builder: (context, provider, _) {
                return TextButton.icon(
                  onPressed: () {
                    provider.resetToDefault();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data dummy tanaman berhasil dipulihkan'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.replay_rounded,
                    size: 15,
                    color: Color(0xFF106804),
                  ),
                  label: const Text(
                    'Muat Ulang Data Dummy',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF106804),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
