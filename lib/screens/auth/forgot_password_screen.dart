import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/app_text_field.dart';

/// Halaman Lupa / Atur Kata Sandi MyTimo sesuai Desain Figma (Frame: forgot_password)
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.showError(
        context,
        'Mohon periksa kembali kata sandi sesuai ketentuan.',
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.resetPassword(
      _newPasswordController.text,
    );

    if (success && mounted) {
      AppSnackBar.showSuccess(
        context,
        'Kata sandi berhasil diperbarui! Silakan masuk kembali.',
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } else if (mounted && authProvider.errorMessage != null) {
      AppSnackBar.showError(context, authProvider.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.signUpBackground,
        body: Column(
          children: [
            // 1. Header Gradient (Height 120px, bottom radius 28px, shadow)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.forgotPasswordHeaderGradient,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x24002600),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  child: Row(
                    children: [
                      // Back Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // App Bar Title
                      const Text(
                        'Lupa Kata Sandi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Scrollable Body Form
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 26.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Big Title: Lupa Kata Sandi
                      const Text(
                        'Lupa Kata Sandi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      const Text(
                        'Buat kata sandi baru untuk akun MyTimo kamu, lalu konfirmasi kata sandi baru untuk melanjutkan.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8E8E8E),
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Input 1: Kata Sandi Baru
                      AppTextField(
                        label: 'Kata Sandi Baru',
                        hintText: '••••••••',
                        controller: _newPasswordController,
                        obscureText: _isNewPasswordObscured,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewPasswordObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.signUpTextGray,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordObscured = !_isNewPasswordObscured;
                            });
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Kata sandi baru tidak boleh kosong';
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

                      const SizedBox(height: 18),

                      // Input 2: Konfirmasi Kata Sandi Baru
                      AppTextField(
                        label: 'Konfirmasi Kata Sandi Baru',
                        hintText: '••••••••',
                        controller: _confirmPasswordController,
                        obscureText: _isConfirmPasswordObscured,
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
                            _isConfirmPasswordObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.signUpTextGray,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                            });
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Konfirmasi kata sandi tidak boleh kosong';
                          }
                          if (val != _newPasswordController.text) {
                            return 'Konfirmasi kata sandi tidak cocok';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 36),

                      // Button "Atur Kata Sandi"
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppColors.signUpButtonGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x38002600),
                                  blurRadius: 14,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: auth.isLoading ? null : _handleResetPassword,
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
                                          'Atur Kata Sandi',
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
