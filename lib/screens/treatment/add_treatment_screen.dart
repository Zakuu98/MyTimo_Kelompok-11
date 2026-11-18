import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../providers/treatment_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Screen 24: Form Tambah Rencana Penanganan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class AddTreatmentScreen extends StatefulWidget {
  final String? initialDiseaseName;

  const AddTreatmentScreen({super.key, this.initialDiseaseName});

  @override
  State<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diseaseController = TextEditingController();
  final _notesController = TextEditingController();
  final _stepController = TextEditingController();

  String _selectedPlant = 'Tomat Cherry Blok A';
  TreatmentPriority _selectedPriority = TreatmentPriority.sedang;
  DateTime _targetDate = DateTime.now().add(const Duration(days: 14));
  final List<String> _steps = [];

  final List<String> _plantOptions = [
    'Tomat Cherry Blok A',
    'Tomat Servo Bedeng 1',
    'Tomat Mawar Bedeng 4',
    'Tomat Sayur Blok C',
  ];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDiseaseName != null) {
      _diseaseController.text = widget.initialDiseaseName!;
    }
    // Default steps from recommendation
    if (widget.initialDiseaseName != null) {
      _steps.addAll([
        'Pangkas dan buang daun yang terinfeksi',
        'Semprot fungisida berbahan aktif klorotalonil setiap 7 hari',
        'Hindari penyiraman dari atas (gunakan drip)',
        'Monitor perkembangan penyakit setiap 3 hari',
      ]);
    }
  }

  @override
  void dispose() {
    _diseaseController.dispose();
    _notesController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        title: const Text(
          'Buat Rencana Penanganan',
          style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Informasi Tanaman & Penyakit', [
                _buildDropdownField(
                  label: 'Nama Tanaman *',
                  value: _selectedPlant,
                  items: _plantOptions,
                  onChanged: (val) => setState(() => _selectedPlant = val!),
                ),
                const SizedBox(height: AppSizes.p16),
                AppTextField(
                  label: 'Nama Penyakit *',
                  hintText: 'Contoh: Bercak Kering (Early Blight)',
                  controller: _diseaseController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama penyakit wajib diisi' : null,
                ),
              ]),
              const SizedBox(height: AppSizes.p16),
              _buildSection('Rencana & Prioritas', [
                _buildDatePicker(),
                const SizedBox(height: AppSizes.p16),
                _buildPrioritySelector(),
              ]),
              const SizedBox(height: AppSizes.p16),
              _buildSection('Langkah Tindakan *', [
                _buildStepsList(),
                const SizedBox(height: AppSizes.p12),
                _buildAddStepField(),
              ]),
              const SizedBox(height: AppSizes.p16),
              _buildSection('Catatan Tambahan', [
                AppTextField(
                  label: 'Catatan (opsional)',
                  hintText: 'Tambahkan catatan khusus tentang kondisi tanaman...',
                  controller: _notesController,
                  maxLines: 3,
                ),
              ]),
              const SizedBox(height: AppSizes.p28),
              AppButton(
                label: 'Simpan Rencana',
                isLoading: _isSaving,
                onPressed: _savePlan,
              ),
              const SizedBox(height: AppSizes.p24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.p12),
        Container(
          padding: const EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSizes.roundedXL,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            boxShadow: AppSizes.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.formLabel),
        const SizedBox(height: AppSizes.p8),
        DropdownButtonFormField<String>(initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: AppSizes.roundedM,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSizes.roundedM,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSizes.roundedM,
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16, vertical: AppSizes.p12),
            filled: true,
            fillColor: AppColors.background,
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final formatted =
        '${_targetDate.day} ${months[_targetDate.month]} ${_targetDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Tanggal Selesai *', style: AppTextStyles.formLabel),
        const SizedBox(height: AppSizes.p8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16, vertical: AppSizes.p14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppSizes.roundedM,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 18, color: AppColors.primaryGreen),
                const SizedBox(width: AppSizes.p10),
                Text(formatted, style: AppTextStyles.formInput),
                const Spacer(),
                const Icon(Icons.arrow_drop_down_rounded,
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prioritas *', style: AppTextStyles.formLabel),
        const SizedBox(height: AppSizes.p8),
        Row(
          children: TreatmentPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            final color = _getPriorityColor(priority);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppSizes.p6),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPriority = priority),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.p10),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.background,
                      borderRadius: AppSizes.roundedM,
                      border: Border.all(
                          color: isSelected ? color : AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      priority.label,
                      style: AppTextStyles.badgeText.copyWith(
                        color: isSelected ? AppColors.textWhite : color,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepsList() {
    if (_steps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppSizes.roundedM,
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: const Center(
          child: Text('Belum ada langkah. Tambahkan di bawah.',
              style: AppTextStyles.bodyMuted),
        ),
      );
    }

    return Column(
      children: _steps.asMap().entries.map((entry) {
        final i = entry.key;
        final step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.p8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: AppTextStyles.badgeText
                      .copyWith(color: AppColors.textWhite, fontSize: 11),
                ),
              ),
              const SizedBox(width: AppSizes.p10),
              Expanded(child: Text(step, style: AppTextStyles.body)),
              GestureDetector(
                onTap: () => setState(() => _steps.removeAt(i)),
                child: const Icon(Icons.close_rounded,
                    size: 18, color: AppColors.textMuted),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddStepField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _stepController,
            decoration: InputDecoration(
              hintText: 'Tambah langkah tindakan...',
              hintStyle: AppTextStyles.formHint,
              border: OutlineInputBorder(
                borderRadius: AppSizes.roundedM,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSizes.roundedM,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p12, vertical: AppSizes.p10),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.p8),
        ElevatedButton(
          onPressed: _addStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(borderRadius: AppSizes.roundedM),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p14, vertical: AppSizes.p12),
          ),
          child: const Icon(Icons.add_rounded, color: AppColors.textWhite),
        ),
      ],
    );
  }

  void _addStep() {
    final text = _stepController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _steps.add(text);
        _stepController.clear();
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  void _savePlan() {
    if (!_formKey.currentState!.validate()) return;
    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan minimal satu langkah tindakan'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<TreatmentProvider>();
    final planId = provider.generateId();

    final newPlan = TreatmentPlan(
      id: planId,
      plantName: _selectedPlant,
      diseaseName: _diseaseController.text.trim(),
      createdAt: DateTime.now(),
      targetDate: _targetDate,
      status: TreatmentStatus.belumDimulai,
      priority: _selectedPriority,
      notes: _notesController.text.trim(),
      steps: _steps.asMap().entries.map((e) {
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

  Color _getPriorityColor(TreatmentPriority priority) {
    switch (priority) {
      case TreatmentPriority.rendah:
        return AppColors.textSecondary;
      case TreatmentPriority.sedang:
        return AppColors.warningOrange;
      case TreatmentPriority.tinggi:
        return const Color(0xFFE65100);
      case TreatmentPriority.mendesak:
        return AppColors.tomatoRed;
    }
  }
}


