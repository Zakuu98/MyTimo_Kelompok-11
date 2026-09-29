import 'package:flutter/material.dart';
import '../../data/item_repository.dart';
import '../../models/item.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/state_views.dart';
import 'widgets/home_header_card.dart';
import 'widgets/recent_diagnosis_section.dart';
import 'widgets/scan_banner_card.dart';
import 'widgets/stats_summary_row.dart';
import 'widgets/weather_info_card.dart';

// (1) status tampilan
enum ViewStatus { loading, success, error }

/// Halaman Dashboard Utama (Home) MyTimo sesuai Frame 4 Figma & PRD FR-01
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // (2) variabel state
  final _repository = ItemRepository();
  ViewStatus _status = ViewStatus.loading;
  List<Item> _items = [];
  String _errorMessage = '';
  // ignore: prefer_final_fields
  bool _simulateError = false; // ubah ke true untuk menguji error state

  // (3) ambil data saat layar pertama kali dibuka
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // (4) mengambil data + menangani error
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
      body: SafeArea(
        top: false,
        child: _buildContent(), // (5) isi layar tergantung status
      ),
    );
  }

  // (6) memilih tampilan: loading / error / empty / daftar data
  Widget _buildContent() {
    return switch (_status) {
      ViewStatus.loading => const LoadingView(),
      ViewStatus.error => ErrorView(
          message: _errorMessage,
          onRetry: _loadItems,
        ),
      ViewStatus.success => _buildList(),
    };
  }

  Widget _buildList() {
    if (_items.isEmpty) {
      return const EmptyView(message: 'Belum ada data.');
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card with Gradient & Weather (Praktikum 1)
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
                // Call-To-Action Banner: Foto Daun Tomat Sekarang
                const ScanBannerCard(),

                const SizedBox(height: AppSizes.p16),

                // Metrics Stats Row (24, 88%, 3)
                const StatsSummaryRow(),

                const SizedBox(height: AppSizes.p24),

                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          color: AppColors.primaryGreen,
                          size: AppSizes.iconSizeMedium,
                        ),
                        const SizedBox(width: AppSizes.p8),
                        Text(
                          'Ensiklopedia & Panduan',
                          style: AppTextStyles.sectionTitle.copyWith(fontSize: 15.5),
                        ),
                      ],
                    ),
                    Text(
                      '${_items.length} Item',
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p12),

                // Daftar Item dari _items (ItemRepository)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSizes.p10),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppSizes.roundedL,
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreenSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textMuted,
                        ),
                        // (7) kirim item yang dipilih ke layar Detail
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

                // Riwayat Diagnosa Terbaru
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
