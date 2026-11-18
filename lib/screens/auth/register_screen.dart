import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
import '../main_navigation_screen.dart';
import 'login_screen.dart';

/// Sign Up Screen MyTimo sesuai Screenshot Desain 04_Daftar
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

  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = 'Harap lengkapi seluruh formulir pendaftaran dengan benar.';
      });
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = authProvider.errorMessage ?? 'Pendaftaran gagal.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p24,
            vertical: AppSizes.p8,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tomato Scanner Badge
                Container(
                  width: 54,
                  height: 54,
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
                    Icons.eco_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: AppSizes.p16),

                // Title & Subtitle
                const Text(
                  'Daftar Akun MyTimo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pastikan identitas akun terdaftar valid',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.p24),

                // Error Banner
                if (_errorMessage != null) ...[
                  FormValidationBanner(
                    title: 'Pendaftaran Gagal',
                    message: _errorMessage!,
                  ),
                  const SizedBox(height: AppSizes.p16),
                ],

                // Nama Field
                AppTextField(
                  label: 'Nama',
                  hintText: 'Nama',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  isRequired: true,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.p16),

                // Email Field
                AppTextField(
                  label: 'Email',
                  hintText: 'Email',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!val.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.p16),

                // Password Field
                AppTextField(
                  label: 'Kata Sandi',
                  hintText: 'Kata Sandi',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  isRequired: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Kata sandi wajib diisi';
                    }
                    if (val.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.p24),

                // Primary Button: Daftar
                AppButton(
                  label: 'Daftar',
                  isLoading: authProvider.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: AppSizes.p20),

                // Footer: Sudah punya akun? Masuk
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
