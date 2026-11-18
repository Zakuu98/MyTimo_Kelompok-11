import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/delete_confirmation_dialog.dart';
import '../history/scan_detail_screen.dart';
import '../scan/camera_scan_screen.dart';
import 'edit_plant_screen.dart';

/// Detail Tanaman Screen sesuai Screenshot Desain 11_plant_detail
class PlantDetailScreen extends StatefulWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  int _activeTabIndex = 0; // 0: Ringkasan, 1: Riwayat, 2: Rencana, 3: Monitor

  void _handleDeletePlant(PlantModel plant) {
    DeleteConfirmationDialog.show(
      context,
      title: 'Hapus Data Tanaman?',
      subtitle: 'Apakah Anda yakin ingin menghapus data tanaman ini?',
      previewContent: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 18),
            const SizedBox(width: 8),
            Text(
              plant.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
      warningText: 'Peringatan! Seluruh riwayat scan dan rencana pemantauan terkait tanaman ini akan dihapus permanen dari sistem lokal.',
      confirmLabel: 'Ya, Hapus',
      onConfirm: () {
        context.read<PlantProvider>().deletePlant(plant.id);
        AppToast.showSuccess(
          context,
          title: 'Data tanaman berhasil dihapus',
          subtitle: '${plant.name} telah dihilangkan dari daftar.',
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final plant = plantProvider.getPlantById(widget.plantId);

    if (plant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tanaman')),
        body: const Center(child: Text('Data tanaman tidak ditemukan atau telah dihapus.')),
      );
    }

    final plantScans = plantProvider.getScansForPlant(plant.id);
    final latestScan = plantProvider.getLatestScanForPlant(plant.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Tomato Image Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryGreenDark,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EditPlantScreen(plant: plant)),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    plant.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primaryGreen),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Plant Content Details
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0, -16, 0),
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tags Row
                  Wrap(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenSurface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Text(
                          plant.variety.isNotEmpty ? plant.variety : 'Tomat Umum',
                          style: const TextStyle(
                            color: AppColors.primaryGreenText,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Text(
                          'ID: #${plant.id}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p16),

                  // Pill Tabs Bar (Ringkasan, Riwayat, Rencana, Monitor)
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        _buildTabItem(0, 'Ringkasan'),
                        _buildTabItem(1, 'Riwayat (${plantScans.length})'),
                        _buildTabItem(2, 'Rencana'),
                        _buildTabItem(3, 'Monitor'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.p20),

                  // Tab Content Switcher
                  if (_activeTabIndex == 0) ...[
                    _buildRingkasanTab(context, plant, latestScan),
                  ] else if (_activeTabIndex == 1) ...[
                    _buildRiwayatTab(context, plantScans),
                  ] else if (_activeTabIndex == 2) ...[
                    _buildRencanaTab(context),
                  ] else ...[
                    _buildMonitorTab(context, plant),
                  ],

                  const SizedBox(height: AppSizes.p28),

                  // Action Buttons: Pindai Daun Tanaman Ini & Hapus Data Tanaman
                  AppButton(
                    label: 'Pindai Daun Tanaman Ini',
                    prefixIcon: const Icon(Icons.crop_free_rounded, color: Colors.white, size: 22),
                    onPressed: () {
                      plantProvider.setSelectedPlantForScan(plant.id);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CameraScanScreen(preselectedPlantId: plant.id),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.p12),

                  AppButton.dangerOutline(
                    label: 'Hapus Data Tanaman Ini',
                    prefixIcon: const Icon(Icons.delete_outline_rounded, color: AppColors.tomatoRed, size: 20),
                    onPressed: () => _handleDeletePlant(plant),
                  ),
                  const SizedBox(height: AppSizes.p20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isActive = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanTab(BuildContext context, PlantModel plant, dynamic latestScan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2x2 Info Stat Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildStatCard(Icons.place_outlined, 'Lokasi', plant.location),
            _buildStatCard(Icons.calendar_today_outlined, 'Tanggal Tanam', plant.plantingDate),
            _buildStatCard(Icons.eco_outlined, 'Varietas', plant.variety.isNotEmpty ? plant.variety : 'Umum'),
            _buildStatCard(Icons.insights_rounded, 'Total Scan', '${plant.totalScans}x • ${plant.status}'),
          ],
        ),
        const SizedBox(height: AppSizes.p20),

        // Catatan Awal (if exists)
        if (plant.initialNotes.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.p14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan Awal Kebun',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  plant.initialNotes,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.p20),
        ],

        // Scan Terakhir Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Scan Terakhir',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            GestureDetector(
              onTap: () => setState(() => _activeTabIndex = 1),
              child: const Text(
                'Lihat Semua >',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p10),

        if (latestScan != null) ...[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ScanDetailScreen(scanId: latestScan.id)),
              );
            },
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    child: Image.asset(
                      latestScan.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          latestScan.timestamp,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${latestScan.diseaseDetected} (${latestScan.formattedConfidence})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: latestScan.isHealthy ? AppColors.statusGreenBg : AppColors.statusYellowBg,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      latestScan.severity,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: latestScan.isHealthy ? AppColors.statusGreen : AppColors.statusYellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
            ),
            child: const Center(
              child: Text(
                'Belum ada riwayat pemindaian untuk tanaman ini.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                Text(
                  value,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatTab(BuildContext context, List<dynamic> scans) {
    if (scans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.history_rounded, size: 48, color: AppColors.textMuted),
            SizedBox(height: 8),
            Text('Belum ada pemindaian tercatat', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: scans.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final scan = scans[i];
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ScanDetailScreen(scanId: scan.id)),
            );
          },
          tileColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(scan.imagePath, width: 44, height: 44, fit: BoxFit.cover),
          ),
          title: Text(scan.diseaseDetected, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text('${scan.timestamp} • ${scan.formattedConfidence}', style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        );
      },
    );
  }

  Widget _buildRencanaTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_outlined, color: AppColors.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text('Rencana Penanganan (FR-08)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Setelah diagnosis penyakit disimpan, Anda dapat membuat rencana tindakan pemulihan (pemangkasan, aplikasi fungisida, dan perbaikan drainase) di modul Penanganan.',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitorTab(BuildContext context, PlantModel plant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline_rounded, color: AppColors.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text('Timeline Monitoring (FR-09)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Kondisi terkini: ${plant.status}. Tercatat ${plant.totalScans} kali pemindaian sejak ${plant.plantingDate}. Modul monitoring akan menyusun grafik perkembangan kesehatan tanaman.',
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}
