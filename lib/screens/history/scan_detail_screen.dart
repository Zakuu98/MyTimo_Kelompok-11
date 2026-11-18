import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/scan_history_model.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/curved_header.dart';
import '../../widgets/delete_confirmation_dialog.dart';
import 'widgets/edit_scan_notes_bottom_sheet.dart';

/// Detail Riwayat Scan Screen sesuai Screenshot Desain 15_Detail_Ri & 16_Hapus_Ri
class ScanDetailScreen extends StatefulWidget {
  final String scanId;

  const ScanDetailScreen({super.key, required this.scanId});

  @override
  State<ScanDetailScreen> createState() => _ScanDetailScreenState();
}

class _ScanDetailScreenState extends State<ScanDetailScreen> {
  void _handleDeleteScan(ScanHistoryModel scan) {
    DeleteConfirmationDialog.show(
      context,
      title: 'Hapus Riwayat Scan?',
      subtitle: 'Apakah Anda yakin ingin menghapus data riwayat pemindaian ini?',
      previewContent: Container(
        padding: const EdgeInsets.all(AppSizes.p10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(scan.imagePath, width: 44, height: 44, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${scan.diseaseDetected} (${scan.formattedConfidence})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    '${scan.plantName} • ${scan.timestamp}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      warningText: 'Peringatan! Foto daun, hasil identifikasi AI, dan catatan penanganan ini akan dihapus permanen dari penyimpanan perangkat.',
      confirmLabel: 'Ya, Hapus',
      onConfirm: () {
        context.read<PlantProvider>().deleteScan(scan.id);
        AppToast.showSuccess(
          context,
          title: 'Riwayat scan berhasil dihapus',
          subtitle: 'Data telah dibersihkan dari penyimpanan lokal.',
        );
        Navigator.of(context).pop();
      },
    );
  }

  void _openEditNotesSheet(ScanHistoryModel scan) {
    EditScanNotesBottomSheet.show(
      context,
      scan: scan,
      onSaved: (newNotes) {
        context.read<PlantProvider>().updateScanNotes(scan.id, newNotes);
        AppToast.showSuccess(
          context,
          title: 'Catatan berhasil diperbarui!',
          subtitle: 'Perubahan riwayat scan telah disimpan.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final scan = plantProvider.getScanById(widget.scanId);

    if (scan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Riwayat')),
        body: const Center(child: Text('Data riwayat tidak ditemukan atau telah dihapus.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Header
          CurvedHeader(
            title: 'Detail Riwayat Scan',
            showBackButton: true,
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo with AI Bounding Box Overlay
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                      boxShadow: AppSizes.cardShadow,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                          child: Image.asset(
                            scan.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primaryGreenDark),
                          ),
                        ),

                        // Green Bounding Box Target on Leaf
                        Center(
                          child: Container(
                            width: 170,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.cameraGuideGreen,
                                width: 2,
                              ),
                              color: AppColors.cameraGuideGreen.withValues(alpha: 0.1),
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: AppColors.cameraGuideGreen,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  scan.diseaseDetected,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),

                  // Scan Info Card (Plant Name, Timestamp, Diagnosis Tag)
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: AppSizes.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${scan.plantName} • ${scan.timestamp}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: scan.isHealthy ? AppColors.statusGreenBg : AppColors.statusYellowBg,
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                              ),
                              child: Text(
                                scan.severity,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: scan.isHealthy ? AppColors.statusGreen : AppColors.statusYellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Diagnosis: ${scan.diseaseDetected} (${scan.formattedConfidence} Akurat)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),

                  // Catatan Riwayat Section
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: AppSizes.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Catatan Riwayat',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _openEditNotesSheet(scan),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 15, color: AppColors.primaryGreen),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scan.notes.isNotEmpty ? scan.notes : 'Belum ada catatan khusus untuk pemindaian ini.',
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.p28),

                  // Primary Button: Ubah / Simpan Perubahan Catatan
                  AppButton(
                    label: 'Ubah Catatan Riwayat',
                    prefixIcon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 22),
                    onPressed: () => _openEditNotesSheet(scan),
                  ),
                  const SizedBox(height: AppSizes.p12),

                  // Danger Button: Hapus Riwayat Scan Ini
                  AppButton.dangerOutline(
                    label: 'Hapus Riwayat Scan Ini',
                    prefixIcon: const Icon(Icons.delete_outline_rounded, color: AppColors.tomatoRed, size: 20),
                    onPressed: () => _handleDeleteScan(scan),
                  ),
                  const SizedBox(height: AppSizes.p20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
