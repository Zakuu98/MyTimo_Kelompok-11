import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/delete_scan_history_dialog.dart';
import 'edit_scan_note_screen.dart';
import 'scan_history_screen.dart';

/// Halaman Detail Riwayat Pemindaian sesuai Desain Figma Frame: Detail_Riwayat_Scan
/// Menampilkan:
/// - Header gradient hijau dengan tombol back & judul "Detail Riwayat Pemindaian"
/// - Box Foto Scan 342x168px dengan 4 corner bracket putih
/// - Card Tanaman & Waktu + Status Diagnosa
/// - Input Catatan Riwayat (Dapat Diedit)
/// - Tombol "Simpan Perubahan Catatan" (Gradien Hijau)
/// - Tombol "Hapus Riwayat Scan Ini" (Aksen Merah/Pink)
/// - Custom BottomNavBar dengan tab Riwayat aktif
class ScanHistoryDetailScreen extends StatefulWidget {
  final ScanHistoryItem? item;
  final String? imagePath;
  final String? plantName;
  final String? scanDate;
  final String? diagnosisText;
  final String? initialNotes;
  final String? status;

  const ScanHistoryDetailScreen({
    super.key,
    this.item,
    this.imagePath,
    this.plantName,
    this.scanDate,
    this.diagnosisText,
    this.initialNotes,
    this.status,
  });

  @override
  State<ScanHistoryDetailScreen> createState() => _ScanHistoryDetailScreenState();
}

class _ScanHistoryDetailScreenState extends State<ScanHistoryDetailScreen> {
  late final TextEditingController _notesController;
  late String _imagePath;
  late String _plantName;
  late String _scanDate;
  late String _diagnosisText;
  late String _status;

  @override
  void initState() {
    super.initState();
    final item = widget.item;

    _imagePath = widget.imagePath ??
        item?.imageAsset ??
        'assets/custom_assets/images/jamur_septoria.png';

    _plantName = widget.plantName ??
        item?.plantName ??
        'Tomat Cherry Blok A';

    _scanDate = widget.scanDate ??
        item?.dateTimeText ??
        '06 Okt 2026, 14:20';

    _status = widget.status ?? item?.status ?? 'Sedang';

    _diagnosisText = widget.diagnosisText ??
        (item != null
            ? 'Diagnosis: ${item.diseaseName} (${item.confidence.toStringAsFixed(1)}% Akurat)'
            : 'Diagnosis: Early Blight (94.2% Akurat)');

    _notesController = TextEditingController(
      text: widget.initialNotes ??
          'Bercak baru muncul di 2 daun bagian bawah, segera pangkas dan semprot fungisida tembaga.',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Color get _diagnosisColor {
    switch (_status.toLowerCase()) {
      case 'sehat':
        return const Color(0xFF178401);
      case 'parah':
        return const Color(0xFFCC0000);
      case 'sedang':
      default:
        return const Color(0xFFBA6900);
    }
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

          // 2. Konten Utama Scrollable (Bebas Overflow di Layar Kompak)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto Scan dengan 4 Corner Brackets
                  _buildScanPhotoCard(),
                  const SizedBox(height: 12),

                  // Card Tanaman & Waktu + Diagnosa
                  _buildPlantTimeDiagnosisCard(),
                  const SizedBox(height: 16),

                  // Label: Catatan Riwayat + Tombol Ubah ke Halaman Ubah Catatan Riwayat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Catatan Riwayat',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditScanNoteScreen(
                                item: widget.item,
                                plantName: _plantName,
                                initialNotes: _notesController.text,
                              ),
                            ),
                          );
                          if (result != null && result is Map<String, dynamic>) {
                            if (result['notes'] != null && mounted) {
                              setState(() {
                                _notesController.text = result['notes'];
                              });
                            }
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_outlined, size: 14, color: Color(0xFF178401)),
                            SizedBox(width: 4),
                            Text(
                              'Ubah',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF178401),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Input Catatan Riwayat (Dapat Diedit)
                  _buildNotesInputContainer(),
                  const SizedBox(height: 20),

                  // Tombol: Simpan Perubahan Catatan
                  _buildSaveButton(),
                  const SizedBox(height: 12),

