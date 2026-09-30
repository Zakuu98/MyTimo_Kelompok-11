import 'package:flutter/material.dart';

import '../../data/item_repository.dart';
import '../../models/item.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/state_views.dart';
import 'widgets/disease_encyclopedia_section.dart';
import 'widgets/home_header_card.dart';
import 'widgets/recent_diagnosis_section.dart';
import 'widgets/scan_banner_card.dart';
import 'widgets/stats_summary_row.dart';
import 'widgets/weather_info_card.dart';

// (1) Enum status tampilan sesuai modul Pertemuan 2
enum ViewStatus { loading, success, error }

/// Halaman Dashboard Utama (Home) MyTimo sesuai Praktikum 1 & Latihan 2
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // (2) Variabel State
  final _repository = ItemRepository();
  ViewStatus _status = ViewStatus.loading;
  List<Item> _items = [];
  String _errorMessage = '';
  final bool _simulateError = false; // ubah ke true untuk menguji error state

  // (3) Ambil data saat layar pertama kali dibuka
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // (4) Mengambil data + menangani error secara asinkron
  Future<void> _loadItems() async {
    if (_status != ViewStatus.loading) {
      setState(() => _status = ViewStatus.loading);
    }
    try {
      final items = await _repository.fetchItems(simulateError: _simulateError);
      if (!mounted) return;
      setState(() {
        _items = items;
        _status = ViewStatus.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _status = ViewStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Home')),
      body: _buildContent(), // (5) Isi layar tergantung status
    );
  }

  // (6) Memilih tampilan: loading / error / empty / daftar data
  Widget _buildContent() {
    return switch (_status) {
      ViewStatus.loading => const LoadingView(),
      ViewStatus.error => ErrorView(message: _errorMessage, onRetry: _loadItems),
      ViewStatus.success => _buildList(),
    };
  }

  Widget _buildList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card dari Praktikum 1
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.homeHeaderGradient,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppSizes.radius2XL),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + AppSizes.p16,
              bottom: AppSizes.p20,
              left: AppSizes.p20,
              right: AppSizes.p20,
            ),
            child: const Column(
              children: [
                HomeHeaderCard(),
                SizedBox(height: AppSizes.p16),
                WeatherInfoCard(),
              ],
            ),
          ),

          // Content Body
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p20,
              vertical: AppSizes.p16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ScanBannerCard(),
                const SizedBox(height: AppSizes.p16),
                const StatsSummaryRow(),
                const SizedBox(height: AppSizes.p24),

                // Section Daftar Item Latihan 2
                Text(
                  'Daftar Item (Latihan 2)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.p12),

                if (_items.isEmpty)
                  const EmptyView(message: 'Belum ada data.')
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ListTile(
                          title: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(item.subtitle),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.primaryGreen),
                          // (7) Kirim item yang dipilih ke layar Detail via Named Route & arguments
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: item,
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: AppSizes.p24),
                const DiseaseEncyclopediaSection(),
                const SizedBox(height: AppSizes.p24),
                const RecentDiagnosisSection(),
                const SizedBox(height: AppSizes.p32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
