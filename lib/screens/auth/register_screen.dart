import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/app_success_dialog.dart';
import '../../widgets/app_text_field.dart';
import '../main_navigation_screen.dart';
import 'login_screen.dart';

/// Register Screen MyTimo sesuai Desain Figma (Frame: sign_up)
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

  bool _isPasswordObscured = true;

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
      final userName = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : (authProvider.currentUser?.name ?? 'Petani');
      await AppSuccessDialog.show(
        context: context,
        title: 'Pendaftaran Berhasil!',
        message: 'Akun Anda berhasil didaftarkan, $userName. Membuka beranda...',
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
            // 1. Header Gradient & Image (Height: 330px per Figma)
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
                      return Container(color: const Color(0xFF08330D));
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.signUpHeaderGradient,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Content (Header items + White Panel)
            SafeArea(
              top: false,
              bottom: true,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    // Header Content Area
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // Back Button (40x40 circle with rgba(255, 255, 255, 0.2))
                            Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => Navigator.of(context).maybePop(),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Color(0x33FFFFFF), // rgba(255, 255, 255, 0.2)
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Logo Squircle (68x68, radius 20, gradient #DF4B2C -> #E89746, shadow)
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                gradient: AppColors.landingLogoGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF002600).withValues(alpha: 0.30),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/custom_assets/icons/ic_scan_landing.png',
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.crop_free_rounded,
                                      size: 32,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Title: Daftar Akun MyTimo (Poppins bold 24px)
                            const Text(
                              'Daftar Akun MyTimo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Subtitle: Pantau Kesehatan Tanaman Kamu (Inter 13px)
                            Text(
                              'Pantau Kesehatan Tanaman Kamu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.90),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // White Rounded Panel (Top radius 32, shadow)
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: screenHeight > 600 ? screenHeight - 270 : 500,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF002600).withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Nama Input
                            AppTextField(
                              label: 'Nama',
                              hintText: 'Nama lengkap',
                              controller: _nameController,
                              prefixIcon: Icons.person_outline_rounded,
                              prefixIconSize: 18,
                              prefixIconColor: AppColors.signUpTextGray,
                              borderColor: AppColors.signUpInputBorder,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D002600),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              labelStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.signUpTextGray,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // 2. Email Input (Validation: must use @gmail.com)
                            AppTextField(
                              label: 'Email',
                              hintText: 'nama@email.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.mail_outline_rounded,
                              prefixIconSize: 18,
                              prefixIconColor: AppColors.signUpTextGray,
                              borderColor: AppColors.signUpInputBorder,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D002600),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              labelStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.signUpTextGray,
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

                            const SizedBox(height: 16),

                            // 3. Kata Sandi Input (Validation: min 8 char, uppercase, lowercase, symbol + eye toggle)
                            AppTextField(
                              label: 'Kata Sandi',
                              hintText: '••••••••',
                              controller: _passwordController,
                              obscureText: _isPasswordObscured,
                              prefixIcon: Icons.lock_outline_rounded,
                              prefixIconSize: 18,
                              prefixIconColor: AppColors.signUpTextGray,
                              borderColor: AppColors.signUpInputBorder,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D002600),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              labelStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.signUpTextGray,
                              ),
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.signUpTextGray,
                                  size: 18,
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

                            // Error Message from AuthProvider
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                if (auth.errorMessage != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
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

                            const SizedBox(height: 28),

                            // Tombol Daftar (Gradient #389D33 -> #178401, radius 20, shadow)
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.signUpButtonGradient,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF002600).withValues(alpha: 0.22),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: auth.isLoading ? null : _handleRegister,
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
                                                'Daftar',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 15,
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

                            const SizedBox(height: 24),

                            // Footer: Sudah punya akun? Masuk
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.signUpTextGray,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Sudah punya akun? '),
                                      TextSpan(
                                        text: 'Masuk',
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
