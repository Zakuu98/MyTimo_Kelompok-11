import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import '../../theme/app_colors.dart';
import 'scan_history_screen.dart';

/// Halaman Ubah Catatan Riwayat sesuai Desain Figma Frame: edit_catatan_riwayat
/// Menampilkan:
/// - Header gradient hijau dengan tombol back & judul "Ubah Catatan Riwayat"
/// - Kolom 1: "Tanaman" (Disabled/Read-only, teks "Terkunci" dihilangkan sesuai permintaan user)
/// - Kolom 2: "Tanggal Pemeriksaan *" (Input / date picker dengan border coral #DF4B2C)
/// - Kolom 3: "Pemeriksaan terkait (opsional)" (Dropdown / picker riwayat scan)
/// - Kolom 4: "Lokasi / Keterangan *" (Input teks lokasi tanaman)
/// - Kolom 5: "Catatan Awal" (Multiline textarea)
/// - Tombol: "Simpan Data Tanaman" (Gradien hijau #389D33 -> #178401)
/// - Custom BottomNavBar dengan tab Riwayat aktif
class EditScanNoteScreen extends StatefulWidget {
  final ScanHistoryItem? item;
  final String? plantName;
  final String? initialDate;
  final String? initialRelatedInspection;
  final String? initialLocation;
  final String? initialNotes;

  const EditScanNoteScreen({
    super.key,
    this.item,
    this.plantName,
    this.initialDate,
    this.initialRelatedInspection,
    this.initialLocation,
    this.initialNotes,
  });

  @override
  State<EditScanNoteScreen> createState() => _EditScanNoteScreenState();
}

/// Alias typedef agar sesuai dengan penamaan Figma Frame
typedef EditCatatanRiwayatScreen = EditScanNoteScreen;

class _EditScanNoteScreenState extends State<EditScanNoteScreen> {
  late final String _plantName;
  late final TextEditingController _dateController;
  late final TextEditingController _relatedInspectionController;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;

  final _formKey = GlobalKey<FormState>();
  bool _submittedOnce = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;

    // Kolom 1: Nama Tanaman (Terkunci / Read-only)
    _plantName = widget.plantName ?? item?.plantName ?? 'Tomat Cherry Blok A';

    // Kolom 2: Tanggal Pemeriksaan *
    _dateController = TextEditingController(
      text: widget.initialDate ?? '11 November 2026',
    );

    // Kolom 3: Pemeriksaan terkait (opsional)
    _relatedInspectionController = TextEditingController(
      text: widget.initialRelatedInspection ?? '',
    );

    // Kolom 4: Lokasi / Keterangan *
    _locationController = TextEditingController(
      text: widget.initialLocation ?? 'Lahan Timur - Bedeng 02',
    );

