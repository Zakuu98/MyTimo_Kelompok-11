import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../models/scan_history_model.dart';

/// Provider pengelola Data Tanaman & Riwayat Pemindaian sesuai PRD Modul 1
class PlantProvider extends ChangeNotifier {
  // In-Memory Database Tanaman
  final List<PlantModel> _plants = [
    PlantModel(
      id: 'PLT-001',
      name: 'Tomat Cherry Blok A',
      variety: 'Cherry Tropic',
      plantingDate: '05 Agustus 2026',
      location: 'Greenhouse 1 - B3',
      initialNotes: 'Daun bawah mulai membusuk pasca pemangkasan.',
      status: 'Sehat',
      totalScans: 5,
      createdAt: DateTime(2026, 8, 5),
    ),
    PlantModel(
      id: 'PLT-002',
      name: 'Tomat Servo Bedeng 1',
      variety: 'Servo F1',
      plantingDate: '10 Agustus 2026',
      location: 'Lahan Terbuka 1 • Bedeng B2',
      initialNotes: 'Pertumbuhan vegetatif sangat baik.',
      status: 'Sehat',
      totalScans: 3,
      createdAt: DateTime(2026, 8, 10),
    ),
    PlantModel(
      id: 'PLT-003',
      name: 'Tomat Mawar Bedeng 4',
      variety: 'Mawar Lokal',
      plantingDate: '18 Agustus 2026',
      location: 'Lahan Terbuka 1 • Bedeng B4',
      initialNotes: 'Ada indikasi bercak hawar daun di daun tua.',
      status: 'Late Blight',
      totalScans: 4,
      createdAt: DateTime(2026, 8, 18),
    ),
    PlantModel(
      id: 'PLT-004',
      name: 'Tomat Sayur Blok C',
      variety: 'Sayur F1',
      plantingDate: '20 Agustus 2026',
      location: 'Lahan Terbuka 1 • Bedeng B3',
      initialNotes: 'Bibit semai 20 hari, media tanah-kompos organik.',
      status: 'Sehat',
      totalScans: 2,
      createdAt: DateTime(2026, 8, 20),
    ),
  ];

  // In-Memory Database Riwayat Pemindaian
  final List<ScanHistoryModel> _scans = [
    ScanHistoryModel(
      id: 'SCN-001',
      plantId: 'PLT-001',
      plantName: 'Tomat Cherry Blok A',
      imagePath: 'assets/images/disease_late_blight.webp',
      timestamp: '06 Okt 2026, 14:25',
      inputSource: 'Kamera',
      diseaseDetected: 'Early Blight',
      confidence: 94.2,
      severity: 'Sedang',
      notes: 'Bercak daun muncul di 2 helai daun bagian bawah, segera pangkas dan semprot fungisida tembaga.',
      createdAt: DateTime(2026, 10, 6, 14, 25),
    ),
    ScanHistoryModel(
      id: 'SCN-002',
      plantId: 'PLT-002',
      plantName: 'Tomat Servo Bedeng 1',
      imagePath: 'assets/images/disease_septoria.webp',
      timestamp: '05 Okt 2026, 09:12',
      inputSource: 'Kamera',
      diseaseDetected: 'Tanaman Sehat',
      confidence: 98.6,
      severity: 'Sehat',
      notes: 'Kondisi daun hijau segar tanpa gejala bercak atau nekrosis.',
      createdAt: DateTime(2026, 10, 5, 9, 12),
    ),
    ScanHistoryModel(
      id: 'SCN-003',
      plantId: 'PLT-003',
      plantName: 'Tomat Mawar Bedeng 4',
      imagePath: 'assets/images/disease_late_blight.webp',
      timestamp: '01 Okt 2026, 16:30',
      inputSource: 'Galeri',
      diseaseDetected: 'Late Blight',
      confidence: 99.1,
      severity: 'Parah',
      notes: 'Hawar daun parah disertai busuk basah kecokelatan pada tangkai daun.',
      createdAt: DateTime(2026, 10, 1, 16, 30),
    ),
    ScanHistoryModel(
      id: 'SCN-004',
      plantId: 'PLT-001',
      plantName: 'Tomat Cherry Blok A',
      imagePath: 'assets/images/disease_septoria.webp',
      timestamp: '28 Sep 2026, 11:05',
      inputSource: 'Kamera',
      diseaseDetected: 'Daun Sehat',
      confidence: 99.1,
      severity: 'Sehat',
      notes: 'Pemeriksaan awal pasca pemupukan kedua.',
      createdAt: DateTime(2026, 9, 28, 11, 5),
    ),
  ];

  // Search & Filter State untuk Tanaman
  String _plantSearchQuery = '';
  String _plantStatusFilter = 'Semua';

  // Search & Filter State untuk Riwayat
  String _scanSearchQuery = '';
  String _scanDiseaseFilter = 'Semua';

  // State draft pemindaian aktif
  String? _selectedPlantIdForScan;

  // Getters
  List<PlantModel> get allPlants => List.unmodifiable(_plants);
  List<ScanHistoryModel> get allScans => List.unmodifiable(_scans);
  String? get selectedPlantIdForScan => _selectedPlantIdForScan;
  String get plantStatusFilter => _plantStatusFilter;
  String get scanDiseaseFilter => _scanDiseaseFilter;

