import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/app_success_dialog.dart';
import '../../widgets/app_text_field.dart';
import '../main_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

/// Login Screen MyTimo sesuai Desain Figma (Frame: login)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      final userName = authProvider.currentUser?.name ?? 'Petani';
      await AppSuccessDialog.show(
        context: context,
        title: 'Login Berhasil!',
        message: 'Selamat datang kembali di MyTimo, $userName. Membuka beranda...',
        onContinue: () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              (route) => false,
            );
          }
        },
      );
    } else if (mounted && authProvider.errorMessage != null) {
      AppSnackBar.showError(context, authProvider.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.signUpBackground,
        body: Stack(
          children: [
            // 1. Header Photo & Farm Green Gradient Overlay (330px per Figma)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 330,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/custom_assets/images/jamur_septoria.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFF0B3D0B));
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.loginOverlayGradient,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Content Area (Header Texts + White Sheet)
            SafeArea(
              top: false,
              bottom: true,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Content Area
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            // Back Button (40x40 circle, rgba(255, 255, 255, 0.22), border 1px rgba(255, 255, 255, 0.40))
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => Navigator.of(context).maybePop(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0x38FFFFFF), // rgba(255, 255, 255, 0.22)
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0x66FFFFFF), // rgba(255, 255, 255, 0.40)
                                      width: 1.0,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Title Line 1: Masuk Akun
                            const Text(
                              'Masuk Akun',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.15,
                              ),
                            ),

                            // Title Line 2: MyTimo (Color: #E89044)
                            const Text(
                              'MyTimo',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: AppColors.loginMyTimoOrange, // #E89044
                                height: 1.15,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Subtitle: Pantau kesehatan tanaman tomat kamu setiap hari
                            SizedBox(
                              width: 300,
                              child: Text(
                                'Pantau kesehatan tanaman tomat kamu\nsetiap hari',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.90),
                                  height: 1.4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    // White Bottom Sheet Panel (Top radius 32, shadow)
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: screenHeight > 600 ? screenHeight - 262 : 540,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 16,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Email Input
                            AppTextField(
                              label: 'Email',
                              hintText: 'nama@email.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.mail_outline_rounded,
                              prefixIconSize: 20,
                              prefixIconColor: AppColors.signUpTextGray,
                              borderColor: AppColors.signUpInputBorder,
                              borderRadius: BorderRadius.circular(16),
                              labelStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0x75000000), // rgba(0, 0, 0, 0.46)
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                final trimmed = val.trim().toLowerCase();
                                if (!trimmed.endsWith('@gmail.com') || trimmed == '@gmail.com') {
                                  return 'Email harus menggunakan @gmail.com';
                                }
                                final username = trimmed.substring(0, trimmed.length - '@gmail.com'.length);
                                if (username.contains(' ') || username.isEmpty) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // 2. Kata Sandi Input
                            AppTextField(
                              label: 'Kata Sandi',
                              hintText: '••••••••',
                              controller: _passwordController,
                              obscureText: _isPasswordObscured,
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconSize: 20,
                              prefixIconColor: AppColors.signUpTextGray,
                              borderColor: AppColors.signUpInputBorder,
                              borderRadius: BorderRadius.circular(16),
                              labelStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0x75000000), // rgba(0, 0, 0, 0.46)
                              ),
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.signUpTextGray,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                if (val.length < 8) {
                                  return 'Kata sandi minimal 8 karakter';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(val)) {
                                  return 'Harus mengandung minimal 1 huruf besar (A-Z)';
                                }
                                if (!RegExp(r'[a-z]').hasMatch(val)) {
                                  return 'Harus mengandung minimal 1 huruf kecil (a-z)';
                                }
                                if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\/`~]').hasMatch(val)) {
                                  return 'Harus mengandung minimal 1 simbol (!@#\$%...)';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            // Lupa Kata Sandi? (Right aligned text link in #178401)
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Lupa Kata Sandi?',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.loginForgotPasswordGreen, // #178401
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Error Message from AuthProvider (e.g. Akun belum terdaftar)
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                if (auth.errorMessage != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
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

                            const SizedBox(height: 24),

                            // Tombol Masuk (Gradient #389D33 -> #178401, radius 28, shadow)
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.signUpButtonGradient,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x40000000),
                                        blurRadius: 12,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(28),
                                      onTap: auth.isLoading ? null : _handleLogin,
                                      child: Center(
                                        child: auth.isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : const Text(
                                                'Masuk',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 28),

                            // Footer: Belum punya akun? Daftar
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.signUpTextGray,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Belum punya akun? '),
                                      TextSpan(
                                        text: 'Daftar',
                                        style: const TextStyle(
                                          color: AppColors.signUpInputBorder, // #DF4B2C
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
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