                  // Tombol: Hapus Riwayat Scan Ini
                  _buildDeleteButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(bottomInset),
    );
  }

  /// Header Gradient hijau sesuai CSS Figma Frame: Detail_Riwayat_Scan
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

              // Judul Halaman "Detail Riwayat Pemindaian"
              const Expanded(
                child: Text(
                  'Detail Riwayat Pemindaian',
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

              // Ikon Tempat Sampah (Figma: icon/trash di header)
              GestureDetector(
                onTap: _showDeleteConfirmationDialog,
                child: Container(
                  width: 36,
                  height: 36,
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card Foto Scan Daun dengan 4 Corner Brackets Putih (342x168px)
  Widget _buildScanPhotoCard() {
    return Container(
      width: double.infinity,
      height: 168,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A002600),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gambar Daun Scan
          Image.asset(
            _imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              'assets/custom_assets/images/jamur_septoria.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF2E7D32),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white70,
                    size: 44,
                  ),
                ),
              ),
            ),
          ),

          // 4 Corner Brackets Putih (30x30, border 3.5px solid #FFFFFF)
          Positioned(
            top: 18,
            left: 20,
            child: _buildCornerBracket(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 18,
            right: 20,
            child: _buildCornerBracket(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 18,
            left: 20,
            child: _buildCornerBracket(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 18,
            right: 20,
            child: _buildCornerBracket(isTop: false, isLeft: false),
          ),
        ],
      ),
    );
  }

  /// Helper Corner Bracket 30x30px
  Widget _buildCornerBracket({required bool isTop, required bool isLeft}) {
    const double size = 30.0;
    const double borderWidth = 3.5;
    const Color borderColor = Colors.white;
    const Radius radius = Radius.circular(8.0);

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: borderColor, width: borderWidth)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: borderColor, width: borderWidth)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: borderColor, width: borderWidth)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: borderColor, width: borderWidth)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: (isTop && isLeft) ? radius : Radius.zero,
            topRight: (isTop && !isLeft) ? radius : Radius.zero,
            bottomLeft: (!isTop && isLeft) ? radius : Radius.zero,
            bottomRight: (!isTop && !isLeft) ? radius : Radius.zero,
          ),
        ),
      ),
    );
  }

  /// Card Tanaman & Waktu + Status Diagnosa (342x100px, borderRadius 20px)
  Widget _buildPlantTimeDiagnosisCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17002600), // rgba(0, 38, 0, 0.09)
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Subtitle kecil: Tanaman & Waktu
          const Text(
            'Tanaman & Waktu',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 4),

          // Nama Tanaman • Waktu Scan
          Text(
            '$_plantName • $_scanDate',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Baris Diagnosis: Early Blight (94.2% Akurat)
          Text(
            _diagnosisText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: _diagnosisColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Input Catatan Riwayat (Dapat Diedit, 342x84px)
  Widget _buildNotesInputContainer() {
    return Container(
      width: double.infinity,
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 3,
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
          hintText: 'Tulis catatan riwayat di sini...',
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Color(0xFF8E8E8E),
          ),
        ),
      ),
    );
  }

  /// Tombol: "Simpan Perubahan Catatan" (342x54px, Gradien Hijau)
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
          onTap: _onSaveNotes,
          child: const Center(
            child: Text(
              'Simpan Perubahan Catatan',
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

  /// Aksi Simpan Perubahan Catatan
  void _onSaveNotes() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan catatan riwayat berhasil disimpan!'),
        backgroundColor: Color(0xFF178401),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Tombol: "Hapus Riwayat Scan Ini" (342x50px, Background Pink Muda)
  Widget _buildDeleteButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _showDeleteConfirmationDialog,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
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
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFFCC0000),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog Konfirmasi Hapus Riwayat sesuai Figma Frame: Hapus_Riwayat
  void _showDeleteConfirmationDialog() async {
    final confirmed = await DeleteScanHistoryDialog.show(
      context: context,
      item: widget.item,
      diseaseName: widget.item?.diseaseName ?? 'Early Blight',
      confidence: widget.item?.confidence ?? 94.2,
      plantName: _plantName,
      dateTimeText: _scanDate,
      status: _status,
      imageAsset: _imagePath,
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Riwayat scan berhasil dihapus!'),
          backgroundColor: Color(0xFFCC0000),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true); // true = dihapus
    }
  }

  /// Custom BottomNavigationBar sesuai CSS Figma Frame: Detail_Riwayat_Scan
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