    // Kolom 5: Catatan Awal
    _notesController = TextEditingController(
      text: widget.initialNotes ??
          'Bibit semai 25 hari, media tanah kompos organik.',
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _relatedInspectionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topInset = mediaQuery.padding.top;
    final bottomInset = mediaQuery.padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EDED),
      body: Column(
        children: [
          // 1. Header Gradient Hijau
          _buildHeader(topInset),

          // 2. Konten Formulir Scrollable (Bebas Overflow di Layar Kompak)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field 1: Tanaman (Disabled / Read-only, tulisan "Terkunci" dihilangkan)
                    _buildFieldLabel('Tanaman'),
                    const SizedBox(height: 8),
                    _buildDisabledPlantField(),
                    const SizedBox(height: 16),

                    // Field 2: Tanggal Pemeriksaan *
                    _buildFieldLabel('Tanggal Pemeriksaan *'),
                    const SizedBox(height: 8),
                    _buildDateField(),
                    const SizedBox(height: 16),

                    // Field 3: Pemeriksaan terkait (opsional)
                    _buildFieldLabel('Pemeriksaan terkait (opsional)'),
                    const SizedBox(height: 8),
                    _buildRelatedInspectionField(),
                    const SizedBox(height: 16),

                    // Field 4: Lokasi / Keterangan *
                    _buildFieldLabel('Lokasi / Keterangan *'),
                    const SizedBox(height: 8),
                    _buildLocationField(),
                    const SizedBox(height: 16),

                    // Field 5: Catatan Awal
                    _buildFieldLabel('Catatan Awal'),
                    const SizedBox(height: 8),
                    _buildNotesField(),
                    const SizedBox(height: 24),

                    // Tombol: Simpan Data Tanaman
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

  /// Header Gradient hijau sesuai CSS Figma Frame: edit_catatan_riwayat
  /// linear-gradient(180deg, #599151 0%, #2C961B 55%, #6FBD5F 100%)
  Widget _buildHeader(double topInset) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF599151),
            Color(0xFF2C961B),
            Color(0xFF6FBD5F),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
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
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 24, top: 12, bottom: 20),
          child: Row(
            children: [
              // Tombol Kembali
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 36,
                  height: 36,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Judul Halaman "Ubah Catatan Riwayat"
              const Expanded(
                child: Text(
                  'Ubah Catatan Riwayat',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Label Field Form
  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: Colors.black,
      ),
    );
  }

  /// Field 1: Kolom Nama Tanaman (Disabled/Read-only, TANPA tulisan Terkunci)
  Widget _buildDisabledPlantField() {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0x5E8E8E8E), // rgba(142, 142, 142, 0.37)
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Sprout / Tunas
          Image.asset(
            'assets/custom_assets/icons/ic_sprout.png',
            width: 18,
            height: 18,
            color: const Color(0xFF8E8E8E),
            errorBuilder: (_, _, _) => const Icon(
              Icons.eco_outlined,
              size: 18,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(width: 10),

          // Teks Nama Tanaman (Read-only, tidak dapat diubah)
          Expanded(
            child: Text(
              _plantName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          // Tulisan "Terkunci" telah dihilangkan sesuai permintaan user
        ],
      ),
    );
  }

  /// Field 2: Tanggal Pemeriksaan * (Box border #DF4B2C, icon kalender, chevron)
  Widget _buildDateField() {
    final hasError = _submittedOnce && _dateController.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: hasError ? const Color(0xFFDC2626) : const Color(0xFFDF4B2C),
                width: hasError ? 1.5 : 1.0,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D002600),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Kalender
                Image.asset(
                  'assets/custom_assets/icons/ic_calendar.png',
                  width: 18,
                  height: 18,
                  color: const Color(0xFF8E8E8E),
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
                const SizedBox(width: 10),

                // Teks Tanggal
                Expanded(
                  child: Text(
                    _dateController.text.isNotEmpty
                        ? _dateController.text
                        : 'Pilih tanggal pemeriksaan',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Icon Chevron Down
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Color(0xFF8E8E8E),
                ),
              ],
            ),
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 4),
            child: Text(
              'Tanggal pemeriksaan wajib diisi!',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
      ],
    );
  }

  /// Date Picker Handler
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF178401),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final months = [
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
      setState(() {
        _dateController.text =
            '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  /// Field 3: Pemeriksaan terkait (opsional)
  Widget _buildRelatedInspectionField() {
    return GestureDetector(
      onTap: _showRelatedInspectionPicker,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDF4B2C), width: 1.0),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D002600),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Kalender / Pemeriksaan
            Image.asset(
              'assets/custom_assets/icons/ic_calendar.png',
              width: 18,
              height: 18,
              color: const Color(0xFF8E8E8E),
              errorBuilder: (_, _, _) => const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF8E8E8E),
              ),
            ),
            const SizedBox(width: 10),

            // Teks Placeholder / Value
            Expanded(
              child: Text(
                _relatedInspectionController.text.isNotEmpty
                    ? _relatedInspectionController.text
                    : 'Pilih dari riwayat scan tanaman ini',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: _relatedInspectionController.text.isNotEmpty
                      ? Colors.black
                      : const Color(0x7A000000), // rgba(0, 0, 0, 0.48)
                ),
              ),
            ),

            // Icon Chevron Down
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Color(0xFF8E8E8E),
            ),
          ],
        ),
      ),
    );
  }

  /// BottomSheet opsi pemeriksaan terkait
  void _showRelatedInspectionPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final options = [
          'Scan 06 Okt 2026, 14:20 - Early Blight (94.2%)',
          'Scan 04 Okt 2026, 09:15 - Daun Sehat (98.0%)',
          'Scan 20 Sep 2026, 11:00 - Daun Sehat (99.1%)',
          'Tidak ada pemeriksaan terkait',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Pilih Pemeriksaan Terkait',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(),
                ...options.map(
                  (opt) => ListTile(
                    title: Text(
                      opt,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (opt == 'Tidak ada pemeriksaan terkait') {
                          _relatedInspectionController.text = '';
                        } else {
                          _relatedInspectionController.text = opt;
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Field 4: Lokasi / Keterangan *
  Widget _buildLocationField() {
    final hasError = _submittedOnce && _locationController.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: hasError ? const Color(0xFFDC2626) : const Color(0xFFDF4B2C),
              width: hasError ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D002600),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Pin Lokasi
              Image.asset(
                'assets/custom_assets/icons/ic_pin_outline.png',
                width: 18,
                height: 18,
                color: const Color(0xFF8E8E8E),
                errorBuilder: (_, _, _) => const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(width: 10),

              // Input Lokasi
              Expanded(
                child: TextField(
                  controller: _locationController,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Contoh: Lahan Timur - Bedeng 02',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF8E8E8E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 4),
            child: Text(
              'Lokasi / Keterangan tidak boleh kosong!',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
      ],
    );
  }

  /// Field 5: Catatan Awal (Multiline Textarea 342x95px)
  Widget _buildNotesField() {
    final hasError = _submittedOnce && _notesController.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 95,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: hasError ? const Color(0xFFDC2626) : const Color(0xFFDF4B2C),
              width: hasError ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D002600),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 4,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              height: 1.46,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Tulis catatan awal di sini...',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF8E8E8E),
              ),
            ),
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 4),
            child: Text(
              'Catatan awal tidak boleh kosong!',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
      ],
    );
  }

  /// Tombol: "Simpan Data Tanaman" (342x54px, Gradien Hijau #389D33 -> #178401)
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF389D33), Color(0xFF178401)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
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
          onTap: _onSave,
          child: const Center(
            child: Text(
              'Simpan Data Tanaman',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Aksi Simpan Catatan Riwayat
  void _onSave() {
    setState(() => _submittedOnce = true);

    if (_dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal pemeriksaan wajib diisi!'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi / Keterangan tidak boleh kosong!'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan awal tidak boleh kosong!'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data catatan riwayat berhasil disimpan!'),
        backgroundColor: Color(0xFF178401),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop({
      'plantName': _plantName,
      'date': _dateController.text.trim(),
      'relatedInspection': _relatedInspectionController.text.trim(),
      'location': _locationController.text.trim(),
      'notes': _notesController.text.trim(),
    });
  }

  /// Custom BottomNavigationBar sesuai CSS Figma Frame: edit_catatan_riwayat
  Widget _buildBottomNavBar(double bottomInset) {
    return SizedBox(
      height: 80 + (bottomInset > 0 ? bottomInset - 10 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar Putih
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),

                // Tab 1: Tanaman
                Expanded(
                  child: _buildNavTab(
                    label: 'Tanaman',
                    iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                    fallbackIcon: Icons.eco_outlined,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(1);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),

                // Spacer untuk center FAB (width 72)
                const SizedBox(width: 72),

                // Tab 3: Riwayat (Aktif hijau sesuai CSS #178401)
                Expanded(
                  child: _buildNavTab(
                    label: 'Riwayat',
                    iconAsset: 'assets/custom_assets/icons/ic_clock.png',
                    fallbackIcon: Icons.history_rounded,
                    isActive: true,
                    onTap: () => Navigator.of(context).maybePop(),
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
              onTap: () => Navigator.of(context).maybePop(),
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
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          gradient: AppColors.homeFabGradient,
                          shape: BoxShape.circle,
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
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Pindai',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
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
    final color = isActive ? const Color(0xFF178401) : const Color(0xFF8E8E8E);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconAsset,
            width: 22,
            height: 22,
            color: color,
            errorBuilder: (_, _, _) => Icon(
              fallbackIcon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
