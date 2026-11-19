import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_success_dialog.dart';
import 'add_plant_screen.dart';
import 'widgets/plant_card_item.dart';
import 'widgets/plant_empty_state.dart';
import 'widgets/plant_filter_modal.dart';

/// Halaman Daftar Tanaman (plant_list) sesuai Desain Figma
/// Mendukung 2 Tampilan Utama:
/// 1. Tampilan Data Dummy (List 4 tanaman tomat dengan chip filter status & floating button)
/// 2. Tampilan Empty State ("Belum Ada Data Tanaman" jika seluruh tanaman dihapus / user baru)
class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterChips = [
    'Semua',
    'Sehat',
    'Perlu Rawat',
    'Parah',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<PlantProvider>(context, listen: false).setSearchQuery('');
  }

  Future<void> _navigateToAddPlantScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlantScreen(),
      ),
    );

    if (result == true && mounted) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      final latestPlant =
          plantProvider.plants.isNotEmpty ? plantProvider.plants.first : null;
      final plantName = latestPlant?.name ?? 'Tanaman Baru';

      AppSuccessDialog.show(
        context: context,
        title: 'Data Tanaman Ditambahkan!',
        message:
            'Data "$plantName" berhasil disimpan dan ditambahkan ke daftar pemantauan.',
        buttonText: 'Lihat Daftar Tanaman',
        autoDismissDuration: null,
        onContinue: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final topInset = MediaQuery.of(context).padding.top;
    final filteredList = plantProvider.filteredPlants;
    final isListEmpty = filteredList.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.plantListBackground,
      body: Stack(
        children: [
          Column(
            children: [
              // 1. Header Gradient dengan Judul, Tombol Filter, dan Search Bar
              _buildHeader(topInset),

              // 2. Baris Filter Chips (Semua, Sehat, Perlu Rawat, Parah)
              _buildFilterChipsRow(plantProvider),

              // 3. Body: Tampilan List Tanaman atau Empty State
              Expanded(
                child: isListEmpty
                    ? PlantEmptyState(
                        onAddPlant: _navigateToAddPlantScreen,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 100, // Ruang untuk floating button & bottom bar
                        ),
                        itemCount: filteredList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return PlantCardItem(plant: filteredList[index]);
                        },
                      ),
              ),
            ],
          ),

          // 4. Floating Action Button (+) di kanan bawah (hanya muncul saat ada data)
          if (!isListEmpty)
            Positioned(
              right: 20,
              bottom: 24,
              child: _buildFloatingAddButton(),
            ),
        ],
      ),
    );
  }

  /// Header Gradient hijau sesuai CSS Frame: plant_list
  Widget _buildHeader(double topInset) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF599151), // 3%
            Color(0xFF2C961B), // 50%
            Color(0xFFE7FDDD), // 100%
          ],
          stops: [0.03, 0.50, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x24000000), // rgba(0, 0, 0, 0.14)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: topInset + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Baris Judul & Tombol Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Tanaman',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),

              // Tombol Filter Funnel Glassmorphism
              GestureDetector(
                onTap: () => PlantFilterModal.show(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.plantListFilterBtnBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.plantListFilterBtnBorder,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/custom_assets/icons/ic_filter.png',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search Bar Input
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D002600), // rgba(0, 38, 0, 0.05)
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                Provider.of<PlantProvider>(context, listen: false)
                    .setSearchQuery(val);
              },
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF111827),
              ),
              decoration: InputDecoration(
                hintText: 'Cari nama tanaman atau blok…',
                hintStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Color(0xFF8E8E8E),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF8E8E8E),
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Baris Horizontal Chips (Semua (X), Sehat, Perlu Rawat, Parah)
  Widget _buildFilterChipsRow(PlantProvider plantProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: _filterChips.map((chipName) {
            final isSelected =
                plantProvider.selectedFilter.toLowerCase() == chipName.toLowerCase();

            // Label khusus untuk chip "Semua" menyertakan total jumlah item
            String chipLabel;
            if (chipName.toLowerCase() == 'semua') {
              chipLabel = 'Semua (${plantProvider.plants.length})';
            } else {
              chipLabel = chipName;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  plantProvider.setSelectedFilter(chipName);
                },
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppColors.plantListChipActiveGradient
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Color(0x33178401),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    chipLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF4B5563),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Tombol Floating Add (+) di kanan bawah
  Widget _buildFloatingAddButton() {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF389D33),
            Color(0xFF178401),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x4D178401),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _navigateToAddPlantScreen,
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
