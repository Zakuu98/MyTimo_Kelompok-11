import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/scan_history_model.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/curved_header.dart';
import 'scan_detail_screen.dart';

/// Riwayat Pemindaian Screen sesuai Screenshot Desain 14_Riwayat_
class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final scans = plantProvider.filteredScans;
    final totalScans = plantProvider.allScans.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Header with Search & Filter Chips
          CurvedHeader(
            title: 'Riwayat Pemindaian',
            subtitle: '$totalScans Arsip identifikasi daun',
            bottomChild: Column(
              children: [
                // Search Field
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => plantProvider.setScanSearchQuery(val),
                    style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Cari tanggal, tanaman, atau penyakit...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                              onPressed: () {
                                _searchController.clear();
                                plantProvider.setScanSearchQuery('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Chips Row
                SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip(
                        label: 'Semua ($totalScans)',
                        filterValue: 'Semua',
                        currentFilter: plantProvider.scanDiseaseFilter,
                        onTap: () => plantProvider.setScanDiseaseFilter('Semua'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Early Blight',
                        filterValue: 'Early Blight',
                        currentFilter: plantProvider.scanDiseaseFilter,
                        onTap: () => plantProvider.setScanDiseaseFilter('Early Blight'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Late Blight',
                        filterValue: 'Late Blight',
                        currentFilter: plantProvider.scanDiseaseFilter,
                        onTap: () => plantProvider.setScanDiseaseFilter('Late Blight'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Sehat',
                        filterValue: 'Sehat',
                        currentFilter: plantProvider.scanDiseaseFilter,
                        onTap: () => plantProvider.setScanDiseaseFilter('Sehat'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scans List or Empty State
          Expanded(
            child: scans.isEmpty
                ? _buildEmptyState(context, plantProvider)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                      vertical: AppSizes.p16,
                    ),
                    itemCount: scans.length,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSizes.p12),
                    itemBuilder: (context, index) {
                      final scan = scans[index];
                      return _buildScanCard(context, scan);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String filterValue,
    required String currentFilter,
    required VoidCallback onTap,
  }) {
    final isSelected = currentFilter.toLowerCase() == filterValue.toLowerCase();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B4D24) : Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected ? Colors.white.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanCard(BuildContext context, ScanHistoryModel scan) {
    Color badgeBg;
    Color badgeText;

    if (scan.isHealthy) {
      badgeBg = AppColors.statusGreenBg;
      badgeText = AppColors.statusGreen;
    } else if (scan.severity.toLowerCase() == 'parah') {
      badgeBg = AppColors.statusRedBg;
      badgeText = AppColors.statusRed;
    } else {
      badgeBg = AppColors.statusYellowBg;
      badgeText = AppColors.statusYellow;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ScanDetailScreen(scanId: scan.id)),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: AppColors.borderLight, width: 1.2),
          boxShadow: AppSizes.cardShadow,
        ),
        child: Row(
          children: [
            // Leaf Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              child: Image.asset(
                scan.imagePath,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 52,
                  height: 52,
                  color: AppColors.primaryGreenSurface,
                  child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p14),

            // Scan Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${scan.diseaseDetected} (${scan.formattedConfidence})',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Text(
                          scan.severity,
                          style: TextStyle(
                            color: badgeText,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scan.plantName,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${scan.timestamp} • ${scan.inputSource}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, PlantProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.p24),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.p28),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: AppSizes.p16),
          const Text(
            'Riwayat Tidak Ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tidak ditemukan riwayat pemindaian sesuai kata kunci atau filter pencarian Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSizes.p20),
          AppButton(
            label: 'Reset Filter',
            width: 180,
            onPressed: () {
              _searchController.clear();
              provider.resetScanFilter();
            },
          ),
          const SizedBox(height: AppSizes.p28),

          // Tips Pencarian Card
          Container(
            padding: const EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.primaryGreen, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Tips Pencarian Riwayat:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                        color: AppColors.primaryGreenText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('• Coba gunakan nama blok atau bedeng, misal "Blok A".', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('• Cari berdasarkan nama penyakit, misal "Early Blight".', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('• Atur rentang tanggal atau pilih "Semua" untuk melihat seluruh arsip.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
