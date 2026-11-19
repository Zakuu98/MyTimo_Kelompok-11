import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

/// Landing Screen MyTimo sesuai Desain Figma (Frame 1: landing_page)
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Light icons for dark gradient background
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Image (Tomat Segar)
            Image.asset(
              'assets/custom_assets/images/landing_background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika asset belum dimuat
                return Container(
                  color: const Color(0xFF08330D),
                );
              },
            ),

            // 2. Dark Green Linear Gradient Overlay
            // linear-gradient(180deg, rgba(8, 51, 13, 0.45) 0%, rgba(5, 31, 10, 0.8) 100%)
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.landingOverlayGradient,
              ),
            ),

            // 3. Foreground Content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Menghitung top padding responsif agar posisi logo mirip di Figma (~106px dari safe area)
                  final topPadding = (constraints.maxHeight * 0.12).clamp(32.0, 106.0);

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: topPadding),

                              // Logo Squircle (92x92, radius 28, gradient #DF4B2C -> #E89746, shadow)
                              Container(
                                width: 92,
                                height: 92,
                                decoration: BoxDecoration(
                                  gradient: AppColors.landingLogoGradient,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF002600).withValues(alpha: 0.30),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/custom_assets/icons/ic_scan_landing.png',
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.crop_free_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Title: MyTimo App
                              const Text(
                                'MyTimo App',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.25,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Subtitle: Deteksi Penyakit Tomat Secepat Kilat dengan AI
                              SizedBox(
                                width: 300,
                                child: Text(
                                  'Deteksi Penyakit Tomat Secepat Kilat\ndengan AI',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.landingSubtitle.copyWith(
                                    color: const Color(0xEBFFFFFF), // rgba(255, 255, 255, 0.92)
                                    fontSize: 15,
                                    height: 22 / 15,
                                  ),
                                ),
                              ),

                              // Flexible Spacer pushing buttons to bottom
                              const Spacer(),
                              const SizedBox(height: 32),

                              // Action Button 1: Mulai Sekarang (White pill button with green text & arrow)
                              Container(
                                width: double.infinity,
                                height: 56,
                                constraints: const BoxConstraints(maxWidth: 342),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF002600).withValues(alpha: 0.25),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(28),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Mulai Sekarang',
                                          style: AppTextStyles.landingButtonPrimary,
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          'assets/custom_assets/icons/ic_arrow_right.png',
                                          width: 20,
                                          height: 20,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 20,
                                              color: AppColors.landingGreen,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Action Button 2: Masuk ke Akun Anda (Glassmorphic semi-transparent outline pill button)
                              Container(
                                width: double.infinity,
                                height: 52,
                                constraints: const BoxConstraints(maxWidth: 342),
                                decoration: BoxDecoration(
                                  color: AppColors.landingButtonSecondaryBg, // rgba(255, 255, 255, 0.18)
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: AppColors.landingButtonSecondaryBorder, // rgba(255, 255, 255, 0.50)
                                    width: 1.0,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(26),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Masuk ke Akun Anda',
                                        style: AppTextStyles.landingButtonSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
