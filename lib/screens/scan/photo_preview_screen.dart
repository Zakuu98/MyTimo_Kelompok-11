import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';

/// Halaman Pratinjau Foto Daun sesuai Desain Figma Frame: Pratinjau_Foto
/// Menampilkan:
/// - Header gradient hijau dengan tombol back & judul "Pratinjau Foto Daun"
/// - Box pratinjau foto daun dengan 4 corner bracket putih
/// - Card validasi "Kualitas Citra Memenuhi Syarat" (resolusi, format, fokus)
/// - Input pilihan tanaman "Hubungkan ke Tanaman *" dengan border oranye/merah
/// - Input catatan "Catatan Kondisi Daun" multiline dengan border oranye/merah
/// - Tombol "Foto Ulang" & "Lanjut Diagnosis AI"
/// - Custom BottomNavBar dengan elevated center scan FAB
class PhotoPreviewScreen extends StatefulWidget {
  final String? imagePath;
  final String? plantName;
  final String? leafConditionNotes;

  const PhotoPreviewScreen({
    super.key,
    this.imagePath,
    this.plantName,
    this.leafConditionNotes,
  });

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  late String _selectedPlantName;
  late final TextEditingController _notesController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _selectedPlantName = widget.plantName ?? 'Tomat Cherry Blok A';
    _notesController = TextEditingController(
      text: widget.leafConditionNotes ??
          'Bercak cincin kecokelatan di daun bawah ke-3',
    );
  }

  @override
  void dispose() {
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
          // Header Gradient Hijau
          _buildHeader(topInset),

          // Konten Utama Scrollable (mencegah overflow di layar kecil)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Box Foto Daun dengan 4 Corner Bracket
                  _buildLeafPhotoCard(),
                  const SizedBox(height: 12),

                  // 2. Banner Validasi Kualitas Citra
                  _buildImageQualityCard(),
                  const SizedBox(height: 16),

                  // 3. Form Input: Hubungkan ke Tanaman *
                  _buildPlantSelectorSection(),
                  const SizedBox(height: 18),

                  // 4. Form Input: Catatan Kondisi Daun
                  _buildLeafNotesSection(),
                  const SizedBox(height: 24),

                  // 5. Tombol Aksi: Foto Ulang & Lanjut Diagnosis AI
                  _buildActionButtons(),
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

  /// Header Gradient hijau sesuai CSS Figma Frame: Pratinjau_Foto
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

              // Judul Halaman
              const Expanded(
                child: Text(
                  'Pratinjau Foto Daun',
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

  /// 1. Card Foto Daun dengan 4 Corner Brackets
  /// Ukuran 342x190, borderRadius 26px, 4 pojokan border 3.5px putih
  Widget _buildLeafPhotoCard() {
    final imageAsset = widget.imagePath ?? 'assets/images/hero_tomatoes.webp';

    return Container(
      width: double.infinity,
      height: 190,
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
          // Gambar Pratinjau Foto Daun
          Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              'assets/images/hero_tomatoes.webp',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF2E7D32),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white70,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

          // 4 Corner Brackets Putih (30x30, border 3.5px solid #FFFFFF)
          Positioned(
            top: 20,
            left: 20,
            child: _buildCornerBracket(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _buildCornerBracket(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _buildCornerBracket(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildCornerBracket(isTop: false, isLeft: false),
          ),
        ],
      ),
    );
  }

  /// Corner Bracket 30x30 dengan border 3.5px
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

  /// 2. Card Validasi "Kualitas Citra Memenuhi Syarat"
  Widget _buildImageQualityCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF9E7),
        border: Border.all(color: const Color(0xFFBFE8B9), width: 1.0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon lingkaran centang gradien hijau
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF389D33), Color(0xFF178401)],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Teks Status & Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Kualitas Citra Memenuhi Syarat',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF178401),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  'Resolusi 1080×1080 • Format JPEG • Fokus Daun Baik',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF106804),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Form Input: Hubungkan ke Tanaman *
  Widget _buildPlantSelectorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hubungkan ke Tanaman *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown Selector Container
        GestureDetector(
          onTap: _showPlantPickerModal,
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
                  color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Sprout
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

                // Nama Tanaman
                Expanded(
                  child: Text(
                    _selectedPlantName,
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

                // Chevron Down Icon
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Color(0xFF8E8E8E),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Modal Pemilihan Tanaman
  void _showPlantPickerModal() {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final List<PlantModel> plants = plantProvider.plants;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 16),
                const Text(
                  'Pilih Tanaman Terhubung',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                if (plants.isEmpty) ...[
                  // Opsi Default Fallback jika list kosong
                  _buildPlantOptionItem('Tomat Cherry Blok A', ctx),
                  _buildPlantOptionItem('Tomat Beef Blok B', ctx),
                  _buildPlantOptionItem('Tomat Roma Blok D', ctx),
                ] else ...[
                  ...plants.map((p) => _buildPlantOptionItem(p.name, ctx)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantOptionItem(String name, BuildContext ctx) {
    final isSelected = _selectedPlantName == name;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEAF9E7)
              : const Color(0xFFF3EDED),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.eco_outlined,
          color: isSelected ? const Color(0xFF178401) : const Color(0xFF8E8E8E),
          size: 20,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
          color: isSelected ? const Color(0xFF178401) : Colors.black,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF178401),
              size: 20,
            )
          : null,
      onTap: () {
        setState(() {
          _selectedPlantName = name;
        });
        Navigator.pop(ctx);
      },
    );
  }

  /// 4. Form Input: Catatan Kondisi Daun
  Widget _buildLeafNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan Kondisi Daun',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Text Field Multiline Container (Height: 89)
        Container(
          width: double.infinity,
          height: 89,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDF4B2C), width: 1.0),
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
              hintText: 'Tulis catatan kondisi daun di sini...',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF8E8E8E),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 5. Tombol Aksi: "Foto Ulang" & "Lanjut Diagnosis AI"
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Tombol Foto Ulang (Width: 130, Height: 52)
        SizedBox(
          width: 130,
          height: 52,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF389D33), width: 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1,
              shadowColor: const Color(0x0F002600), // rgba(0, 38, 0, 0.06)
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'Foto Ulang',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF178401),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Tombol Lanjut Diagnosis AI (Fills remainder ~200px, Height: 52)
        Expanded(
          child: Container(
            height: 52,
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
                onTap: _isProcessing ? null : _onLanjutDiagnosis,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isProcessing) ...[
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Flexible(
                      child: Text(
                        'Lanjut Diagnosis AI',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Tindakan Lanjut Diagnosis AI
  void _onLanjutDiagnosis() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      _showDiagnosisResultModal();
    });
  }

  /// Modal Hasil Diagnosis AI
  void _showDiagnosisResultModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).padding.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF3EDED),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFDF64),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFBA6900),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Penyakit Terdeteksi: Early Blight',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFFBA6900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Title Diagnosis
              Text(
                'Hasil Diagnosis $_selectedPlantName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Akurasi Model AI: 94.2% • Bercak Kering Septoria/Early Blight',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF7E7E7E),
                ),
              ),
              const SizedBox(height: 16),

              // Rekomendasi Solusi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rekomendasi Penanganan:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF106804),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Pangkas dan buang daun bawah yang bergejala.\n• Kurangi kelembapan dan hindari menyiram dari atas tajuk.\n• Berikan fungisida tembaga atau nabati secara berkala.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Tindakan Selesai / Simpan
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Color(0xFF178401)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF178401),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
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
                            color: Color(0x33178401),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(23),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(23),
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context, true);
                          },
                          child: const Center(
                            child: Text(
                              'Simpan Hasil',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Custom BottomNavigationBar sesuai CSS Figma Frame: Pratinjau_Foto
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
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(3);
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
                  // White Ring 66x66
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
                      // Gradient Circle 52x52
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
                  // Teks "Pindai" merah sesuai CSS #D91C1C
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
