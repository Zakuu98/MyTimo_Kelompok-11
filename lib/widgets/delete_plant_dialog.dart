import 'package:flutter/material.dart';

/// Modal dialog konfirmasi hapus data tanaman sesuai Desain Figma Frame: plant_detail_Hapus
/// Menampilkan backdrop gelap, kartu sheet bulat dengan badge ikon tempat sampah mengambang,
/// nama tanaman, serta tombol Batal dan Hapus (gradien merah-oranye).
class DeletePlantDialog extends StatelessWidget {
  final String plantName;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;

  const DeletePlantDialog({
    super.key,
    required this.plantName,
    this.title = 'Hapus Data Tanaman?',
    this.message = 'Apakah anda yakin ingin menghapus\ndata tanaman ini',
    this.confirmText = 'Hapus',
    this.cancelText = 'Batal',
    this.onConfirm,
  });

  /// Static helper untuk menampilkan dialog konfirmasi hapus
  static Future<bool?> show({
    required BuildContext context,
    required String plantName,
    String title = 'Hapus Data Tanaman?',
    String message = 'Apakah anda yakin ingin menghapus\ndata tanaman ini',
    String confirmText = 'Hapus',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: const Color(0xFF0F172A).withValues(alpha: 0.55),
      barrierDismissible: true,
      builder: (ctx) => DeletePlantDialog(
        plantName: plantName,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
      ),
    );
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
              // 1. Kartu Dialog (Sheet)
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
                padding: const EdgeInsets.fromLTRB(20, 42, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul: "Hapus Data Tanaman?"
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                        color: Colors.black,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Deskripsi: "Apakah anda yakin ingin menghapus..."
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF7E7E7E),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kartu Pill Nama Tanaman (e.g. "Tomat Cherry Blok A")
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000), // rgba(0,0,0,0.1)
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        plantName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF106804),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Baris Tombol Aksi (Batal & Hapus)
                    Row(
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
                                  color: Color(0x1F000000), // rgba(0,0,0,0.12)
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
                                child: Center(
                                  child: Text(
                                    cancelText,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
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

                        // Tombol Hapus (Gradien Merah-Oranye)
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD91C1C),
                                  Color(0xFFE89746),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(21),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33D91C1C),
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
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                  onConfirm?.call();
                                },
                                child: Center(
                                  child: Text(
                                    confirmText,
                                    style: const TextStyle(
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
                    ),
                  ],
                ),
              ),

              // 2. FAB Ring & FAB Floating Badge (Ikon Tempat Sampah)
              Positioned(
                top: 0,
                child: Container(
                  width: 61,
                  height: 61,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x2E000000), // rgba(0,0,0,0.18)
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 49,
                      height: 49,
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
}
