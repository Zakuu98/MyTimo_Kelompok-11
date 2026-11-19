import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// State management untuk autentikasi dan sesi pengguna MyTimo
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  // Akun terdaftar di sistem lokal (dengan pre-seeded akun default Pak Budi)
  final Map<String, ({String name, String password})> _registeredAccounts = {
    'budi.santoso@gmail.com': (name: 'Pak Budi Santoso', password: 'KebunTomat123!'),
    'budi.petani@gmail.com': (name: 'Pak Budi', password: 'KebunTomat123!'),
  };

  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordObscured = true;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPasswordObscured => _isPasswordObscured;

  bool isEmailRegistered(String email) =>
      _registeredAccounts.containsKey(email.trim().toLowerCase());

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi delay proses autentikasi lokal
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan Kata Sandi wajib diisi';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Aturan: Harus sudah daftar baru bisa login
    if (!_registeredAccounts.containsKey(normalizedEmail)) {
      _errorMessage = 'Akun belum terdaftar, silakan daftar terlebih dahulu';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final account = _registeredAccounts[normalizedEmail]!;
    if (account.password != password) {
      _errorMessage = 'Kata sandi salah';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: account.name,
      email: normalizedEmail,
      farmLocation: 'Kebun Lembang 0.8 Ha',
      avatarPath: 'assets/images/farmer_avatar.webp',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();

    if (name.trim().isEmpty || normalizedEmail.isEmpty || password.isEmpty) {
      _errorMessage = 'Semua field wajib diisi';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Simpan akun baru ke database lokal terdaftar
    _registeredAccounts[normalizedEmail] = (
      name: name.trim(),
      password: password,
    );

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalizedEmail,
      farmLocation: 'Kebun Tomat Mitra',
      avatarPath: 'assets/images/farmer_avatar.webp',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> resetPassword(String newPassword, {String? email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final targetEmail = email?.trim().toLowerCase() ??
        _registeredAccounts.keys.firstOrNull ??
        'budi.santoso@gmail.com';

    if (_registeredAccounts.containsKey(targetEmail)) {
      final existing = _registeredAccounts[targetEmail]!;
      _registeredAccounts[targetEmail] = (
        name: existing.name,
        password: newPassword,
      );
    } else {
      _registeredAccounts[targetEmail] = (
        name: 'Pak Budi Santoso',
        password: newPassword,
      );
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
