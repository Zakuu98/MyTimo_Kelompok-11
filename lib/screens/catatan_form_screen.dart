import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/validators.dart';

/// Halaman form untuk menginput catatan tambahan pada item.
class CatatanFormScreen extends StatefulWidget {
  const CatatanFormScreen({super.key});

  @override
  State<CatatanFormScreen> createState() => _CatatanFormScreenState();
}

class _CatatanFormScreenState extends State<CatatanFormScreen> {
  // (1) Key Form dan controller input teks
  final _formKey = GlobalKey<FormState>();
  final _catatanController = TextEditingController();

  // (2) Dispose controller saat screen ditutup
  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  // (3) Proses simpan dan mengembalikan data catatan ke screen sebelumnya
  void _simpan() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Navigator.pop membawa hasil data bertipe String
    Navigator.pop(context, _catatanController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Tulis Catatan'),
          backgroundColor: AppColors.surface,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input teks catatan dengan validasi minimal 5 karakter
                TextFormField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      Validators.minLength(value, 5, fieldName: 'Catatan'),
                ),
                const SizedBox(height: 16),
                // Tombol simpan
                FilledButton(
                  onPressed: _simpan,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
