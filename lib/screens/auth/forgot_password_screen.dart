import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/curved_header.dart';

/// Halaman Lupa Kata Sandi sesuai Screenshot Desain 05_Lupa_Kat
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'petani@kebun.id');
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      AppToast.showError(context, message: 'Harap masukkan alamat email yang valid.');
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppToast.showSuccess(
        context,
        title: 'Petunjuk Reset Terkirim!',
        subtitle: 'Simulasi reset akun dikirimkan ke ${_emailController.text}',
      );
      Navigator.of(context).maybePop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header Gradien Hijau Melengkung
          CurvedHeader(
            title: 'Lupa Kata Sandi',
            showBackButton: true,
            onBackPressed: () => Navigator.of(context).maybePop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.p10),

                  // Card Form Atur Ulang Sandi
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                      boxShadow: AppSizes.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Atur Ulang Sandi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p8),
                        const Text(
                          'Masukkan email terdaftar untuk menerima petunjuk pemulihan kata sandi akun MyTimo kamu.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p20),

                        AppTextField(
                          label: 'Email Akun Terdaftar',
                          hintText: 'nama@email.com',
                          controller: _emailController,
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                        ),
                        const SizedBox(height: AppSizes.p20),

                        AppButton(
                          label: 'Kirim Petunjuk Reset',
                          isLoading: _isLoading,
                          onPressed: _handleResetPassword,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.p20),

                  // Box Informasi Penyimpanan Lokal Aman
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenSurface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primaryGreen,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penyimpanan Lokal Aman',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.primaryGreenText,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Data kamu tersimpan secara lokal di database perangkat Anda tanpa pengiriman ke cloud.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF2E7D32),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
