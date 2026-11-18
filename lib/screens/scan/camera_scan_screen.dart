import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import 'photo_preview_screen.dart';
import '../history/scan_detail_screen.dart';

/// Kamera Pemindaian dengan Framing Guide sesuai Screenshot Desain 12_Kamera_
class CameraScanScreen extends StatefulWidget {
  final String? preselectedPlantId;

  const CameraScanScreen({super.key, this.preselectedPlantId});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isFlashOn = false;
  bool _showGrid = true;
  String _sampleLeafImage = 'assets/images/disease_late_blight.webp';

  Future<void> _captureWithCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      ).timeout(const Duration(milliseconds: 100), onTimeout: () => null);

      if (photo != null && mounted) {
        _proceedToPreview(photo.path, isFile: true);
        return;
      }
    } catch (_) {
      // Fallback untuk platform tanpa modul kamera fisik (misal Windows Desktop)
    }

    // Menggunakan citra daun berkualitas tinggi untuk alur simulasi
    if (mounted) {
      _proceedToPreview(_sampleLeafImage, isFile: false);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      ).timeout(const Duration(milliseconds: 100), onTimeout: () => null);

      if (image != null && mounted) {
        _proceedToPreview(image.path, isFile: true, inputSource: 'Galeri');
        return;
      }
    } catch (_) {
      // Fallback jika pemilih berkas desktop memerlukan berkas lokal
    }

    if (mounted) {
      _proceedToPreview('assets/images/disease_septoria.webp', isFile: false, inputSource: 'Galeri');
    }
  }

  void _proceedToPreview(String imagePath, {bool isFile = false, String inputSource = 'Kamera'}) async {
    final scanId = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => PhotoPreviewScreen(
          imagePath: imagePath,
          isFile: isFile,
          inputSource: inputSource,
          preselectedPlantId: widget.preselectedPlantId,
        ),
      ),
    );

    if (scanId != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ScanDetailScreen(scanId: scanId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Viewfinder background (simulated real leaf view or camera stream)
          Image.asset(
            _sampleLeafImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1B3B22)),
          ),

          // Camera Viewfinder Tint
          Container(
            color: Colors.black.withValues(alpha: 0.25),
          ),

          // Grid Overlay (if toggled on)
          if (_showGrid) ...[
            CustomPaint(
              painter: _CameraGridPainter(),
              child: const SizedBox.expand(),
            ),
          ],

          // Framing Guide Overlay Box (Green Neon Center Box)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Framing Prompt
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.center_focus_strong_rounded, color: AppColors.cameraGuideGreen, size: 16),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Arahkan pada 1 helai daun bergejala',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Green Target Box
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cameraGuideGreen,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cameraGuideGreen.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Framing Corner Markers
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(width: 14, height: 14, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white, width: 2), left: BorderSide(color: Colors.white, width: 2)))),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(width: 14, height: 14, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white, width: 2), right: BorderSide(color: Colors.white, width: 2)))),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(width: 14, height: 14, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 2), left: BorderSide(color: Colors.white, width: 2)))),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(width: 14, height: 14, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 2), right: BorderSide(color: Colors.white, width: 2)))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bottom Hint
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny_outlined, color: Colors.amber, size: 14),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Pastikan daun bersih dan fokus cukup',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 11.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top App Bar Controls (Close, Flash, Grid)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: Icon(
                              _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                              color: _isFlashOn ? Colors.amber : Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _isFlashOn = !_isFlashOn);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: Icon(
                              _showGrid ? Icons.grid_on_rounded : Icons.grid_off_rounded,
                              color: _showGrid ? AppColors.cameraGuideGreen : Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _showGrid = !_showGrid);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Controls Bar (Gallery, Shutter Button, Switch Sample)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gallery Picker Button
                    GestureDetector(
                      key: const Key('gallery_picker_button'),
                      onTap: _pickFromGallery,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                        ),
                        child: const Icon(
                          Icons.photo_library_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Center Shutter Button
                    GestureDetector(
                      key: const Key('camera_shutter_button'),
                      onTap: _captureWithCamera,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    // Switch Leaf Sample / Torch Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _sampleLeafImage = _sampleLeafImage == 'assets/images/disease_late_blight.webp'
                              ? 'assets/images/disease_septoria.webp'
                              : 'assets/images/disease_late_blight.webp';
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                        ),
                        child: const Icon(
                          Icons.flip_camera_android_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
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

class _CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    final wThird = size.width / 3;
    final hThird = size.height / 3;

    canvas.drawLine(Offset(wThird, 0), Offset(wThird, size.height), paint);
    canvas.drawLine(Offset(wThird * 2, 0), Offset(wThird * 2, size.height), paint);

    canvas.drawLine(Offset(0, hThird), Offset(size.width, hThird), paint);
    canvas.drawLine(Offset(0, hThird * 2), Offset(size.width, hThird * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
