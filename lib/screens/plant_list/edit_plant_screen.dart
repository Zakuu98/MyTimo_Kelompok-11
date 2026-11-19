import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';

/// Halaman Edit Tanaman sesuai Desain Figma Frame: Edit_Tanaman
/// Menyediakan formulir pembaruan data tanaman yang dipilih dari daftar tanaman,
/// dengan validasi kolom bertanda bintang (*), navigasi kembali, dan dialog sukses.
class EditPlantScreen extends StatefulWidget {
  final PlantModel plant;

  const EditPlantScreen({
    super.key,
    required this.plant,
  });

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

  DateTime? _selectedDate;
  bool _submittedOnce = false;

  final List<String> _monthsIndo = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _varietyController = TextEditingController(text: widget.plant.variety);
    _dateController = TextEditingController(
      text: widget.plant.plantingDate ?? '05 Agustus 2026',
    );
    _locationController = TextEditingController(text: widget.plant.location);
    _notesController = TextEditingController(
      text: widget.plant.notes ?? 'Daun bawah mulai membaik pasca pemangkasan.',
    );
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

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF178401),
              onPrimary: Colors.white,
              onSurface: Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            '${picked.day < 10 ? '0${picked.day}' : '${picked.day}'} ${_monthsIndo[picked.month - 1]} ${picked.year}';
      });
    }
  }

  void _submit() {
    setState(() {
      _submittedOnce = true;
    });

    final name = _nameController.text.trim();
    final date = _dateController.text.trim();
    final location = _locationController.text.trim();

    // Validasi: Kolom bertanda bintang (*) wajib diisi
    final bool isNameEmpty = name.isEmpty;
    final bool isDateEmpty = date.isEmpty;
    final bool isLocationEmpty = location.isEmpty;

    if (isNameEmpty || isDateEmpty || isLocationEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Semua kolom bertanda bintang (*) wajib diisi!',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Hitung HST jika tanggal diperbarui
    int updatedHst = widget.plant.hst;
    if (_selectedDate != null) {
      final diff = DateTime.now().difference(_selectedDate!).inDays;
      updatedHst = diff >= 0 ? (diff == 0 ? 1 : diff) : widget.plant.hst;
    }

    final updatedPlant = widget.plant.copyWith(
      name: name,
      variety: _varietyController.text.trim().isNotEmpty
          ? _varietyController.text.trim()
          : widget.plant.variety,
      hst: updatedHst,
      location: location,
      plantingDate: date,
      notes: _notesController.text.trim(),
    );

    // Perbarui data di PlantProvider
    Provider.of<PlantProvider>(context, listen: false).updatePlant(updatedPlant);

    // Kembali ke Daftar Tanaman dengan nilai `true`
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.addPlantBackground,
      body: Column(
        children: [
          // 1. Header Gradient sesuai CSS Figma Frame: Edit_Tanaman
          _buildHeader(topInset),

          // 2. Formulir Edit Data Tanaman
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: Nama Tanaman / Blok * (Wajib)
                    _buildFieldLabel('Nama Tanaman / Blok *'),
                    const SizedBox(height: 6),
                    _buildTextInputContainer(
                      controller: _nameController,
                      hint: 'Masukkan nama tanaman / blok',
                      iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                      fallbackIcon: Icons.eco_outlined,
                      hasError:
                          _submittedOnce && _nameController.text.trim().isEmpty,
                    ),
                    const SizedBox(height: 16),

                    // Field 2: Varietas (Sesuai Figma Edit_Tanaman)
                    _buildFieldLabel('Varietas'),
                    const SizedBox(height: 6),
                    _buildTextInputContainer(
                      controller: _varietyController,
                      hint: 'Masukkan varietas (opsional)',
                      iconAsset: 'assets/custom_assets/icons/ic_leaf.png',
                      fallbackIcon: Icons.grass_rounded,
                      hasError: false,
                    ),
                    const SizedBox(height: 16),

                    // Field 3: Tanggal Tanam * (Wajib)
                    _buildFieldLabel('Tanggal Tanam *'),
                    const SizedBox(height: 6),
                    _buildTextInputContainer(
                      controller: _dateController,
                      hint: 'Pilih tanggal tanam',
                      iconAsset: 'assets/custom_assets/icons/ic_calendar.png',
                      fallbackIcon: Icons.calendar_today_outlined,
                      readOnly: false,
                      onTap: () => _pickDate(context),
                      hasError:
                          _submittedOnce && _dateController.text.trim().isEmpty,
                    ),
                    const SizedBox(height: 16),

                    // Field 4: Lokasi / Keterangan * (Wajib)
                    _buildFieldLabel('Lokasi / Keterangan *'),
                    const SizedBox(height: 6),
                    _buildTextInputContainer(
                      controller: _locationController,
                      hint: 'Masukkan lokasi / keterangan',
                      iconAsset: 'assets/custom_assets/icons/ic_pin_outline.png',
                      fallbackIcon: Icons.location_on_outlined,
                      hasError: _submittedOnce &&
                          _locationController.text.trim().isEmpty,
                    ),
                    const SizedBox(height: 16),

                    // Field 5: Catatan Pemulihan (Sesuai Figma Edit_Tanaman)
                    _buildFieldLabel('Catatan Pemulihan'),
                    const SizedBox(height: 6),
                    _buildNotesInputContainer(
                      controller: _notesController,
                      hint: 'Tulis catatan pemulihan tanaman...',
                    ),
                    const SizedBox(height: 24),

                    // Tombol: "Btn Perbarui Data Tanaman"
                    _buildSaveButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(bottomInset),
    );
  }

  /// Header Gradient hijau sesuai CSS Figma Frame: Edit_Tanaman
  Widget _buildHeader(double topInset) {
    return Container(
      height: topInset + 64,
      decoration: const BoxDecoration(
        gradient: AppColors.addPlantHeaderGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x24002600), // rgba(0, 38, 0, 0.14)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: topInset + 10,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tombol Kembali (icon/back)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Judul Layar: "Edit Tanaman"
          const Expanded(
            child: Text(
              'Edit Tanaman',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Label Formulir sesuai CSS Figma (Inter 700 13px #000000)
  Widget _buildFieldLabel(String label) {
    final isRequired = label.contains('*');
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isRequired ? Colors.black : const Color(0xFF1F2937),
      ),
    );
  }

  /// Kontainer Input Standar (Tinggi 50px, border #DF4B2C, radius 18px)
  Widget _buildTextInputContainer({
    required TextEditingController controller,
    required String hint,
    required String iconAsset,
    required IconData fallbackIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    required bool hasError,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasError ? const Color(0xFFDC2626) : AppColors.addPlantInputBorder,
          width: hasError ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Ikon pendukung input
          GestureDetector(
            onTap: onTap,
            child: Image.asset(
              iconAsset,
              width: 18,
              height: 18,
              color: const Color(0xFF8E8E8E),
              errorBuilder: (context, error, stackTrace) => Icon(
                fallbackIcon,
                size: 18,
                color: const Color(0xFF8E8E8E),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Text Field
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kontainer Input Catatan Pemulihan (Tinggi 95px, multiline)
  Widget _buildNotesInputContainer({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.addPlantInputBorder,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          height: 1.45,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9CA3AF),
            height: 1.45,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  /// Tombol "Perbarui Data Tanaman" sesuai CSS Figma Edit_Tanaman
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: AppColors.addPlantButtonGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38002600), // rgba(0, 38, 0, 0.22)
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _submit,
          child: const Center(
            child: Text(
              'Perbarui Data Tanaman',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Bar identik dengan Figma Frame: Edit_Tanaman
  Widget _buildBottomNavBar(double bottomInset) {
    return SizedBox(
      height: 78 + (bottomInset > 0 ? bottomInset - 8 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar
          Container(
            height: 64 + bottomInset,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A002600), // rgba(0, 38, 0, 0.10)
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Row(
              children: [
                // Tab 0: Beranda
                Expanded(
                  child: _buildNavTab(
                    label: 'Beranda',
                    iconAsset: 'assets/custom_assets/icons/ic_home.png',
                    fallbackIcon: Icons.home_rounded,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                // Tab 1: Tanaman (Aktif)
                Expanded(
                  child: _buildNavTab(
                    label: 'Tanaman',
                    iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                    fallbackIcon: Icons.eco_outlined,
                    isActive: true,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),

                // Spacer untuk center FAB
                const SizedBox(width: 72),

                // Tab 3: Riwayat
                Expanded(
                  child: _buildNavTab(
                    label: 'Riwayat',
                    iconAsset: 'assets/custom_assets/icons/ic_clock.png',
                    fallbackIcon: Icons.history_rounded,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(3);
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                // Tab 4: Monitor
                Expanded(
                  child: _buildNavTab(
                    label: 'Monitor',
                    iconAsset: 'assets/custom_assets/icons/ic_activity.png',
                    fallbackIcon: Icons.show_chart_rounded,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(4);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Center Elevated FAB (Pindai)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF002600).withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.homeFabGradient,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.crop_free_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Pindai',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD91C1C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab({
    required String label,
    required String iconAsset,
    required IconData fallbackIcon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color =
        isActive ? const Color(0xFF178401) : const Color(0xFF8E8E8E);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconAsset,
            width: 20,
            height: 20,
            color: color,
            errorBuilder: (context, error, stackTrace) => Icon(
              fallbackIcon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
