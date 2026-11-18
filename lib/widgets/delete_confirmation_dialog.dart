import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

/// Modal Konfirmasi Hapus sesuai Desain 11_plant_det & 16_Hapus_Ri
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? previewContent;
  final String warningText;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.previewContent,
    required this.warningText,
    this.confirmLabel = 'Ya, Hapus',
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? previewContent,
    required String warningText,
    String confirmLabel = 'Ya, Hapus',
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeleteConfirmationDialog(
        title: title,
        subtitle: subtitle,
        previewContent: previewContent,
        warningText: warningText,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radius2XL)),
      ),
      padding: EdgeInsets.only(
        left: AppSizes.p24,
        right: AppSizes.p24,
        top: AppSizes.p16,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.p24,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.p20),

            // Warning Icon
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFE0B2), width: 2),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE65100),
                size: 32,
              ),
            ),
            const SizedBox(height: AppSizes.p16),

            // Title & Subtitle
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.p16),

            // Preview Chip / Card (if any)
            if (previewContent != null) ...[
              previewContent!,
              const SizedBox(height: AppSizes.p14),
            ],

            // Warning banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.tomatoRed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warningText,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFFC62828),
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p20),

            // Action Buttons (Batal vs Ya, Hapus)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        backgroundColor: const Color(0xFFF8FAFC),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tomatoRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                      ),
                      child: Text(
                        confirmLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
