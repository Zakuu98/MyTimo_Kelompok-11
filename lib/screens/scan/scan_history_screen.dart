import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plant_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/plant_provider.dart';
import '../../theme/app_colors.dart';
import '../plant_list/plant_detail_screen.dart';
import 'scan_history_detail_screen.dart';

/// Model item Riwayat Pemindaian sesuai CSS Figma Frame: Riwayat_Scan
class ScanHistoryItem {
  final String id;
  final String title;
  final String plantName;
  final String dateTimeText;
  final String status; // 'Sedang', 'Sehat', 'Parah'
  final String diseaseName; // 'Early Blight', 'Late Blight', 'Daun Sehat'
  final double confidence;
  final String imageAsset;
  final DateTime date;

  const ScanHistoryItem({
    required this.id,
    required this.title,
    required this.plantName,
    required this.dateTimeText,
    required this.status,
    required this.diseaseName,
    required this.confidence,
    required this.imageAsset,
    required this.date,
  });

  Color get badgeBgColor {
    switch (status.toLowerCase()) {
      case 'sehat':
        return const Color(0xFFC5F3C1);
      case 'sedang':
        return const Color(0xFFEFDF64);
      case 'parah':
        return const Color(0xFFFFB1B1);
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  Color get badgeTextColor {
    switch (status.toLowerCase()) {
      case 'sehat':
        return const Color(0xFF178401);
      case 'sedang':
        return const Color(0xFFBA6900);
      case 'parah':
        return const Color(0xFFCC0000);
      default:
        return const Color(0xFF374151);
    }
  }
}

/// Halaman Riwayat Pemindaian (Riwayat_Scan) sesuai Desain Figma
/// Mendukung 2 Tampilan Utama:
/// 1. Tampilan Hasil Pemindaian (Default / Hasil Ditemukan)
///    - Header gradient hijau + Search bar floating
///    - Horizontal Filter Chips: Semua (24), Early Blight (8), Late Blight (5), Daun Sehat (11)
///    - List card riwayat pemindaian 100px
/// 2. Tampilan Pencarian Kosong (Empty State / "Riwayat Tidak Ditemukan")
///    - Tag pencarian aktif (“kata kunci” ✕)
///    - Dropdown filter: Semua Status ▾, Bulan Ini ▾
///    - Counter teks: "Menampilkan 0 riwayat pemindaian"
///    - Card Empty State dengan ikon kaca pembesar, pesan, dan tombol "Reset Filter"
///    - Card Tips Pencarian Riwayat
class ScanHistoryScreen extends StatefulWidget {
  final bool isEmbeddedInNav;

  const ScanHistoryScreen({
    super.key,
    this.isEmbeddedInNav = false,
  });

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Semua';
  String _selectedStatusFilter = 'Semua Status';
  String _selectedPeriodFilter = 'Bulan Ini';

  late final List<ScanHistoryItem> _allItems;

  @override
  void initState() {
    super.initState();
    _initDummyData();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initDummyData() {
    // 24 data riwayat pemindaian sesuai angka chip di Figma CSS:
    // Semua (24) = Early Blight (8) + Late Blight (5) + Daun Sehat (11)
    _allItems = [
      // 4 Item Utama Sesuai Spesifikasi CSS Figma
      ScanHistoryItem(
        id: 'scan-1',
        title: 'Early Blight (94.2%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '06 Okt 2026, 14:20',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 94.2,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 10, 6, 14, 20),
      ),
      ScanHistoryItem(
        id: 'scan-2',
        title: 'Daun Sehat (98.0%)',
        plantName: 'Tomat Servo Bedeng 1',
        dateTimeText: '04 Okt 2026, 09:15',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 98.0,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 10, 4, 9, 15),
      ),
      ScanHistoryItem(
        id: 'scan-3',
        title: 'Late Blight (89.5%)',
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '01 Okt 2026, 16:30',
        status: 'Parah',
        diseaseName: 'Late Blight',
        confidence: 89.5,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 10, 1, 16, 30),
      ),
      ScanHistoryItem(
        id: 'scan-4',
        title: 'Daun Sehat (99.1%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '20 Sep 2026, 11:00',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 99.1,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 9, 20, 11, 0),
      ),

      // Item Tambahan untuk memenuhi total 24 (8 Early Blight, 5 Late Blight, 11 Daun Sehat)
      ScanHistoryItem(
        id: 'scan-5',
        title: 'Early Blight (92.5%)',
        plantName: 'Tomat Sayur Blok C',
        dateTimeText: '18 Sep 2026, 10:15',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 92.5,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 9, 18, 10, 15),
      ),
      ScanHistoryItem(
        id: 'scan-6',
        title: 'Daun Sehat (97.4%)',
        plantName: 'Tomat Servo Bedeng 1',
        dateTimeText: '15 Sep 2026, 08:30',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 97.4,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 9, 15, 8, 30),
      ),
      ScanHistoryItem(
        id: 'scan-7',
        title: 'Early Blight (91.0%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '12 Sep 2026, 13:45',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 91.0,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 9, 12, 13, 45),
      ),
      ScanHistoryItem(
        id: 'scan-8',
        title: 'Late Blight (87.8%)',
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '10 Sep 2026, 15:20',
        status: 'Parah',
        diseaseName: 'Late Blight',
        confidence: 87.8,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 9, 10, 15, 20),
      ),
      ScanHistoryItem(
        id: 'scan-9',
        title: 'Daun Sehat (96.8%)',
        plantName: 'Tomat Sayur Blok C',
        dateTimeText: '08 Sep 2026, 09:00',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 96.8,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 9, 8, 9, 0),
      ),
      ScanHistoryItem(
        id: 'scan-10',
        title: 'Early Blight (93.1%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '05 Sep 2026, 16:10',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 93.1,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 9, 5, 16, 10),
      ),
      ScanHistoryItem(
        id: 'scan-11',
        title: 'Daun Sehat (98.5%)',
        plantName: 'Tomat Servo Bedeng 1',
        dateTimeText: '02 Sep 2026, 07:45',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 98.5,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 9, 2, 7, 45),
      ),
      ScanHistoryItem(
        id: 'scan-12',
        title: 'Late Blight (90.2%)',
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '30 Agu 2026, 14:00',
        status: 'Parah',
        diseaseName: 'Late Blight',
        confidence: 90.2,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 30, 14, 0),
      ),
      ScanHistoryItem(
        id: 'scan-13',
        title: 'Early Blight (88.7%)',
        plantName: 'Tomat Sayur Blok C',
        dateTimeText: '28 Agu 2026, 11:30',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 88.7,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 28, 11, 30),
      ),
      ScanHistoryItem(
        id: 'scan-14',
        title: 'Daun Sehat (97.9%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '25 Agu 2026, 08:15',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 97.9,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 8, 25, 8, 15),
      ),
      ScanHistoryItem(
        id: 'scan-15',
        title: 'Early Blight (95.0%)',
        plantName: 'Tomat Servo Bedeng 1',
        dateTimeText: '22 Agu 2026, 15:40',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 95.0,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 22, 15, 40),
      ),
      ScanHistoryItem(
        id: 'scan-16',
        title: 'Late Blight (91.5%)',
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '19 Agu 2026, 16:50',
        status: 'Parah',
        diseaseName: 'Late Blight',
        confidence: 91.5,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 19, 16, 50),
      ),
      ScanHistoryItem(
        id: 'scan-17',
        title: 'Daun Sehat (99.4%)',
        plantName: 'Tomat Sayur Blok C',
        dateTimeText: '16 Agu 2026, 10:20',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 99.4,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 8, 16, 10, 20),
      ),
      ScanHistoryItem(
        id: 'scan-18',
        title: 'Early Blight (90.8%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '13 Agu 2026, 14:10',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 90.8,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 13, 14, 10),
      ),
      ScanHistoryItem(
        id: 'scan-19',
        title: 'Daun Sehat (98.2%)',
        plantName: 'Tomat Servo Bedeng 1',
        dateTimeText: '10 Agu 2026, 09:35',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 98.2,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 8, 10, 9, 35),
      ),
      ScanHistoryItem(
        id: 'scan-20',
        title: 'Late Blight (88.4%)',
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '07 Agu 2026, 17:05',
        status: 'Parah',
        diseaseName: 'Late Blight',
        confidence: 88.4,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 7, 17, 5),
      ),
      ScanHistoryItem(
        id: 'scan-21',
        title: 'Daun Sehat (96.5%)',
        plantName: 'Tomat Cherry Blok A',
        dateTimeText: '04 Agu 2026, 08:50',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 96.5,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 8, 4, 8, 50),
      ),
      ScanHistoryItem(
        id: 'scan-22',
        title: 'Early Blight (93.7%)',
        plantName: 'Tomat Sayur Blok C',
        dateTimeText: '01 Agu 2026, 11:40',
        status: 'Sedang',
        diseaseName: 'Early Blight',
        confidence: 93.7,
        imageAsset: 'assets/custom_assets/images/jamur_septoria.png',
        date: DateTime(2026, 8, 1, 11, 40),
      ),
      ScanHistoryItem(
        id: 'scan-23',
        title: 'Daun Sehat (97.7%)',
        plantName: 'Tomat Servo Bedeng 1',
        dateTimeText: '28 Jul 2026, 09:10',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 97.7,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 7, 28, 9, 10),
      ),
      ScanHistoryItem(
        id: 'scan-24',
        title: 'Daun Sehat (98.9%)',
        plantName: 'Tomat Mawar Bedeng 4',
        dateTimeText: '25 Jul 2026, 15:00',
        status: 'Sehat',
        diseaseName: 'Daun Sehat',
        confidence: 98.9,
        imageAsset: 'assets/images/hero_tomatoes.webp',
        date: DateTime(2026, 7, 25, 15, 0),
      ),
    ];
  }

  /// Menghitung list data yang telah difilter
  List<ScanHistoryItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();

    return _allItems.where((item) {
      // 1. Filter Kategori Tab / Chip
      if (_selectedCategory != 'Semua') {
        if (!item.diseaseName.toLowerCase().contains(_selectedCategory.toLowerCase())) {
          return false;
        }
      }

      // 2. Filter Status Dropdown
      if (_selectedStatusFilter != 'Semua Status') {
        if (item.status.toLowerCase() != _selectedStatusFilter.toLowerCase()) {
          return false;
        }
      }

      // 3. Filter Waktu / Periode Dropdown
      if (_selectedPeriodFilter == 'Bulan Ini') {
        // Anggap data terkini adalah Oktober 2026
        if (item.date.month != 10 && _selectedStatusFilter != 'Semua Status' && query.isNotEmpty) {
          // Ketika user aktif mencari dengan filter periode
        }
      }

      // 4. Filter Kata Kunci Pencarian (Search Query)
      if (query.isNotEmpty) {
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchPlant = item.plantName.toLowerCase().contains(query);
        final matchDisease = item.diseaseName.toLowerCase().contains(query);
        final matchDate = item.dateTimeText.toLowerCase().contains(query);
        final matchStatus = item.status.toLowerCase().contains(query);

        if (!matchTitle && !matchPlant && !matchDisease && !matchDate && !matchStatus) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'Semua';
      _selectedStatusFilter = 'Semua Status';
      _selectedPeriodFilter = 'Bulan Ini';
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topInset = mediaQuery.padding.top;
    final bottomInset = mediaQuery.padding.bottom;

    final filteredList = _filteredItems;
    final isSearchActive = _searchController.text.trim().isNotEmpty;
    final isResultEmpty = filteredList.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EDED),
      body: Column(
        children: [
          // 1. Header Gradient Hijau & Floating Search Bar
          _buildHeaderWithSearchBar(topInset),

          // 2. Konten Utama
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: isSearchActive && isResultEmpty
                  ? _buildEmptyStateView()
                  : _buildNormalResultView(filteredList),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.isEmbeddedInNav
          ? null
          : _buildBottomNavBar(bottomInset),
    );
  }

  /// Header Gradient hijau dengan Search Bar floating
  Widget _buildHeaderWithSearchBar(double topInset) {
    final headerContentHeight = topInset + 76;
    final totalHeaderHeight = headerContentHeight + 24; // 24px ruang untuk separuh search bar

    return SizedBox(
      height: totalHeaderHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Gradient Hijau
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerContentHeight,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF599151),
                    Color(0xFF2C961B),
                    Color(0xFF6FBD5F),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x24002600), // rgba(0, 38, 0, 0.14)
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      // Tombol Kembali
                      GestureDetector(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            Provider.of<NavigationProvider>(context, listen: false)
                                .setIndex(0);
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Judul "Riwayat Pemindaian"
                      const Expanded(
                        child: Text(
                          'Riwayat Pemindaian',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Tombol Filter (Funnel Icon)
                      GestureDetector(
                        onTap: _showFilterBottomSheet,
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.centerRight,
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search Bar Floating (342x48, borderRadius 24px)
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F002600), // rgba(0, 38, 0, 0.12)
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: Color(0xFF8E8E8E),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Cari tanggal, tanaman, atau penyakit...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tampilan 1: Mode Normal / Hasil Ditemukan
  Widget _buildNormalResultView(List<ScanHistoryItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Filter Chips: Semua (24), Early Blight (8), Late Blight (5), Daun Sehat (11)
        _buildCategoryChipsRow(),
        const SizedBox(height: 14),

        // List Kartu Riwayat Pemindaian
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (ctx, index) {
            return _buildScanHistoryCard(items[index]);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Baris Horizontal Filter Chips sesuai CSS Figma
  Widget _buildCategoryChipsRow() {
    final chips = [
      {'label': 'Semua (24)', 'key': 'Semua'},
      {'label': 'Early Blight (8)', 'key': 'Early Blight'},
      {'label': 'Late Blight (5)', 'key': 'Late Blight'},
      {'label': 'Daun Sehat (11)', 'key': 'Daun Sehat'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.map((c) {
          final isSelected = _selectedCategory == c['key'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = c['key']!;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF389D33), Color(0xFF178401)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0x33002600) // rgba(0, 38, 0, 0.20)
                          : const Color(0x12002600), // rgba(0, 38, 0, 0.07)
                      blurRadius: isSelected ? 10 : 6,
                      offset: Offset(0, isSelected ? 4 : 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    c['label']!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: isSelected ? Colors.white : const Color(0xFF8E8E8E),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Kartu Riwayat Pemindaian (342x100, borderRadius 22px) sesuai CSS Figma
  Widget _buildScanHistoryCard(ScanHistoryItem item) {
    return GestureDetector(
      onTap: () => _showScanDetailDialog(item),
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x17002600), // rgba(0, 38, 0, 0.09)
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Foto Daun (76x76, borderRadius 16px)
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFF2E7D32),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Informasi Diagnosa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Judul Penyakit & Akurasi
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Nama Tanaman
                  Text(
                    item.plantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF8E8E8E),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Waktu Pemindaian
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: Color(0xFF8E8E8E),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item.dateTimeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Color(0xFF8E8E8E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Badge Tingkat Keparahan / Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: item.badgeBgColor,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: item.badgeTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilan 2: Mode Pencarian Kosong (Empty State / Riwayat Tidak Ditemukan)
  Widget _buildEmptyStateView() {
    final queryText = _searchController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris Filter Chips Pencarian Aktif & Dropdown Sesuai Screenshot Kanan
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // Pill 1: Tag Kata Kunci Aktif (“query” ✕)
              Container(
                height: 32,
                padding: const EdgeInsets.only(left: 12, right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF178401),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26178401),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '“$queryText”',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Pill 2: Dropdown Status ▾
              _buildDropdownPill(
                label: _selectedStatusFilter,
                onTap: _showStatusDropdownModal,
              ),
              const SizedBox(width: 8),

              // Pill 3: Dropdown Periode ▾
              _buildDropdownPill(
                label: _selectedPeriodFilter,
                onTap: _showPeriodDropdownModal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Counter Teks: "Menampilkan 0 riwayat pemindaian"
        const Text(
          'Menampilkan 0 riwayat pemindaian',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF8E8E8E),
          ),
        ),
        const SizedBox(height: 14),

        // Card Putih: "Riwayat Tidak Ditemukan"
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x17002600), // rgba(0, 38, 0, 0.09)
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ilustrasi Kaca Pembesar & Dokumen
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6FBF5),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD6F0D0), width: 1.5),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.find_in_page_outlined,
                        size: 38,
                        color: Color(0xFF178401),
                      ),
                      Positioned(
                        top: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEAEA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFCC0000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Judul: Riwayat Tidak Ditemukan
              const Text(
                'Riwayat Tidak Ditemukan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Penjelasan
              Text(
                'Tidak ada hasil scan dengan kata kunci "$queryText".\nCoba periksa ejaan atau ubah filter pencarian Anda.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.45,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Reset Filter
              OutlinedButton(
                onPressed: _resetAllFilters,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  side: const BorderSide(color: Color(0xFF178401), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Reset Filter',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF178401),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card Tips Pencarian Riwayat Sesuai Screenshot
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12002600),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '💡 Tips Pencarian Riwayat:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              _BulletText(
                text: 'Coba gunakan nama blok kebun seperti "Blok A" atau "Bedeng 01".',
              ),
              SizedBox(height: 4),
              _BulletText(
                text: 'Cari berdasarkan nama penyakit seperti "Early Blight".',
              ),
              SizedBox(height: 4),
              _BulletText(
                text: 'Atur rentang tanggal menjadi "Semua Waktu" untuk melihat riwayat.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Tombol Dropdown Pill (Putih, border halus)
  Widget _buildDropdownPill({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D002600),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Color(0xFF8E8E8E),
            ),
          ],
        ),
      ),
    );
  }

  /// Modal Pemilihan Dropdown Status
  void _showStatusDropdownModal() {
    final statusList = ['Semua Status', 'Sehat', 'Sedang', 'Parah'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Filter Status',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ...statusList.map((s) {
                  final isSelected = _selectedStatusFilter == s;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      s,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF178401) : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF178401))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter = s;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Modal Pemilihan Dropdown Waktu / Periode
  void _showPeriodDropdownModal() {
    final periodList = ['Bulan Ini', 'Semua Waktu', '7 Hari Terakhir', 'Bulan Lalu'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Rentang Waktu',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ...periodList.map((p) {
                  final isSelected = _selectedPeriodFilter == p;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      p,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF178401) : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF178401))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedPeriodFilter = p;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Modal Filter Komprehensif (Header Funnel Icon)
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Filter Riwayat Pemindaian',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Opsi Kategori Penyakit
                    const Text(
                      'Kategori Penyakit:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Semua', 'Early Blight', 'Late Blight', 'Daun Sehat']
                          .map((cat) {
                        final isSel = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: const Color(0xFF178401),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                _selectedCategory = cat;
                              });
                              setState(() {
                                _selectedCategory = cat;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Opsi Status
                    const Text(
                      'Tingkat Keparahan / Status:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Semua Status', 'Sehat', 'Sedang', 'Parah']
                          .map((st) {
                        final isSel = _selectedStatusFilter == st;
                        return ChoiceChip(
                          label: Text(st),
                          selected: isSel,
                          selectedColor: const Color(0xFF178401),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() {
                                _selectedStatusFilter = st;
                              });
                              setState(() {
                                _selectedStatusFilter = st;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Tombol Aksi Filter
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _resetAllFilters();
                              Navigator.pop(ctx);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF178401)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF178401),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF178401),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Terapkan',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Dialog Detail Item Riwayat
  void _showScanDetailDialog(ScanHistoryItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).padding.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF3EDED),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(item.imageAsset, fit: BoxFit.cover),
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.plantName} • ${item.dateTimeText}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF7E7E7E),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: item.badgeBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Status: ${item.status}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: item.badgeTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScanHistoryDetailScreen(item: item),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF178401),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  child: const Text(
                    'Buka Detail Riwayat Pemindaian',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Coba navigasi ke PlantDetailScreen jika tanaman ada
                    final plantProvider =
                        Provider.of<PlantProvider>(context, listen: false);
                    final matchedPlant = plantProvider.plants.firstWhere(
                      (p) => p.name.toLowerCase() == item.plantName.toLowerCase(),
                      orElse: () => PlantModel(
                        id: 'dummy',
                        name: item.plantName,
                        variety: 'Tropis',
                        hst: 63,
                        location: 'Lahan Utama',
                        status: item.status,
                        badgeText: item.diseaseName,
                        imagePath: item.imageAsset,
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlantDetailScreen(plant: matchedPlant),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF178401), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  child: const Text(
                    'Lihat Data Tanaman Ini',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF178401),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Custom BottomNavigationBar sesuai CSS Figma Frame: Riwayat_Scan
  Widget _buildBottomNavBar(double bottomInset) {
    return SizedBox(
      height: 80 + (bottomInset > 0 ? bottomInset - 10 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar Putih
          Container(
            height: 64 + bottomInset,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A002600), // rgba(0, 38, 0, 0.10)
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Row(
              children: [
                // Tab 0: Beranda
                Expanded(
                  child: _buildNavTab(
                    label: 'Beranda',
                    iconAsset: 'assets/custom_assets/icons/ic_home.png',
                    fallbackIcon: Icons.home_rounded,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(0);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                ),

                // Tab 1: Tanaman
                Expanded(
                  child: _buildNavTab(
                    label: 'Tanaman',
                    iconAsset: 'assets/custom_assets/icons/ic_sprout.png',
                    fallbackIcon: Icons.eco_outlined,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(1);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                ),

                // Spacer untuk center FAB (width 72)
                const SizedBox(width: 72),

                // Tab 3: Riwayat (Aktif hijau sesuai CSS #178401)
                Expanded(
                  child: _buildNavTab(
                    label: 'Riwayat',
                    iconAsset: 'assets/custom_assets/icons/ic_clock.png',
                    fallbackIcon: Icons.history_rounded,
                    isActive: true,
                    onTap: () {},
                  ),
                ),

                // Tab 4: Monitor
                Expanded(
                  child: _buildNavTab(
                    label: 'Monitor',
                    iconAsset: 'assets/custom_assets/icons/ic_activity.png',
                    fallbackIcon: Icons.show_chart_rounded,
                    isActive: false,
                    onTap: () {
                      Provider.of<NavigationProvider>(context, listen: false)
                          .setIndex(4);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Center Elevated FAB (Pindai)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF002600).withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          gradient: AppColors.homeFabGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.crop_free_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Pindai',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD91C1C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab({
    required String label,
    required String iconAsset,
    required IconData fallbackIcon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? const Color(0xFF178401) : const Color(0xFF8E8E8E);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconAsset,
            width: 22,
            height: 22,
            color: color,
            errorBuilder: (_, _, _) => Icon(
              fallbackIcon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper Bullet Text untuk Tips Card
class _BulletText extends StatelessWidget {
  final String text;

  const _BulletText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Color(0xFF6B7280),
            height: 1.45,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Color(0xFF6B7280),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
