import 'package:flutter/material.dart';
import '../screens/scan/scan_history_screen.dart';

/// Modal dialog konfirmasi hapus riwayat pemindaian sesuai Desain Figma Frame: Hapus_Riwayat
/// Menampilkan:
/// - Backdrop gelap #0F172A opacity 0.55
/// - Kartu sheet bulat #F3EDED (borderRadius 30px)
/// - Badge mengambang ikon tempat sampah gradien merah-oranye
/// - Judul: "Hapus Riwayat Scan?"
/// - Deskripsi: "Apakah anda yakin ingin menghapus data riwayat pemindaian ini"
/// - Kartu pratinjau data scan (foto daun, nama penyakit & akurasi, nama tanaman, tanggal, status badge)
/// - Kotak/baris peringatan merah: "Peringatan! Foto daun, hasil AI, dan catatan tidak dapat dipulihkan."
/// - Tombol Batal (#FFFFFF) dan Tombol Hapus (gradien merah-oranye #D91C1C -> #E89746)
class DeleteScanHistoryDialog extends StatelessWidget {
  final ScanHistoryItem? item;
  final String diseaseName;
  final double confidence;
  final String plantName;
  final String dateTimeText;
  final String status;
  final String imageAsset;
  final VoidCallback? onConfirm;

  const DeleteScanHistoryDialog({
    super.key,
    this.item,
    this.diseaseName = 'Early Blight',
    this.confidence = 94.2,
    this.plantName = 'Tomat Cherry Blok A',
    this.dateTimeText = '06 Okt 2026, 14:20',
    this.status = 'Sedang',
    this.imageAsset = 'assets/custom_assets/images/jamur_septoria.png',
    this.onConfirm,
  });

  /// Static helper untuk menampilkan dialog konfirmasi hapus riwayat scan
  static Future<bool?> show({
    required BuildContext context,
    ScanHistoryItem? item,
    String? diseaseName,
    double? confidence,
    String? plantName,
    String? dateTimeText,
    String? status,
    String? imageAsset,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: const Color(0xFF0F172A).withValues(alpha: 0.55),
      barrierDismissible: true,
      builder: (ctx) => DeleteScanHistoryDialog(
        item: item,
        diseaseName: diseaseName ?? item?.diseaseName ?? 'Early Blight',
        confidence: confidence ?? item?.confidence ?? 94.2,
        plantName: plantName ?? item?.plantName ?? 'Tomat Cherry Blok A',
        dateTimeText: dateTimeText ?? item?.dateTimeText ?? '06 Okt 2026, 14:20',
        status: status ?? item?.status ?? 'Sedang',
        imageAsset: imageAsset ?? item?.imageAsset ?? 'assets/custom_assets/images/jamur_septoria.png',
        onConfirm: onConfirm,
      ),
    );
  }

  Color get _badgeBgColor {
    switch (status.toLowerCase()) {
      case 'sehat':
        return const Color(0xFFDCFCE7);
      case 'parah':
        return const Color(0xFFFEE2E2);
      case 'sedang':
      default:
        return const Color(0xFFEFDF64);
    }
  }

  Color get _badgeTextColor {
    switch (status.toLowerCase()) {
      case 'sehat':
        return const Color(0xFF16A34A);
      case 'parah':
        return const Color(0xFFCC0000);
      case 'sedang':
      default:
        return const Color(0xFFBA6900);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // 1. Kartu Sheet Utama #F3EDED (borderRadius 30px)
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDED),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 38, 20, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul: "Hapus Riwayat Scan?"
                    const Text(
                      'Hapus Riwayat Scan?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                        color: Colors.black,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Deskripsi: "Apakah anda yakin ingin menghapus data riwayat pemindaian ini"
                    const Text(
                      'Apakah anda yakin ingin menghapus data riwayat pemindaian ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF7E7E7E),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Kartu Pratinjau Item Riwayat (289x78px, borderRadius 22px)
                    _buildScanPreviewCard(),
                    const SizedBox(height: 12),

                    // Kotak / Section Peringatan Merah
                    _buildWarningSection(),
                    const SizedBox(height: 18),

                    // Baris Tombol Aksi (Batal & Hapus)
                    _buildActionButtons(context),
                  ],
                ),
              ),

              // 2. FAB Mengambang Tempat Sampah (Lingkaran Putih + Gradien Merah-Oranye)
              Positioned(
                top: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x2E000000), // rgba(0, 0, 0, 0.18)
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFD9221E),
                            Color(0xFFD46031),
                            Color(0xFFE89A42),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Kartu Pratinjau Item Riwayat (289x78px)
  Widget _buildScanPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17002600), // rgba(0, 38, 0, 0.09)
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto Thumbnail Daun (64x60px, borderRadius 16px)
          Container(
            width: 64,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF2E7D32),
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.white70,
                  size: 26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Info Penyakit, Tanaman, dan Waktu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Judul Penyakit & Persentase Akurasi
                Text(
                  '$diseaseName (${confidence.toStringAsFixed(1)}%)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),

                // Nama Tanaman
                Text(
                  plantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
                const SizedBox(height: 3),

                // Waktu Scan dengan Ikon Jam
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/custom_assets/icons/ic_clock.png',
                      width: 11,
                      height: 11,
                      color: const Color(0xFF8E8E8E),
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        dateTimeText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Status Badge (e.g. Sedang #EFDF64, text #BA6900)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _badgeBgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: _badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kotak Peringatan: "Peringatan! Foto daun, hasil AI, dan catatan tidak dapat dipulihkan."
  Widget _buildWarningSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD91C1C),
              size: 18,
            ),
            SizedBox(width: 6),
            Text(
              'Peringatan!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFFD91C1C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          'Foto daun, hasil AI, dan catatan tidak dapat dipulihkan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 11,
            height: 1.3,
            color: Color(0xFFD91C1C),
          ),
        ),
      ],
    );
  }

  /// Tombol Batal & Hapus
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Tombol Batal
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000), // rgba(0, 0, 0, 0.12)
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(21),
              child: InkWell(
                borderRadius: BorderRadius.circular(21),
                onTap: () => Navigator.of(context).pop(false),
                child: const Center(
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Tombol Hapus (Gradien Merah-Oranye #D91C1C -> #E89746)
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD91C1C), Color(0xFFE89746)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(21),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33D91C1C),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(21),
              child: InkWell(
                borderRadius: BorderRadius.circular(21),
                onTap: () {
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
                child: const Center(
                  child: Text(
                    'Hapus',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
