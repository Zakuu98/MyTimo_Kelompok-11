import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_success_dialog.dart';
import '../../widgets/delete_plant_dialog.dart';
import '../scan/camera_scan_screen.dart';
import 'edit_plant_screen.dart';

/// Halaman Detail Tanaman sesuai Desain Figma Frame: plant_detail
/// Menampilkan foto hero tanaman, status kesehatan, ringkasan informasi (lokasi,
/// tanggal tanam, varietas, skor sehat), riwayat scan terakhir, tombol pindai,
/// dan opsi hapus riwayat scan.
class PlantDetailScreen extends StatefulWidget {
  final PlantModel plant;

  const PlantDetailScreen({
    super.key,
    required this.plant,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late PlantModel _currentPlant;
  int _selectedTabIndex = 0; // 0: Ringkasan, 1: Riwayat, 2: Rencana, 3: Monitor
  bool _isFavorite = false;
  final bool _hasScanHistory = true;

  final List<String> _tabs = const [
    'Ringkasan',
    'Riwayat',
    'Rencana',
    'Monitor',
  ];

  @override
  void initState() {
    super.initState();
    _currentPlant = widget.plant;
  }

  Future<void> _navigateToEditScreen() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditPlantScreen(plant: _currentPlant),
      ),
    );

    if (result == true && mounted) {
      // Ambil data terbaru dari provider jika ada
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      final updated = plantProvider.plants.firstWhere(
        (p) => p.id == _currentPlant.id,
        orElse: () => _currentPlant,
      );

      setState(() {
        _currentPlant = updated;
      });

      AppSuccessDialog.show(
        context: context,
        title: 'Data Tanaman Berhasil Diperbarui!',
        message: 'Perubahan pada "${_currentPlant.name}" berhasil disimpan.',
        buttonText: 'Lihat Daftar Tanaman',
        autoDismissDuration: null,
        onContinue: () {},
      );
    }
  }

  Future<void> _confirmDeleteScanHistory() async {
    final confirmed = await DeletePlantDialog.show(
      context: context,
      plantName: _currentPlant.name,
      title: 'Hapus Data Tanaman?',
      message: 'Apakah anda yakin ingin menghapus\ndata tanaman ini',
    );

    if (confirmed == true && mounted) {
      final plantName = _currentPlant.name;
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      plantProvider.deletePlant(_currentPlant.id);

      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data "$plantName" berhasil dihapus'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showScanModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Pindai Daun ${_currentPlant.name}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Arahkan kamera ke daun tomat yang terindikasi bergejala penyakit untuk identifikasi AI secara instan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraScanScreen(
                        plantName: _currentPlant.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                label: const Text(
                  'Buka Kamera',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF178401),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EDED),
      body: Stack(
        children: [
          // 1. Foto Hero Tanaman (Header)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/hero_tomatoes.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    _currentPlant.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF2C961B),
                      child: const Center(
                        child: Icon(
                          Icons.eco_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Overlay gradient atas sesuai CSS Figma:
                // linear-gradient(180deg, rgba(8, 48, 10, 0.65) 0%, rgba(8, 48, 10, 0) 100%)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xA608300A), // rgba(8, 48, 10, 0.65)
                        Color(0x0008300A), // transparent
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Tombol Navigasi Atas (Back, Edit, Favorit)
          Positioned(
            top: topInset + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Back (40x40 circle)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x40FFFFFF), // rgba(255, 255, 255, 0.25)
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0x8CFFFFFF), // rgba(255, 255, 255, 0.55)
                        width: 1.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // Tombol Aksi Kanan: Edit Tanaman & Favorit
                Row(
                  children: [
                    // Tombol Edit Tanaman
                    GestureDetector(
                      onTap: _navigateToEditScreen,
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color(0x40FFFFFF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0x8CFFFFFF),
                            width: 1.0,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Tombol Favorit (40x40 circle)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isFavorite
                                  ? 'Ditambahkan ke tanaman favorit'
                                  : 'Dihapus dari favorit',
                            ),
                            duration: const Duration(milliseconds: 1200),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0x40FFFFFF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0x8CFFFFFF),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _isFavorite
                                ? const Color(0xFFE53935)
                                : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Sheet Konten Detail Tanaman (Scrollable)
          Positioned.fill(
            top: 200,
            bottom: 74 + (bottomInset > 0 ? bottomInset - 8 : 0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF3EDED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 22,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Tanaman
                    Text(
                      _currentPlant.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Subtitle Varietas & Umur HST
                    Text(
                      '${_currentPlant.variety} • Umur ${_currentPlant.hst} HST',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7E7E7E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Badge (Diagnosis / Kesehatan)
                    _buildStatusBadge(),
                    const SizedBox(height: 16),

                    // Tabs (Ringkasan, Riwayat, Rencana, Monitor)
                    _buildTabsSwitcher(),
                    const SizedBox(height: 16),

                    // Konten Tab
                    if (_selectedTabIndex == 0) ...[
                      // 4 Info Cards Grid (2x2)
                      _buildInfoCardsGrid(),
                      const SizedBox(height: 20),

                      // Section Header: Scan Terakhir
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Scan Terakhir',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTabIndex = 1; // Ke tab Riwayat
                              });
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF287D38),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Kartu Scan Terakhir
                      _buildLastScanCard(),
                      const SizedBox(height: 18),

                      // CTA Button: Pindai Daun Tanaman Ini
                      _buildPrimaryScanButton(),
                      const SizedBox(height: 14),

                      // Action Button: Hapus Riwayat Scan Ini
                      if (_hasScanHistory) ...[
                        _buildDeleteScanHistoryButton(),
                      ],
                    ] else ...[
                      // Konten Placeholder untuk Tab Lainnya
                      _buildOtherTabPlaceholder(),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Navigation Bar identik Figma
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavBar(bottomInset),
          ),
        ],
      ),
    );
  }

  /// Badge Status Diagnosis Tanaman (misal: "Early Blight • Dalam Rawat")
  Widget _buildStatusBadge() {
    Color bgColor = const Color(0xFFEFDF64);
    Color textColor = const Color(0xFFBA6900);
    IconData icon = Icons.warning_amber_rounded;
    String statusText = '${_currentPlant.badgeText} • Dalam Rawat';

    if (_currentPlant.status.toLowerCase() == 'sehat' ||
        _currentPlant.badgeText.toLowerCase() == 'sehat') {
      bgColor = const Color(0xFFC5F3C1);
      textColor = const Color(0xFF106804);
      icon = Icons.check_circle_outline_rounded;
      statusText = 'Sehat • Kondisi Baik';
    } else if (_currentPlant.status.toLowerCase() == 'parah' ||
        _currentPlant.badgeText.toLowerCase() == 'late blight') {
      bgColor = const Color(0xFFFFB1B1);
      textColor = const Color(0xFFCC0000);
      icon = Icons.error_outline_rounded;
      statusText = '${_currentPlant.badgeText} • Perlu Tindakan';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              statusText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tab switcher capsule sesuai CSS Figma
  Widget _buildTabsSwitcher() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // rgba(0, 0, 0, 0.08)
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF389D33), Color(0xFF178401)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _tabs[index],
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : const Color(0xFF8E8E8E),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 4 Info Cards Grid (Lokasi, Ditanam, Varietas, Skor Sehat)
  Widget _buildInfoCardsGrid() {
    // Format tanggal singkat jika panjang (misal: '05 Agustus 2026' -> '05 Agu 2026')
    String formattedDate = _currentPlant.plantingDate ?? '05 Agu 2026';
    if (formattedDate.contains('Agustus')) {
      formattedDate = formattedDate.replaceAll('Agustus', 'Agu');
    }

    String healthScoreText = '88% • Membaik';
    if (_currentPlant.status.toLowerCase() == 'sehat') {
      healthScoreText = '96% • Prima';
    } else if (_currentPlant.status.toLowerCase() == 'parah') {
      healthScoreText = '42% • Menurun';
    }

    return Column(
      children: [
        // Baris 1: Lokasi & Ditanam
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                iconAsset: 'assets/custom_assets/icons/ic_pin_outline.png',
                fallbackIcon: Icons.location_on_outlined,
                label: 'Lokasi',
                value: _currentPlant.location,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                iconAsset: 'assets/custom_assets/icons/ic_calendar.png',
                fallbackIcon: Icons.calendar_today_outlined,
                label: 'Ditanam',
                value: formattedDate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Baris 2: Varietas & Skor Sehat
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                fallbackIcon: Icons.eco_outlined,
                label: 'Varietas',
                value: _currentPlant.variety,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                iconAsset: 'assets/custom_assets/icons/ic_activity.png',
                fallbackIcon: Icons.show_chart_rounded,
                label: 'Skor Sehat',
                value: healthScoreText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Komponen Kartu Info Tunggal (58px, shadow, circle icon gradien)
  Widget _buildInfoCard({
    required String iconAsset,
    required IconData fallbackIcon,
    required String label,
    required String value,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lingkaran Ikon bergradien hijau
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFE7FDDD), Color(0xFFC5F3C1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: 18,
                height: 18,
                color: const Color(0xFF178401),
                errorBuilder: (context, error, stackTrace) => Icon(
                  fallbackIcon,
                  size: 18,
                  color: const Color(0xFF178401),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Teks Label & Nilai
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu Riwayat Scan Terakhir (342x64)
  Widget _buildLastScanCard() {
    if (!_hasScanHistory) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Belum ada riwayat pemindaian tersimpan.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF8E8E8E),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Melihat detail scan terakhir ${_currentPlant.name}...',
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Foto Thumbnail Scan (44x44)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/custom_assets/images/jamur_septoria.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 44,
                      height: 44,
                      color: const Color(0xFFE8F5E9),
                      child: const Icon(
                        Icons.photo_outlined,
                        color: Color(0xFF178401),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info Waktu & Diagnosis
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '06 Okt 2026, 14:20',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Early Blight • 94.2% akurat',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ],
                  ),
                ),

                // Icon Chevron Right
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8E8E8E),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tombol Utama "Pindai Daun Tanaman Ini" sesuai CSS Figma
  Widget _buildPrimaryScanButton() {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF389D33), Color(0xFF178401)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D000000), // rgba(0, 0, 0, 0.3)
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          borderRadius: BorderRadius.circular(23),
          onTap: _showScanModal,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 19,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Pindai Daun Tanaman Ini',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tombol Sekunder "Hapus Riwayat Scan Ini" sesuai CSS Figma
  Widget _buildDeleteScanHistoryButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFFCA5A5),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          borderRadius: BorderRadius.circular(23),
          onTap: _confirmDeleteScanHistory,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFCC0000),
                  size: 18,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Hapus Riwayat Scan Ini',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCC0000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherTabPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            _selectedTabIndex == 1
                ? Icons.history_rounded
                : (_selectedTabIndex == 2
                    ? Icons.assignment_outlined
                    : Icons.show_chart_rounded),
            size: 48,
            color: const Color(0xFF2C961B),
          ),
          const SizedBox(height: 12),
          Text(
            'Modul ${_tabs[_selectedTabIndex]}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Informasi ${_tabs[_selectedTabIndex].toLowerCase()} untuk tanaman ${_currentPlant.name} sesuai panduan PRD.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Navigation Bar identik dengan seluruh alur Figma
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
                  color: Color(0x14000000), // rgba(0, 0, 0, 0.08)
                  blurRadius: 12,
                  offset: Offset(0, -2),
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
              onTap: _showScanModal,
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
                      color: Color(0xFFDF4B2C),
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
