import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mytimo_bottom_nav.dart';

/// Screen 24: Buat Rencana Rawat
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class AddTreatmentScreen extends StatefulWidget {
  final String? initialDiseaseName;
  final double? initialConfidence;

  const AddTreatmentScreen({
    super.key,
    this.initialDiseaseName,
    this.initialConfidence,
  });

  @override
  State<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String _selectedPlant = 'Tomat Cherry Blok A';
  String _selectedDiagnosis = 'Early Blight (94.2%) • 06 Okt 2026';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 14));
  final Set<int> _selectedSteps = {0, 1}; // default 2 step terpilih
  bool _isSaving = false;

  final List<String> _plantOptions = [
    'Tomat Cherry Blok A',
    'Tomat Servo Bedeng 1',
    'Tomat Mawar Bedeng 4',
    'Tomat Sayur Blok C',
  ];

  final List<String> _diagnosisOptions = [
    'Early Blight (94.2%) • 06 Okt 2026',
    'Late Blight (88.5%) • 05 Okt 2026',
    'Leaf Mold (76.1%) • 04 Okt 2026',
    'Tambahkan manual',
  ];

  final List<String> _availableSteps = [
    'Pangkas daun berpenyakit & bakar',
    'Semprot fungisida tembaga 2g/L (Pagi)',
    'Atur irigasi & bersihkan mulsa',
    'Monitor 3 hari sekali',
    'Periksa perkembangan penyakit',
    'Semprot pestisida organik',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialDiseaseName != null) {
      _selectedDiagnosis = '${widget.initialDiseaseName} (${widget.initialConfidence?.toStringAsFixed(1) ?? '0.0'}%)';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
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
          'Buat Rencana Rawat',
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
              // Tanaman Terkait
              _buildLabel('Tanaman Terkait *'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedPlant,
                items: _plantOptions,
                prefixIcon: Icons.grass_rounded,
                onChanged: (val) => setState(() => _selectedPlant = val!),
              ),
              const SizedBox(height: 16),

              // Dasar Diagnosis
              _buildLabel('Dasar Diagnosis *'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedDiagnosis,
                items: _diagnosisOptions,
                prefixIcon: Icons.document_scanner_outlined,
                onChanged: (val) => setState(() => _selectedDiagnosis = val!),
              ),
              const SizedBox(height: 16),

              // Judul Tindakan
              _buildLabel('Judul Tindakan *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                decoration: InputDecoration(
                  hintText: 'Contoh: Pemulihan Early Blight Daun Bawah',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  prefixIcon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Pilih Langkah Tindakan
              _buildLabel('Pilih Langkah Tindakan (* Min 1)'),
              const SizedBox(height: 8),
              ..._availableSteps.asMap().entries.map((e) {
                final isSelected = _selectedSteps.contains(e.key);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedSteps.remove(e.key);
                    } else {
                      _selectedSteps.add(e.key);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreenSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e.value,
                            style: TextStyle(
                              color: isSelected ? AppColors.primaryGreenText : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Target Tanggal Selesai
              _buildLabel('Target Tanggal Selesai *'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
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
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_rounded,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Simpan
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
                      : const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Simpan Rencana Penanganan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyTimoBottomNav(activeIndex: 2),
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData prefixIcon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  void _savePlan() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSteps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 langkah tindakan'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul tindakan wajib diisi'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<TreatmentProvider>();
    final planId = provider.generateId();

    final selectedStepList = _selectedSteps.map((i) => _availableSteps[i]).toList();

    final newPlan = TreatmentPlan(
      id: planId,
      plantName: _selectedPlant,
      diseaseName: _selectedDiagnosis,
      createdAt: DateTime.now(),
      targetDate: _targetDate,
      status: TreatmentStatus.sedangBerjalan,
      priority: TreatmentPriority.sedang,
      notes: '',
      steps: selectedStepList.asMap().entries.map((e) {
        return TreatmentStep(
          id: '$planId-step-${e.key}',
          description: e.value,
        );
      }).toList(),
    );

    provider.createPlan(newPlan);
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Rencana penanganan berhasil dibuat!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
    Navigator.pop(context);
  }
}
