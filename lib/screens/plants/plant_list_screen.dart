import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/curved_header.dart';
import 'add_plant_screen.dart';
import 'plant_detail_screen.dart';

/// Daftar Tanaman Screen sesuai Screenshot Desain 08_plant_list
class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final plants = plantProvider.filteredPlants;
    final totalPlants = plantProvider.allPlants.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Curved Green Header with Search & Filters
          CurvedHeader(
            title: 'Daftar Tanaman',
            subtitle: '$totalPlants Tanaman tomat terdaftar',
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
                    onChanged: (val) => plantProvider.setPlantSearchQuery(val),
                    style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Cari nama tanaman atau blok...',
                      hintStyle: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                              onPressed: () {
                                _searchController.clear();
                                plantProvider.setPlantSearchQuery('');
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
                        label: 'Semua ($totalPlants)',
                        filterValue: 'Semua',
                        currentFilter: plantProvider.plantStatusFilter,
                        onTap: () => plantProvider.setPlantStatusFilter('Semua'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Sehat',
                        filterValue: 'Sehat',
                        currentFilter: plantProvider.plantStatusFilter,
                        onTap: () => plantProvider.setPlantStatusFilter('Sehat'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Perlu Rawat',
                        filterValue: 'Perlu Rawat',
                        currentFilter: plantProvider.plantStatusFilter,
                        onTap: () => plantProvider.setPlantStatusFilter('Perlu Rawat'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Parah',
                        filterValue: 'Parah',
                        currentFilter: plantProvider.plantStatusFilter,
                        onTap: () => plantProvider.setPlantStatusFilter('Parah'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Plants List or Empty State
          Expanded(
            child: plants.isEmpty
                ? _buildEmptyState(context, plantProvider)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p16,
                      vertical: AppSizes.p16,
                    ),
                    itemCount: plants.length,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSizes.p12),
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return _buildPlantCard(context, plant);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddPlantScreen()),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 28),
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

  Widget _buildPlantCard(BuildContext context, PlantModel plant) {
    Color badgeBg;
    Color badgeText;

    if (plant.status.toLowerCase() == 'sehat') {
      badgeBg = AppColors.statusGreenBg;
      badgeText = AppColors.statusGreen;
    } else if (plant.status.toLowerCase() == 'perlu rawat') {
      badgeBg = AppColors.statusYellowBg;
      badgeText = AppColors.statusYellow;
    } else {
      badgeBg = AppColors.statusRedBg;
      badgeText = AppColors.statusRed;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlantDetailScreen(plantId: plant.id)),
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
            // Tomato Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              child: Image.asset(
                plant.imagePath,
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

            // Plant Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${plant.variety.isNotEmpty ? plant.variety : "Varietas Umum"} • ${plant.plantingDate}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plant.location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                plant.status,
                style: TextStyle(
                  color: badgeText,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ),
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
          const SizedBox(height: AppSizes.p24),
          // Empty State Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 42,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: AppSizes.p16),
          const Text(
            'Belum Ada Data Tanaman',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan tanaman tomat pertama Anda untuk memulai pemantauan kesehatan dan riwayat pemindaian.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSizes.p20),
          AppButton(
            label: '+ Tambah Tanaman Baru',
            width: 240,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddPlantScreen()),
              );
            },
          ),
          const SizedBox(height: AppSizes.p28),

          // 3 Langkah Mudah Info Card
          Container(
            padding: const EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.primaryGreen, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '3 Langkah Memulai Pengelolaan Kebun:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.primaryGreenText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildGuideStep('1', 'Beri Identitas Tanaman', 'Daftarkan nama blok/bedeng tomat Anda.'),
                const SizedBox(height: 6),
                _buildGuideStep('2', 'Lakukan Pemindaian Daun', 'Arahkan kamera ke daun bergejala untuk dideteksi.'),
                const SizedBox(height: 6),
                _buildGuideStep('3', 'Pantau Riwayat & Perkembangan', 'Lihat timeline kesehatan secara offline.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(String number, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreenSoft,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreenText,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
              children: [
                TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
