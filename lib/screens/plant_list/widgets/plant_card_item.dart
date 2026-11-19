import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/plant_model.dart';
import '../../../providers/plant_provider.dart';
import '../../../widgets/app_success_dialog.dart';
import '../../../widgets/delete_plant_dialog.dart';
import '../edit_plant_screen.dart';
import '../plant_detail_screen.dart';

/// Kartu Tanaman sesuai Desain Figma Frame: plant_list
/// Menampilkan foto tanaman, nama, varietas & HST, lokasi dengan ikon pin hijau,
/// serta badge diagnosis status (Early Blight, Sehat, Late Blight).
class PlantCardItem extends StatelessWidget {
  final PlantModel plant;
  final VoidCallback? onTap;

  const PlantCardItem({
    super.key,
    required this.plant,
    this.onTap,
  });

  Future<void> _navigateToDetail(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailScreen(plant: plant),
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlantScreen(plant: plant),
      ),
    );

    if (result == true && context.mounted) {
      AppSuccessDialog.show(
        context: context,
        title: 'Data Tanaman Berhasil Diperbarui!',
        message: 'Data "${plant.name}" berhasil diperbarui dan disimpan.',
        buttonText: 'Lihat Daftar Tanaman',
        autoDismissDuration: null,
        onContinue: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ?? () => _navigateToDetail(context),
          onLongPress: () => _showPlantDetailSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Foto Thumbnail Tanaman (72x72)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.asset(
                      plant.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE8F5E9),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: Color(0xFF2C961B),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Info Tanaman (Nama, Varietas & HST, Lokasi)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header baris nama & badge status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (plant.isNew) ...[
                            Container(
                              margin: const EdgeInsets.only(right: 6, top: 1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF178401),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                          Expanded(
                            child: Text(
                              plant.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Badge Diagnosis Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: plant.badgeBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              plant.badgeText,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: plant.badgeTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Varietas & HST (misal: "Cherry Tropis • 63 HST")
                      Text(
                        '${plant.variety} • ${plant.hst} HST',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7E7E7E),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Lokasi Tanaman (Ikon Pin Hijau + Teks)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: Color(0xFF389D33),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              plant.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                          ),
                        ],
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

  void _showPlantDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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

              // Detail Header
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      plant.imagePath,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${plant.variety} • Usia ${plant.hst} HST',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF7E7E7E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: plant.badgeBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      plant.badgeText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: plant.badgeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF3EDED)),
              const SizedBox(height: 12),

              // Info Baris Lokasi & Status
              _buildDetailInfoRow(
                icon: Icons.location_on_outlined,
                iconColor: const Color(0xFF389D33),
                label: 'Lokasi Bedeng',
                value: plant.location,
              ),
              const SizedBox(height: 10),
              _buildDetailInfoRow(
                icon: Icons.shield_outlined,
                iconColor: plant.badgeTextColor,
                label: 'Status Kesehatan',
                value: plant.status,
              ),
              const SizedBox(height: 10),
              _buildDetailInfoRow(
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFF178401),
                label: 'Hari Setelah Tanam',
                value: '${plant.hst} HST',
              ),
              const SizedBox(height: 20),

              // Tombol Aksi: Hapus Tanaman, Edit Tanaman, Tutup
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _confirmDeletePlant(context);
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFDC2626),
                        size: 16,
                      ),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _navigateToEdit(context);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF178401),
                        size: 16,
                      ),
                      label: const Text(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF178401),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: const BorderSide(color: Color(0xFF178401)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C961B),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDeletePlant(BuildContext context) async {
    final confirmed = await DeletePlantDialog.show(
      context: context,
      plantName: plant.name,
      title: 'Hapus Data Tanaman?',
      message: 'Apakah anda yakin ingin menghapus\ndata tanaman ini',
    );

    if (confirmed == true && context.mounted) {
      Provider.of<PlantProvider>(context, listen: false).deletePlant(plant.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tanaman "${plant.name}" telah dihapus'),
          backgroundColor: const Color(0xFFDC2626),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildDetailInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
