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

/// Ubah Data Tanaman Screen sesuai Screenshot Desain 10_Ubah_Ta
class EditPlantScreen extends StatefulWidget {
  final PlantModel plant;

  const EditPlantScreen({super.key, required this.plant});

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _varietyController;
  late final TextEditingController _dateController;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _varietyController = TextEditingController(text: widget.plant.variety);
    _dateController = TextEditingController(text: widget.plant.plantingDate);
    _locationController = TextEditingController(text: widget.plant.location);
    _notesController = TextEditingController(text: widget.plant.initialNotes);
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      setState(() {
        _dateController.text = '${picked.day.toString().padLeft(2, '0')} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  void _handleUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.plant.copyWith(
      name: _nameController.text.trim(),
      variety: _varietyController.text.trim(),
      plantingDate: _dateController.text.trim(),
      location: _locationController.text.trim(),
      initialNotes: _notesController.text.trim(),
    );

    context.read<PlantProvider>().updatePlant(updated);

    AppToast.showSuccess(
      context,
      title: 'Data tanaman berhasil diperbarui!',
      subtitle: '${updated.name} tersimpan lokal.',
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Header
          CurvedHeader(
            title: 'Ubah Tanaman',
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
                    // Nama Tanaman / Blok
                    AppTextField(
                      label: 'Nama Tanaman / Blok',
                      hintText: 'Nama tanaman',
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
                      hintText: 'Varietas',
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
                      hintText: 'Lokasi lahan / bedeng',
                      controller: _locationController,
                      prefixIcon: Icons.place_outlined,
                      isRequired: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Lokasi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Catatan Pemulihan / Riwayat
                    AppTextField(
                      label: 'Catatan Pemulihan',
                      hintText: 'Catatan kondisi atau penanganan...',
                      controller: _notesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSizes.p28),

                    // Submit Update Button
                    AppButton(
                      label: 'Perbarui Data Tanaman',
                      prefixIcon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      onPressed: _handleUpdate,
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
