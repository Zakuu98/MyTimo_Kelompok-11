import 'package:flutter/material.dart';
import '../models/plant_model.dart';

/// Provider data untuk Halaman Daftar Tanaman (plant_list)
/// Mengelola daftar tanaman, filter chip ('Semua', 'Sehat', 'Perlu Rawat', 'Parah'),
/// pencarian, serta transisi antara State Data Dummy & State Kosong (Empty State).
class PlantProvider extends ChangeNotifier {
  // Data dummy awal sesuai Figma Frame: plant_list
  static const List<PlantModel> _initialDummyPlants = [
    PlantModel(
      id: 'plt_01',
      name: 'Tomat Cherry Blok A',
      variety: 'Cherry Tropis',
      hst: 63,
      location: 'Greenhouse 1 • Rak B3',
      status: 'Perlu Rawat',
      badgeText: 'Early Blight',
      imagePath: 'assets/custom_assets/images/jamur_septoria.png',
      plantingDate: '05 Agustus 2026',
      notes: 'Daun bawah mulai membaik pasca pemangkasan.',
    ),
    PlantModel(
      id: 'plt_02',
      name: 'Tomat Servo Bedeng 1',
      variety: 'Servo F1',
      hst: 25,
      location: 'Lahan Terbuka • Bedeng 01',
      status: 'Sehat',
      badgeText: 'Sehat',
      imagePath: 'assets/images/hero_tomatoes.webp',
    ),
    PlantModel(
      id: 'plt_03',
      name: 'Tomat Mawar Bedeng 4',
      variety: 'Mawar Lokal',
      hst: 50,
      location: 'Lahan Terbuka • Bedeng 04',
      status: 'Parah',
      badgeText: 'Late Blight',
      imagePath: 'assets/custom_assets/images/jamur_septoria.png',
    ),
    PlantModel(
      id: 'plt_04',
      name: 'Tomat Sayur Blok C',
      variety: 'Gustavi F1',
      hst: 22,
      location: 'Lahan Timur • Bedeng 02',
      status: 'Sehat',
      badgeText: 'Sehat',
      imagePath: 'assets/images/hero_tomatoes.webp',
    ),
  ];

  late List<PlantModel> _plants;
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  PlantProvider() {
    _plants = List<PlantModel>.from(_initialDummyPlants);
  }

  List<PlantModel> get plants => List.unmodifiable(_plants);
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  /// Daftar tanaman yang sudah difilter berdasarkan pencarian teks dan chip status
  List<PlantModel> get filteredPlants {
    return _plants.where((plant) {
      // 1. Pencarian teks
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          plant.name.toLowerCase().contains(query) ||
          plant.variety.toLowerCase().contains(query) ||
          plant.location.toLowerCase().contains(query) ||
          plant.badgeText.toLowerCase().contains(query);

      // 2. Filter chip
      final filter = _selectedFilter.toLowerCase();
      final matchesFilter = filter == 'semua' ||
          plant.status.toLowerCase() == filter;

      return matchesQuery && matchesFilter;
    }).toList();
  }

  /// Menghitung jumlah tanaman berdasarkan filter
  int countByFilter(String filter) {
    final f = filter.toLowerCase();
    if (f == 'semua') return _plants.length;
    return _plants.where((p) => p.status.toLowerCase() == f).length;
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void setSelectedFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  /// Tambah tanaman baru
  void addPlant(PlantModel plant) {
    _plants.insert(0, plant);
    notifyListeners();
  }

  /// Perbarui data tanaman yang sudah ada
  void updatePlant(PlantModel updatedPlant) {
    final index = _plants.indexWhere((p) => p.id == updatedPlant.id);
    if (index != -1) {
      _plants[index] = updatedPlant;
      notifyListeners();
    }
  }

  /// Hapus tanaman tertentu
  void deletePlant(String id) {
    _plants.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Kosongkan semua data tanaman (untuk testing Empty State / User baru)
  void clearAllPlants() {
    _plants.clear();
    notifyListeners();
  }

  /// Kembalikan data dummy awal
  void resetToDefault() {
    _plants = List<PlantModel>.from(_initialDummyPlants);
    _searchQuery = '';
    _selectedFilter = 'Semua';
    notifyListeners();
  }
}
