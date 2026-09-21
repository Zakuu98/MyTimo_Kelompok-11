import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../main_navigation_screen.dart';
import 'login_screen.dart';

/// Register Screen MyTimo sesuai Frame 3 Figma
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Glowing warm accent at top center
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tomatoRed.withValues(alpha: 0.35),
                        blurRadius: 80,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p8,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.p16),
                    // Title
                    RichText(
                      text: const TextSpan(
                        style: AppTextStyles.heading2,
                        children: [
                          TextSpan(text: 'Daftar Akun '),
                          TextSpan(
                            text: 'MyTimo',
                            style: TextStyle(color: AppColors.tomatoRed),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p6),
                    // Subtitle
                    const Text(
                      'Pantau Kesehatan Tanaman Kamu',
                      style: AppTextStyles.subtitle,
                    ),

                    const SizedBox(height: AppSizes.p28),

                    // Name Input
                    AppTextField(
                      label: 'Nama',
                      hintText: 'Nama',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.p18),

                    // Email Input
                    AppTextField(
                      label: 'Email',
                      hintText: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!val.contains('@')) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.p18),

                    // Password Input with Visibility Toggle
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return AppTextField(
                          label: 'Kata Sandi',
                          hintText: 'Kata Sandi',
                          controller: _passwordController,
                          obscureText: auth.isPasswordObscured,
                          prefixIcon: Icons.lock_outline_rounded,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              auth.isPasswordObscured
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: AppSizes.iconSizeMedium,
                            ),
                            onPressed: auth.togglePasswordVisibility,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            if (val.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        );
                      },
                    ),

                    // Error Message
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        if (auth.errorMessage != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSizes.p12),
                            child: Text(
                              auth.errorMessage!,
                              style: const TextStyle(
                                color: AppColors.tomatoRed,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: AppSizes.p32),

                    // Tombol Daftar
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return AppButton(
                          label: 'Daftar',
                          isLoading: auth.isLoading,
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          onPressed: _handleRegister,
                        );
                      },
                    ),

                    const SizedBox(height: AppSizes.p24),

                    // Footer Link: Sudah punya akun? Masuk
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(text: 'Sudah punya akun? '),
                              TextSpan(
                                text: 'Masuk',
                                style: TextStyle(
                                  color: AppColors.tomatoRed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSizes.p20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
