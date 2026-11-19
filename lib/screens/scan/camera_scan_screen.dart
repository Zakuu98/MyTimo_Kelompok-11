import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Halaman Kamera Scan AI sesuai Desain Figma Frame: Kamera_Scan
/// Menampilkan:
/// - Full-screen background feed kamera (jamur_septoria.png dengan overlay gradient gelap)
/// - Top bar kontrol: Tombol Close (x), Toggle Flash (zap), Switch Camera (flip)
/// - Guide chip: "Arahkan pada 1 helai daun bergejala"
/// - Frame reticle scanner 290x290 (garis putus-putus dengan 4 sudut hijau neon #4ADE80 & titik fokus berdenyut)
/// - Tips chip: "Pastikan daun fokus & pencahayaan cukup"
/// - Bottom controls: Tombol Galeri, Tombol Shutter (ring gradien merah-oranye + tombol putih 60x60), Tombol Bantuan (?)
/// - Home indicator bar
class CameraScanScreen extends StatefulWidget {
  final String? plantName;

  const CameraScanScreen({
    super.key,
    this.plantName,
  });

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with SingleTickerProviderStateMixin {
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _isScanning = false;
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _laserAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFlashOn ? 'Lampu kilat (Flash) aktif' : 'Lampu kilat dimatikan'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _flipCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFrontCamera ? 'Beralih ke kamera depan' : 'Beralih ke kamera belakang',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _pickFromGallery() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuka galeri foto perangkat...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      barrierColor: const Color(0xFF0F172A).withValues(alpha: 0.55),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EDED),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF178401),
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Panduan Pemindaian AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                number: '1',
                text: 'Posisikan 1 helai daun yang bergejala tepat di dalam kotak bidik hijau.',
              ),
              const SizedBox(height: 8),
              _buildHelpItem(
                number: '2',
                text: 'Pastikan daun dalam keadaan fokus dan pencahayaan sekitar cukup terang.',
              ),
              const SizedBox(height: 8),
              _buildHelpItem(
                number: '3',
                text: 'Tekan tombol shutter putih di bawah untuk memulai identifikasi AI.',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF178401),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(
                      fontFamily: 'Inter',
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

  Widget _buildHelpItem({required String number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFE7FDDD),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF178401),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              height: 1.35,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
      ],
    );
  }

  void _onCapture() {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
    });

    // Simulasi analisis AI & tampilkan hasil diagnosis
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
      });
      _showDiagnosisResultModal();
    });
  }

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
                widget.plantName != null
                    ? 'Hasil Diagnosis ${widget.plantName}'
                    : 'Hasil Diagnosis AI Daun Tomat',
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

              // Tombol Tindakan
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
                        'Pindai Lagi',
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Hasil scan berhasil disimpan ke riwayat!'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
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

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - topInset - bottomInset;
    final isCompact = availableHeight < 680;

    // Hitung ukuran reticle secara responsif
    final maxReticleHeight = isCompact ? 190.0 : 290.0;
    final reticleSize = math.min(screenWidth - 80, maxReticleHeight);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Feed Kamera (Background Image + Gradient Overlay)
          Positioned.fill(
            child: Image.asset(
              'assets/custom_assets/images/jamur_septoria.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF08330D),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 64,
                    color: Colors.white38,
                  ),
                ),
              ),
            ),
          ),

          // Gradient Overlay sesuai CSS Figma:
          // linear-gradient(180deg, rgba(8, 51, 13, 0.45) 0%, rgba(5, 31, 10, 0.7) 100%)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x7308330D), // rgba(8, 51, 13, 0.45)
                    Color(0xB3051F0A), // rgba(5, 31, 10, 0.7)
                  ],
                ),
              ),
            ),
          ),

          // 2. Konten Layar (SafeArea)
          SafeArea(
            child: Column(
              children: [
                // Top Bar Kontrol (Btn x, Btn zap, Btn flip)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Close (X)
                      _buildTopCircleButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),

                      // Tombol Flash & Flip
                      Row(
                        children: [
                          // Btn zap (Flash)
                          _buildTopCircleButton(
                            icon: _isFlashOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            iconColor: _isFlashOn
                                ? const Color(0xFFFACC15)
                                : Colors.white,
                            onTap: _toggleFlash,
                          ),
                          const SizedBox(width: 8),

                          // Btn flip (Flip camera)
                          _buildTopCircleButton(
                            icon: Icons.flip_camera_ios_rounded,
                            onTap: _flipCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isCompact ? 6 : 12),

                // Guide Chip: "Arahkan pada 1 helai daun bergejala"
                Container(
                  constraints: BoxConstraints(maxWidth: screenWidth - 60),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0x6B000000), // rgba(0, 0, 0, 0.42)
                    border: Border.all(
                      color: const Color(0x38FFFFFF), // rgba(255, 255, 255, 0.22)
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40002600), // rgba(0, 38, 0, 0.25)
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Arahkan pada 1 helai daun bergejala',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),

                // Area Tengah (Reticle & Tips Chip) dinamis tanpa overflow
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Frame Dashed Reticle (290x290) dengan 4 Sudut Hijau & Focus Dot
                      Center(
                        child: SizedBox(
                          width: reticleSize,
                          height: reticleSize,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Reticle Custom Painter
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: ScannerReticlePainter(
                                    cornerRadius: 26.0,
                                    cornerLength: 32.0,
                                    strokeWidth: 3.5,
                                    cornerColor: const Color(0xFF4ADE80),
                                    dashedColor: const Color(0xB3FFFFFF),
                                  ),
                                ),
                              ),

                              // Laser Scan Line Animation
                              AnimatedBuilder(
                                animation: _laserAnimation,
                                builder: (context, child) {
                                  return Positioned(
                                    top: 15 + (reticleSize - 30) * _laserAnimation.value,
                                    left: 20,
                                    right: 20,
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0xFF4ADE80),
                                            Colors.transparent,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4ADE80).withValues(alpha: 0.6),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Focus Dot (8x8) dengan efek denyut
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4ADE80),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xCC4ADE80), // rgba(74, 222, 128, 0.8)
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: isCompact ? 12 : 24),

                      // Tips Chip: "Pastikan daun fokus & pencahayaan cukup"
                      Container(
                        constraints: BoxConstraints(maxWidth: screenWidth - 48),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0x6B000000), // rgba(0, 0, 0, 0.42)
                          border: Border.all(
                            color: const Color(0x38FFFFFF), // rgba(255, 255, 255, 0.22)
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40002600), // rgba(0, 38, 0, 0.25)
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Pastikan daun fokus & pencahayaan cukup',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Controls: Galeri, Shutter, Bantuan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tombol Galeri (52x52)
                      GestureDetector(
                        onTap: _pickFromGallery,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0x6B000000), // rgba(0, 0, 0, 0.42)
                            border: Border.all(
                              color: const Color(0x38FFFFFF),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40002600),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      // Tombol Shutter (84x84 Ring Gradien + 60x60 White Shutter)
                      GestureDetector(
                        onTap: _onCapture,
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFD9221E),
                                Color(0xFFD46031),
                                Color(0xFFE89A42),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x59002600), // rgba(0, 38, 0, 0.35)
                                blurRadius: 14,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 62,
                              height: 62,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: _isScanning
                                  ? const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(0xFFD9221E),
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      // Tombol Bantuan (?) (48x48)
                      GestureDetector(
                        onTap: _showHelpDialog,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0x6B000000), // rgba(0, 0, 0, 0.42)
                            border: Border.all(
                              color: const Color(0x38FFFFFF),
                              width: 1.0,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40002600),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isCompact ? 10 : 24),

                // Home Indicator Bar (134x5)
                Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xB3FFFFFF), // rgba(255, 255, 255, 0.7)
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),

                SizedBox(height: isCompact ? 4 : 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper untuk membangun tombol bundar 40x40 di bagian atas layar
  Widget _buildTopCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0x61000000), // rgba(0, 0, 0, 0.38)
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0x4DFFFFFF), // rgba(255, 255, 255, 0.3)
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// CustomPainter untuk menggambar garis putus-putus Rounded Rectangle
/// dan 4 sudut sudut tebal berwarna hijau neon (#4ADE80)
class ScannerReticlePainter extends CustomPainter {
  final double cornerRadius;
  final double cornerLength;
  final double strokeWidth;
  final Color cornerColor;
  final Color dashedColor;

