import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/plant_model.dart';
import '../../../providers/plant_provider.dart';

/// Modal Bottom Sheet untuk menambahkan Tanaman Tomat Baru
class AddPlantModal extends StatefulWidget {
  const AddPlantModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddPlantModal(),
    );
  }

  @override
  State<AddPlantModal> createState() => _AddPlantModalState();
}

class _AddPlantModalState extends State<AddPlantModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _hstController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedStatus = 'Sehat';
  String _selectedBadge = 'Sehat';

  final List<String> _statusOptions = ['Sehat', 'Perlu Rawat', 'Parah'];
  final Map<String, List<String>> _badgeOptionsMap = {
    'Sehat': ['Sehat'],
    'Perlu Rawat': ['Early Blight', 'Bercak Daun', 'Kekurangan Nutrisi'],
    'Parah': ['Late Blight', 'Septoria', 'Layu Bakteri'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _hstController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onStatusChanged(String status) {
    setState(() {
      _selectedStatus = status;
      final options = _badgeOptionsMap[status] ?? ['Sehat'];
      _selectedBadge = options.first;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final hstValue = int.tryParse(_hstController.text.trim()) ?? 1;
    final isHealthy = _selectedStatus.toLowerCase() == 'sehat';

    final newPlant = PlantModel(
      id: 'plt_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      variety: _varietyController.text.trim().isNotEmpty
          ? _varietyController.text.trim()
          : 'Servo F1',
      hst: hstValue,
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : 'Greenhouse 1',
      status: _selectedStatus,
      badgeText: _selectedBadge,
      imagePath: isHealthy
          ? 'assets/images/hero_tomatoes.webp'
          : 'assets/custom_assets/images/jamur_septoria.png',
    );

    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);

    Navigator.pop(context);

    plantProvider.addPlant(newPlant);

    messenger.showSnackBar(
      SnackBar(
        content: Text('Tanaman "${newPlant.name}" berhasil ditambahkan!'),
        backgroundColor: const Color(0xFF178401),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final availableBadges = _badgeOptionsMap[_selectedStatus] ?? ['Sehat'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: bottomInset + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 14),

              // Judul Modal
              const Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color(0xFF2C961B),
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tambah Tanaman Baru',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. Nama Tanaman
              _buildFieldLabel('Nama / Kode Tanaman'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration(
                  hint: 'Contoh: Tomat Cherry Blok B',
                  icon: Icons.eco_outlined,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama tanaman wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. Varietas & HST (2 kolom)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Varietas Tomat'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _varietyController,
                          decoration: _buildInputDecoration(
                            hint: 'Servo F1 / Cherry',
                            icon: Icons.grass_rounded,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Usia (HST)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _hstController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            hint: 'Contoh: 30',
                            icon: Icons.calendar_today_outlined,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Wajib diisi';
                            }
                            if (int.tryParse(val.trim()) == null) {
                              return 'Harus angka';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 3. Lokasi Bedeng
              _buildFieldLabel('Lokasi Bedeng / Greenhouse'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: _buildInputDecoration(
                  hint: 'Contoh: Greenhouse 1 • Rak B4',
                  icon: Icons.location_on_outlined,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lokasi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 4. Status Tanaman
              _buildFieldLabel('Status Kesehatan'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _statusOptions.map((st) {
                  final isSelected = _selectedStatus == st;
                  return ChoiceChip(
                    label: Text(st),
                    selected: isSelected,
                    selectedColor: const Color(0xFFC5F3C1),
                    backgroundColor: const Color(0xFFF3EDED),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF106804)
                          : const Color(0xFF4B5563),
                    ),
                    onSelected: (_) => _onStatusChanged(st),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // 5. Diagnosa Badge
              _buildFieldLabel('Label Diagnosa / Catatan'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: availableBadges.map((badge) {
                  final isSelected = _selectedBadge == badge;
                  return ChoiceChip(
                    label: Text(badge),
                    selected: isSelected,
                    selectedColor: const Color(0xFFEFDF64),
                    backgroundColor: const Color(0xFFF3EDED),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFFBA6900)
                          : const Color(0xFF4B5563),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedBadge = badge;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF178401),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Simpan Tanaman',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: Color(0xFF9CA3AF),
      ),
      prefixIcon: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF178401), width: 1.5),
      ),
    );
  }
}
