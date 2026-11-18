import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

/// Landing Screen MyTimo sesuai Screenshot Desain 01_splash & 02_Landing
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Hero Tomato Image
          Image.asset(
            'assets/images/hero_tomatoes.webp',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF142416),
                child: const Center(
                  child: Icon(Icons.eco_rounded, size: 80, color: AppColors.primaryGreen),
                ),
              );
            },
          ),

          // Dark Aesthetic Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.landingOverlayGradient,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // Center Badge, Title & Tagline
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Scanner Badge
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AppColors.tomatoRed,
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tomatoRed.withValues(alpha: 0.45),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.crop_free_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p20),

                      // Title
                      const Text(
                        'MyTimo App',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p8),

                      // Subtitle
                      const Text(
                        'Deteksi Penyakit Tomat Cepat & Akurat\ndengan AI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE2E8F0),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Action Buttons (White Pill + Outline White)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton.whitePill(
                        label: 'Mulai Sekarang',
                        width: double.infinity,
                        suffixIcon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: AppSizes.p14),
                      AppButton.outlineWhite(
                        label: 'Masuk ke Akun Anda',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: AppSizes.p8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
