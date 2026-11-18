import 'package:flutter/material.dart';
import '../../../models/scan_history_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../widgets/app_button.dart';

/// Bottom Sheet Ubah Catatan Riwayat sesuai Screenshot Desain 16_edit_cata
class EditScanNotesBottomSheet extends StatefulWidget {
  final ScanHistoryModel scan;
  final ValueChanged<String> onSaved;

  const EditScanNotesBottomSheet({
    super.key,
    required this.scan,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required ScanHistoryModel scan,
    required ValueChanged<String> onSaved,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditScanNotesBottomSheet(
        scan: scan,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<EditScanNotesBottomSheet> createState() => _EditScanNotesBottomSheetState();
}

class _EditScanNotesBottomSheetState extends State<EditScanNotesBottomSheet> {
  late final TextEditingController _controller;
  final int _maxChars = 500;

  final List<String> _quickTags = [
    '+ Perkembangan Daun',
    '+ Kompos Fungisida',
    '+ Evaluasi 3 Hari',
    '+ Karantina',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.scan.notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addQuickTag(String tag) {
    final cleanTag = tag.replaceFirst('+ ', '');
    final current = _controller.text.trim();
    if (current.isEmpty) {
      _controller.text = '$cleanTag: ';
    } else {
      _controller.text = '$current • $cleanTag';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radius2XL)),
      ),
      padding: EdgeInsets.only(
        left: AppSizes.p20,
        right: AppSizes.p20,
        top: AppSizes.p16,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.p20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Sheet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note_rounded, color: AppColors.primaryGreen, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Ubah Catatan Riwayat',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p12),

              // Mini Card Preview
              Container(
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
                      child: Image.asset(
                        widget.scan.imagePath,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: AppSizes.p10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.scan.diseaseDetected} (${widget.scan.formattedConfidence})',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.scan.plantName} • ${widget.scan.timestamp}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p16),

              // Text Area Catatan
              Container(
                padding: const EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.5),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      maxLength: _maxChars,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tuliskan catatan penanganan atau perkembangan kondisi daun...',
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_controller.text.length} / $_maxChars Karakter',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p14),

              // Quick Action Tags
              const Text(
                'Sisipkan Catatan Lapangan Cepat:',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _quickTags.map((tag) {
                  return GestureDetector(
                    onTap: () => _addQuickTag(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreenSurface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(color: const Color(0xFFC8E6C9)),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreenText,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.p20),

              // Save Action Button
              AppButton(
                label: 'Simpan Perubahan Catatan',
                prefixIcon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                onPressed: () {
                  widget.onSaved(_controller.text.trim());
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: AppSizes.p10),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batalkan & Kembali ke Detail',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