  const ScannerReticlePainter({
    required this.cornerRadius,
    required this.cornerLength,
    required this.strokeWidth,
    required this.cornerColor,
    required this.dashedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius));

    // 1. Gambar garis putus-putus pada RRect
    final dashedPaint = Paint()
      ..color = dashedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    _drawDashedRRect(canvas, rrect, dashedPaint, 6.0, 5.0);

    // 2. Gambar 4 Sudut L-bracket Hijau (#4ADE80)
    final cornerPaint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final r = cornerRadius;
    final l = cornerLength;
    final w = size.width;
    final h = size.height;

    // Sudut Kiri Atas (Top-Left)
    final tlPath = Path()
      ..moveTo(0, l)
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..lineTo(l, 0);
    canvas.drawPath(tlPath, cornerPaint);

    // Sudut Kanan Atas (Top-Right)
    final trPath = Path()
      ..moveTo(w - l, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      ..lineTo(w, l);
    canvas.drawPath(trPath, cornerPaint);

    // Sudut Kiri Bawah (Bottom-Left)
    final blPath = Path()
      ..moveTo(0, h - l)
      ..lineTo(0, h - r)
      ..arcToPoint(Offset(r, h), radius: Radius.circular(r))
      ..lineTo(l, h);
    canvas.drawPath(blPath, cornerPaint);

    // Sudut Kanan Bawah (Bottom-Right)
    final brPath = Path()
      ..moveTo(w - l, h)
      ..lineTo(w - r, h)
      ..arcToPoint(Offset(w, h - r), radius: Radius.circular(r))
      ..lineTo(w, h - l);
    canvas.drawPath(brPath, cornerPaint);
  }

  void _drawDashedRRect(
    Canvas canvas,
    RRect rrect,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(dashWidth, metric.length - distance);
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant ScannerReticlePainter oldDelegate) {
    return oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerColor != cornerColor ||
        oldDelegate.dashedColor != dashedColor;
  }
}
