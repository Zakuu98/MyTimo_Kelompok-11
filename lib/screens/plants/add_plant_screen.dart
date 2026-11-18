import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/curved_header.dart';

/// Tambah Tanaman Screen sesuai Screenshot Desain 09_Tambah_
class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _handleSubmit() {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = 'Nama tanaman dan lokasi wajib diisi sebagai identitas pemantauan.';
      });
      return;
    }

    final plantProvider = context.read<PlantProvider>();
    final newId = 'PLT-${(plantProvider.allPlants.length + 1).toString().padLeft(3, '0')}';

    final newPlant = PlantModel(
      id: newId,
      name: _nameController.text.trim(),
      variety: _varietyController.text.trim(),
      plantingDate: _dateController.text.trim(),
      location: _locationController.text.trim(),
      initialNotes: _notesController.text.trim(),
      status: 'Sehat',
      totalScans: 0,
      createdAt: DateTime.now(),
    );

    plantProvider.addPlant(newPlant);

    AppToast.showSuccess(
      context,
      title: 'Data tanaman berhasil disimpan!',
      subtitle: 'ID: #$newId • Disimpan ke SQLite lokal',
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Header
          CurvedHeader(
            title: 'Tambah Tanaman',
            showBackButton: true,
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_errorMessage != null) ...[
                      FormValidationBanner(
                        title: 'Validasi Data Tanaman',
                        message: _errorMessage!,
                      ),
                      const SizedBox(height: AppSizes.p16),
                    ],

                    // Nama Tanaman / Blok
                    AppTextField(
                      label: 'Nama Tanaman / Blok',
                      hintText: 'misal: Tomat Sayur Blok C',
                      controller: _nameController,
                      prefixIcon: Icons.grass_rounded,
                      isRequired: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Nama tanaman tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Varietas / Jenis
                    AppTextField(
                      label: 'Varietas / Jenis (Opsional)',
                      hintText: 'misal: Gusto F1 / Cherry Tropic',
                      controller: _varietyController,
                      prefixIcon: Icons.eco_outlined,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Tanggal Tanam
                    AppTextField(
                      label: 'Tanggal Tanam',
                      hintText: 'Pilih tanggal tanam',
                      controller: _dateController,
                      prefixIcon: Icons.calendar_today_rounded,
                      readOnly: true,
                      onTap: _pickDate,
                      isRequired: true,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Lokasi / Keterangan
                    AppTextField(
                      label: 'Lokasi / Keterangan',
                      hintText: 'misal: Lahan Timur - Bedeng 01',
                      controller: _locationController,
                      prefixIcon: Icons.place_outlined,
                      isRequired: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Lokasi penanaman tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Catatan Awal
                    AppTextField(
                      label: 'Catatan Awal',
                      hintText: 'Bibit semai 20 hari, media tanah-kompos organik.',
                      controller: _notesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Info Note SQLite
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Data akan tersimpan secara normal di database lokal SQLite.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.p24),

                    // Submit Button
                    AppButton(
                      label: 'Simpan Data Tanaman',
                      prefixIcon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      onPressed: _handleSubmit,
                    ),
                    const SizedBox(height: AppSizes.p20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
