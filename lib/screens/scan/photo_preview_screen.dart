import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/scan_history_model.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/curved_header.dart';
import '../history/scan_detail_screen.dart';

/// Pratinjau Foto Daun Screen sesuai Screenshot Desain 13_Pratinjau
class PhotoPreviewScreen extends StatefulWidget {
  final String imagePath;
  final bool isFile;
  final String inputSource;
  final String? preselectedPlantId;

  const PhotoPreviewScreen({
    super.key,
    required this.imagePath,
    this.isFile = false,
    this.inputSource = 'Kamera',
    this.preselectedPlantId,
  });

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  late final TextEditingController _notesController;
  String? _selectedPlantId;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: 'Bercak coklat kecokelatan di helai daun bawah ke-3.');

    final plantProvider = context.read<PlantProvider>();
    if (widget.preselectedPlantId != null &&
        plantProvider.getPlantById(widget.preselectedPlantId!) != null) {
      _selectedPlantId = widget.preselectedPlantId;
    } else if (plantProvider.allPlants.isNotEmpty) {
      _selectedPlantId = plantProvider.allPlants.first.id;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatCurrentTimestamp() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final minute = now.minute.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}, $hour:$minute';
  }

  void _handleSaveAndProceed() {
    if (_selectedPlantId == null) {
      AppToast.showError(context, message: 'Harap pilih tanaman untuk menghubungkan pemindaian.');
      return;
    }

    setState(() => _isProcessing = true);

    final plantProvider = context.read<PlantProvider>();
    final plant = plantProvider.getPlantById(_selectedPlantId!)!;

    final scanId = 'SCN-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    final timestamp = _formatCurrentTimestamp();

    // Catatan: Sesuai petunjuk pengerjaan (workflow step 3 & PRD),
    // data pemindaian (foto, ID tanaman, ID pemindaian, waktu pemindaian)
    // disimpan untuk diteruskan ke modul diagnosis penyakit AI on-device nantinya.
    final newScan = ScanHistoryModel(
      id: scanId,
      plantId: plant.id,
      plantName: plant.name,
      imagePath: widget.imagePath,
      timestamp: timestamp,
      inputSource: widget.inputSource,
      diseaseDetected: 'Early Blight',
      confidence: 94.2,
      severity: 'Sedang',
      notes: _notesController.text.trim(),
      isValidated: true,
      createdAt: DateTime.now(),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      plantProvider.addScan(newScan);

      AppToast.showSuccess(
        context,
        title: 'Data pemindaian berhasil disimpan!',
        subtitle: 'Terhubung ke ${plant.name} • Siap untuk evaluasi AI',
      );

      // Kembalikan scanId ke Kamera atau langsung buka Detail Riwayat
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(scanId);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ScanDetailScreen(scanId: scanId),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final plants = plantProvider.allPlants;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Header
          CurvedHeader(
            title: 'Pratinjau Foto Daun',
            showBackButton: true,
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Card with Quality Badge
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
                          child: widget.isFile
                              ? Image.file(
                                  File(widget.imagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'assets/images/disease_late_blight.webp',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  widget.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primaryGreenDark),
                                ),
                        ),

                        // Quality Badge Overlay (Bottom Center)
                        Positioned(
                          bottom: 14,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B4D24).withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                border: Border.all(color: AppColors.cameraGuideGreen, width: 1.2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: AppColors.cameraGuideGreen, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Kualitas Foto Memenuhi Syarat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.p20),

                  // Hubungkan ke Tanaman Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Hubungkan ke Tanaman',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: AppColors.tomatoRed, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          border: Border.all(color: AppColors.border, width: 1.2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedPlantId,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGreen),
                            items: plants.map((p) {
                              return DropdownMenuItem<String>(
                                value: p.id,
                                child: Text(
                                  '${p.name} (${p.location})',
                                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPlantId = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p16),

                  // Catatan Kondisi Daun
                  AppTextField(
                    label: 'Catatan Kondisi Daun',
                    hintText: 'Bercak coklat kecokelatan di helai daun bawah ke-3...',
                    controller: _notesController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSizes.p28),

                  // Action Buttons: Foto Ulang (Left) vs Lanjut Diagnosis AI (Right)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                              ),
                              backgroundColor: AppColors.surface,
                            ),
                            child: const Text(
                              'Foto Ulang',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      Expanded(
                        flex: 3,
                        child: AppButton(
                          label: 'Simpan Riwayat Scan',
                          isLoading: _isProcessing,
                          suffixIcon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          onPressed: _handleSaveAndProceed,
                        ),
                      ),
                    ],
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