  // Filtered Plants
  List<PlantModel> get filteredPlants {
    return _plants.where((plant) {
      final matchesQuery = _plantSearchQuery.isEmpty ||
          plant.name.toLowerCase().contains(_plantSearchQuery.toLowerCase()) ||
          plant.location.toLowerCase().contains(_plantSearchQuery.toLowerCase()) ||
          plant.variety.toLowerCase().contains(_plantSearchQuery.toLowerCase());

      final matchesStatus = _plantStatusFilter == 'Semua' ||
          plant.status.toLowerCase() == _plantStatusFilter.toLowerCase();

      return matchesQuery && matchesStatus;
    }).toList();
  }

  // Filtered Scans
  List<ScanHistoryModel> get filteredScans {
    return _scans.where((scan) {
      final matchesQuery = _scanSearchQuery.isEmpty ||
          scan.plantName.toLowerCase().contains(_scanSearchQuery.toLowerCase()) ||
          scan.diseaseDetected.toLowerCase().contains(_scanSearchQuery.toLowerCase()) ||
          scan.timestamp.toLowerCase().contains(_scanSearchQuery.toLowerCase());

      final matchesFilter = _scanDiseaseFilter == 'Semua' ||
          scan.diseaseDetected.toLowerCase().contains(_scanDiseaseFilter.toLowerCase()) ||
          scan.severity.toLowerCase() == _scanDiseaseFilter.toLowerCase();

      return matchesQuery && matchesFilter;
    }).toList();
  }

  // Setters Filter Tanaman
  void setPlantSearchQuery(String query) {
    _plantSearchQuery = query;
    notifyListeners();
  }

  void setPlantStatusFilter(String filter) {
    _plantStatusFilter = filter;
    notifyListeners();
  }

  // Setters Filter Riwayat
  void setScanSearchQuery(String query) {
    _scanSearchQuery = query;
    notifyListeners();
  }

  void setScanDiseaseFilter(String filter) {
    _scanDiseaseFilter = filter;
    notifyListeners();
  }

  void resetScanFilter() {
    _scanSearchQuery = '';
    _scanDiseaseFilter = 'Semua';
    notifyListeners();
  }

  void setSelectedPlantForScan(String? plantId) {
    _selectedPlantIdForScan = plantId;
    notifyListeners();
  }

  PlantModel? getPlantById(String id) {
    try {
      return _plants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  ScanHistoryModel? getScanById(String id) {
    try {
      return _scans.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ScanHistoryModel> getScansForPlant(String plantId) {
    return _scans.where((s) => s.plantId == plantId).toList();
  }

  ScanHistoryModel? getLatestScanForPlant(String plantId) {
    final plantScans = getScansForPlant(plantId);
    if (plantScans.isEmpty) return null;
    return plantScans.first;
  }

  // CRUD Tanaman
  void addPlant(PlantModel plant) {
    _plants.insert(0, plant);
    notifyListeners();
  }

  void updatePlant(PlantModel updatedPlant) {
    final index = _plants.indexWhere((p) => p.id == updatedPlant.id);
    if (index != -1) {
      _plants[index] = updatedPlant;
      // Perbarui juga nama tanaman di riwayat terkait jika berubah
      for (int i = 0; i < _scans.length; i++) {
        if (_scans[i].plantId == updatedPlant.id) {
          _scans[i] = _scans[i].copyWith(plantName: updatedPlant.name);
        }
      }
      notifyListeners();
    }
  }

  void deletePlant(String plantId) {
    _plants.removeWhere((p) => p.id == plantId);
    // Opsional: Hapus atau tandai riwayat terkait
    _scans.removeWhere((s) => s.plantId == plantId);
    if (_selectedPlantIdForScan == plantId) {
      _selectedPlantIdForScan = null;
    }
    notifyListeners();
  }

  // CRUD Riwayat Pemindaian
  void addScan(ScanHistoryModel scan) {
    _scans.insert(0, scan);

    // Update totalScans pada tanaman terkait
    final plantIndex = _plants.indexWhere((p) => p.id == scan.plantId);
    if (plantIndex != -1) {
      final currentPlant = _plants[plantIndex];
      _plants[plantIndex] = currentPlant.copyWith(
        totalScans: currentPlant.totalScans + 1,
        status: scan.isHealthy ? 'Sehat' : (scan.severity == 'Parah' ? 'Parah' : 'Perlu Rawat'),
      );
    }

    notifyListeners();
  }

  void updateScanNotes(String scanId, String newNotes) {
    final index = _scans.indexWhere((s) => s.id == scanId);
    if (index != -1) {
      _scans[index] = _scans[index].copyWith(notes: newNotes);
      notifyListeners();
    }
  }

  void deleteScan(String scanId) {
    final scan = getScanById(scanId);
    if (scan != null) {
      _scans.removeWhere((s) => s.id == scanId);

      // Decrement totalScans pada tanaman terkait
      final plantIndex = _plants.indexWhere((p) => p.id == scan.plantId);
      if (plantIndex != -1) {
        final currentPlant = _plants[plantIndex];
        final remainingScans = getScansForPlant(scan.plantId);
        _plants[plantIndex] = currentPlant.copyWith(
          totalScans: currentPlant.totalScans > 0 ? currentPlant.totalScans - 1 : 0,
          status: remainingScans.isEmpty
              ? 'Sehat'
              : (remainingScans.first.isHealthy ? 'Sehat' : 'Perlu Rawat'),
        );
      }

      notifyListeners();
    }
  }
}
