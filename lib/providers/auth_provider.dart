import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// State management untuk autentikasi dan sesi pengguna MyTimo
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser = const UserModel(
    id: 'user_001',
    name: 'Pak Budi',
    email: 'budi.petani@mytimo.id',
    farmLocation: 'Kebun Lembang 0.8 Ha',
    avatarPath: 'assets/images/farmer_avatar.webp',
  );

  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordObscured = true;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPasswordObscured => _isPasswordObscured;

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

    if (email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Email dan Kata Sandi wajib diisi';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: 'user_001',
      name: email.contains('budi') ? 'Pak Budi' : 'Petani Tomat',
      email: email.trim(),
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

    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Semua field wajib diisi';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: email.trim(),
      farmLocation: 'Kebun Tomat Mitra',
      avatarPath: 'assets/images/farmer_avatar.webp',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
