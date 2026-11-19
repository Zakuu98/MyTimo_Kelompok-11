import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/mytimo_bottom_nav.dart';

/// Screen 26: Ubah Rencana Rawat
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class EditTreatmentScreen extends StatefulWidget {
  final TreatmentPlan plan;

  const EditTreatmentScreen({super.key, required this.plan});

  @override
  State<EditTreatmentScreen> createState() => _EditTreatmentScreenState();
}

class _EditTreatmentScreenState extends State<EditTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late DateTime _targetDate;
  late TreatmentStatus _selectedStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.plan.diseaseName);
    _notesController = TextEditingController(text: widget.plan.notes);
    _targetDate = widget.plan.targetDate;
    _selectedStatus = widget.plan.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        title: const Text(
          'Ubah Rencana Rawat',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Rencana
              _buildLabel('Judul Rencana *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                decoration: InputDecoration(
                  hintText: 'Judul rencana penanganan',
                  prefixIcon: const Icon(Icons.edit_outlined,
                      color: AppColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primaryGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Target Selesai
              _buildLabel('Target Selesai *'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.5),
                        width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 18, color: AppColors.primaryGreen),
                      const SizedBox(width: 10),
                      Text(
                        _formatDate(_targetDate),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_rounded,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Rencana
              _buildLabel('Status Rencana *'),
              const SizedBox(height: 8),
              DropdownButtonFormField<TreatmentStatus>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.flag_outlined,
                      color: AppColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primaryGreen, width: 2),
                  ),
                ),
                items: TreatmentStatus.values
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),
              const SizedBox(height: 16),

              // Catatan Pelaksanaan
              _buildLabel('Catatan Pelaksanaan'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Tambahkan catatan pelaksanaan rencana penanganan...',
                  hintStyle: const TextStyle(
                      color: AppColors.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primaryGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Perbarui (Hijau)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _savePlan,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Perbarui Rencana Penanganan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Hapus (Merah) sesuai Figma
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.tomatoRed, size: 20),
                  label: const Text(
                    'Hapus Rencana Ini',
                    style: TextStyle(
                      color: AppColors.tomatoRed,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                        color: AppColors.tomatoRed.withOpacity(0.5), width: 1.5),
                    backgroundColor: AppColors.tomatoRedLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyTimoBottomNav(activeIndex: 1),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  void _savePlan() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<TreatmentProvider>();
    final updated = widget.plan.copyWith(
      diseaseName: _titleController.text.trim(),
      targetDate: _targetDate,
      status: _selectedStatus,
      notes: _notesController.text.trim(),
    );
    provider.updatePlan(updated);

    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Rencana berhasil diperbarui!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
    Navigator.pop(context);
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Rencana?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Rencana penanganan ini akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<TreatmentProvider>();
              provider.deletePlan(widget.plan.id);
              Navigator.pop(context); // dialog
              Navigator.pop(context); // edit screen
              Navigator.pop(context); // progress screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rencana berhasil dihapus'),
                  backgroundColor: AppColors.tomatoRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomatoRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
