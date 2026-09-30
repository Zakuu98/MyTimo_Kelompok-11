import 'package:flutter/material.dart';

import '../models/item.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

/// Halaman Detail yang menerima data Item dari Home dan menerima data Catatan dari Form.
class DetailScreen extends StatefulWidget {
  // (1) Data Item yang DITERIMA dari Home melalui parameter arguments
  final Item item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // (2) Menyimpan hasil catatan yang dikirim kembali dari CatatanFormScreen
  String? _catatan;

  // (3) Membuka form catatan secara asinkron, MENGGUNAKAN await untuk MENUNGGU hasilnya
  Future<void> _bukaFormCatatan() async {
    final hasil = await Navigator.pushNamed<String>(
      context,
      AppRoutes.catatanForm,
    );

    // Periksa mounted sebelum memanggil context atau setState
    if (!mounted || hasil == null) return; // null berarti pengguna menekan tombol kembali / batal

    setState(() => _catatan = hasil);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Data item dibaca melalui widget.item
    final item = widget.item;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(item.title),
          backgroundColor: AppColors.surface,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(item.subtitle, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            Text(item.description),
            const Divider(height: 32),
            Text(
              _catatan == null ? 'Belum ada catatan.' : 'Catatan: $_catatan',
              style: TextStyle(
                fontWeight: _catatan == null ? FontWeight.normal : FontWeight.bold,
                color: _catatan == null ? Colors.grey : AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _bukaFormCatatan,
              icon: const Icon(Icons.edit_note),
              label: const Text('Tulis Catatan'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
