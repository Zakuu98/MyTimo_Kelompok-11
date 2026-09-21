import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

/// Landing Page MyTimo sesuai Frame 1 Figma
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppSizes.p32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top Section: Icon & Header Text
                    Column(
                      children: [
                        const SizedBox(height: AppSizes.p12),
                        // Scanner Icon badge
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.tomatoRed,
                            borderRadius: BorderRadius.circular(AppSizes.radiusL),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.tomatoRed.withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.crop_free_rounded,
                            color: AppColors.textWhite,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p16),
                        // Title: MyTimo App
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: AppTextStyles.heading1,
                            children: [
                              TextSpan(text: 'MyTimo '),
                              TextSpan(
                                text: 'App',
                                style: TextStyle(color: AppColors.tomatoRed),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.p8),
                        // Subtitle
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(text: 'Deteksi Penyakit Tomat\n'),
                              TextSpan(
                                text: 'Secepat Kilat',
                                style: TextStyle(
                                  color: AppColors.tomatoRed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(text: ' dengan AI'),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Middle Section: Hero Image Card
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.p20),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.38,
                          maxWidth: 340,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.radius2XL),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x18000000),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.radius2XL),
                          child: Image.asset(
                            'assets/images/hero_tomatoes.webp',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 260,
                                color: AppColors.primaryGreenSoft,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.eco_rounded,
                                  size: 80,
                                  color: AppColors.primaryGreen,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Bottom Section: Action Buttons
                    Column(
                      children: [
                        AppButton(
                          label: 'Mulai Sekarang',
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSizes.p12),
                        AppButton.secondary(
                          label: 'Masuk ke Akun Anda',
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSizes.p12),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
