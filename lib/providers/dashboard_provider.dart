import 'package:flutter/material.dart';
import '../models/disease_model.dart';
import '../models/diagnosis_history_model.dart';
import '../models/weather_stat_model.dart';

/// Provider data untuk Dashboard Utama MyTimo
class DashboardProvider extends ChangeNotifier {
  WeatherStatModel _weatherStat = const WeatherStatModel(
    location: 'Lembang',
    temperature: '24°C',
    humidity: '76%',
    humidityAlertTitle: 'Kelembapan Tinggi 76% AI',
    humidityBadgeText: 'Waspada Jamur!',
    totalDetections: 24,
    healthyPercentage: 88,
    activeThreatCount: 3,
  );

  final List<DiseaseModel> _diseases = [
    const DiseaseModel(
      id: 'dis_01',
      localName: 'Late Blight',
      scientificName: 'Phytophthora infestans',
      category: 'Jamur',
      description:
          'Penyakit hawar daun dan busuk buah yang disebabkan oleh jamur air Phytophthora. Sangat cepat menyebar pada kelembapan tinggi dan suhu sejuk.',
      treatmentSteps: [
        'Pangkas segera bagian daun atau ranting yang terinfeksi dan jangan jadikan kompos.',
        'Aplikasikan fungisida kontak (mancozeb/tembaga hidroksida) sesuai dosis anjuran.',
        'Tingkatkan sirkulasi udara dengan mengurangi kepadatan kanopi.',
      ],
      preventionSteps: [
        'Gunakan bibit tahan dan perlakuan benih sebelum tanam.',
        'Hindari penyiraman sistem sprinkler/overhead di sore hari.',
        'Lakukan pemantauan rutin saat cuaca lembap atau sering berkabut.',
      ],
      imagePath: 'assets/images/disease_late_blight.webp',
    ),
    const DiseaseModel(
      id: 'dis_02',
      localName: 'Septoria',
      scientificName: 'Septoria lycopersici',
      category: 'Jamur',
      description:
          'Bercak daun berukuran kecil melingkar dengan bagian tengah kelabu dan tepi gelap. Umumnya menyerang daun bagian bawah tanaman tomat.',
      treatmentSteps: [
        'Petik dan musnahkan daun tua yang memiliki bercak septoria.',
        'Gunakan mulsa plastik perak untuk menahan spora dari tanah memercik ke daun.',
        'Semprot fungisida protektif pada daun bagian bawah secara merata.',
      ],
      preventionSteps: [
        'Rotasi tanaman dengan famili selain Solanaceae selama 2-3 tahun.',
        'Jaga jarak tanam ideal minimal 50-60 cm antar tanaman.',
        'Pastikan drainase bedengan mengalir lancar tanpa genangan air.',
      ],
      imagePath: 'assets/images/disease_septoria.webp',
    ),
  ];

  final List<DiagnosisHistoryModel> _recentDiagnoses = [
    const DiagnosisHistoryModel(
      id: 'diag_01',
      title: 'Busuk Buah (Phytophthora)',
      confidence: 96.5,
      timeLabel: 'Hari ini, 09:30',
      locationTag: 'Blok B2',
      isHealthy: false,
      statusText: 'Butuh Obat',
    ),
    const DiagnosisHistoryModel(
      id: 'diag_02',
      title: 'Tanaman Sehat',
      confidence: 99.2,
      timeLabel: 'Kemarin,',
      locationTag: 'Rumah Kaca 1',
      isHealthy: true,
      statusText: 'Sehat',
    ),
  ];

  WeatherStatModel get weatherStat => _weatherStat;
  List<DiseaseModel> get diseases => List.unmodifiable(_diseases);
  List<DiagnosisHistoryModel> get recentDiagnoses => List.unmodifiable(_recentDiagnoses);

  void updateWeatherStat(WeatherStatModel newStat) {
    _weatherStat = newStat;
    notifyListeners();
  }

  void addDiagnosis(DiagnosisHistoryModel diagnosis) {
    _recentDiagnoses.insert(0, diagnosis);
    // Update stats accordingly
    final total = _weatherStat.totalDetections + 1;
    final active = diagnosis.isHealthy
        ? _weatherStat.activeThreatCount
        : _weatherStat.activeThreatCount + 1;
    final healthy = (((total - active) / total) * 100).round();

    _weatherStat = _weatherStat.copyWith(
      totalDetections: total,
      activeThreatCount: active,
      healthyPercentage: healthy,
    );

    notifyListeners();
  }
}
