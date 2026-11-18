// Model untuk modul Treatment & Prevention Management
// Anggota 3: Athaya Nasywa Mahira - 2411523028

// ===========================================================================
// Enums
// ===========================================================================

enum TreatmentStatus {
  belumDimulai,
  sedangBerjalan,
  selesai,
  dibatalkan,
}

extension TreatmentStatusExt on TreatmentStatus {
  String get label {
    switch (this) {
      case TreatmentStatus.belumDimulai:
        return 'Belum Dimulai';
      case TreatmentStatus.sedangBerjalan:
        return 'Aktif';
      case TreatmentStatus.selesai:
        return 'Selesai';
      case TreatmentStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }
}

enum TreatmentPriority { rendah, sedang, tinggi, mendesak }

extension TreatmentPriorityExt on TreatmentPriority {
  String get label {
    switch (this) {
      case TreatmentPriority.rendah:
        return 'Rendah';
      case TreatmentPriority.sedang:
        return 'Sedang';
      case TreatmentPriority.tinggi:
        return 'Tinggi';
      case TreatmentPriority.mendesak:
        return 'Mendesak';
    }
  }
}

// ===========================================================================
// TreatmentStep
// ===========================================================================

class TreatmentStep {
  final String id;
  final String description;
  final bool isCompleted;
  final DateTime? completedAt;

  const TreatmentStep({
    required this.id,
    required this.description,
    this.isCompleted = false,
    this.completedAt,
  });

  TreatmentStep copyWith({
    String? id,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TreatmentStep(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// ===========================================================================
// TreatmentPlan
// ===========================================================================

class TreatmentPlan {
  final String id;
  final String plantName;
  final String diseaseName;
  final String? diagnosisId;
  final DateTime createdAt;
  final DateTime targetDate;
  final TreatmentStatus status;
  final TreatmentPriority priority;
  final List<TreatmentStep> steps;
  final String notes;

  const TreatmentPlan({
    required this.id,
    required this.plantName,
    required this.diseaseName,
    this.diagnosisId,
    required this.createdAt,
    required this.targetDate,
    this.status = TreatmentStatus.belumDimulai,
    this.priority = TreatmentPriority.sedang,
    this.steps = const [],
    this.notes = '',
  });

  TreatmentPlan copyWith({
    String? id,
    String? plantName,
    String? diseaseName,
    String? diagnosisId,
    DateTime? createdAt,
    DateTime? targetDate,
    TreatmentStatus? status,
    TreatmentPriority? priority,
    List<TreatmentStep>? steps,
    String? notes,
  }) {
    return TreatmentPlan(
      id: id ?? this.id,
      plantName: plantName ?? this.plantName,
      diseaseName: diseaseName ?? this.diseaseName,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      createdAt: createdAt ?? this.createdAt,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      steps: steps ?? this.steps,
      notes: notes ?? this.notes,
    );
  }

  int get completedSteps => steps.where((s) => s.isCompleted).length;
  int get totalSteps => steps.length;
  double get progressPercent =>
      totalSteps == 0 ? 0.0 : completedSteps / totalSteps;

  bool get isOverdue =>
      targetDate.isBefore(DateTime.now()) &&
      status != TreatmentStatus.selesai &&
      status != TreatmentStatus.dibatalkan;
}

// ===========================================================================
// TreatmentProgress
// ===========================================================================

class TreatmentProgress {
  final String planId;
  final int completedSteps;
  final int totalSteps;
  final DateTime lastUpdated;

  const TreatmentProgress({
    required this.planId,
    required this.completedSteps,
    required this.totalSteps,
    required this.lastUpdated,
  });

  double get progressPercent {
    if (totalSteps == 0) return 0.0;
    return (completedSteps / totalSteps * 100).clamp(0.0, 100.0);
  }
}

// ===========================================================================
// Dummy / Mock Data
// ===========================================================================

class TreatmentDummyData {
  TreatmentDummyData._();

  static List<TreatmentPlan> get samplePlans => [
        TreatmentPlan(
          id: 'tp-001',
          plantName: 'Tomat Cherry Blok A',
          diseaseName: 'Bercak Kering (Early Blight)',
          diagnosisId: 'diag-001',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          targetDate: DateTime.now().add(const Duration(days: 10)),
          status: TreatmentStatus.sedangBerjalan,
          priority: TreatmentPriority.tinggi,
          notes:
              'Tanaman menunjukkan gejala bercak coklat pada daun bawah. Perlu penanganan segera.',
          steps: [
            TreatmentStep(
              id: 'step-001-1',
              description:
                  'Cabut dan buang daun yang terinfeksi parah dari tanaman',
              isCompleted: true,
              completedAt: DateTime.now().subtract(const Duration(days: 4)),
            ),
            TreatmentStep(
              id: 'step-001-2',
              description:
                  'Semprot fungisida berbahan aktif klorotalonil setiap 7 hari',
              isCompleted: true,
              completedAt: DateTime.now().subtract(const Duration(days: 2)),
            ),
            const TreatmentStep(
              id: 'step-001-3',
              description:
                  'Kurangi penyiraman dari atas, ganti dengan drip irrigation',
              isCompleted: false,
            ),
            const TreatmentStep(
              id: 'step-001-4',
              description:
                  'Tambahkan mulsa di sekitar tanaman untuk mencegah percikan tanah',
              isCompleted: false,
            ),
            const TreatmentStep(
              id: 'step-001-5',
              description: 'Monitor perkembangan penyakit setiap 3 hari',
              isCompleted: false,
            ),
          ],
        ),
        TreatmentPlan(
          id: 'tp-002',
          plantName: 'Tomat Mawar Bedeng 4',
          diseaseName: 'Busuk Daun (Late Blight)',
          diagnosisId: 'diag-003',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          targetDate: DateTime.now().subtract(const Duration(days: 2)),
          status: TreatmentStatus.selesai,
          priority: TreatmentPriority.mendesak,
          notes:
              'Penyakit menyebar cepat akibat cuaca lembab. Penanganan berhasil menghentikan penyebaran.',
          steps: [
            TreatmentStep(
              id: 'step-002-1',
              description: 'Isolasi tanaman yang terinfeksi',
              isCompleted: true,
              completedAt: DateTime.now().subtract(const Duration(days: 14)),
            ),
            TreatmentStep(
              id: 'step-002-2',
              description: 'Aplikasi fungisida sistemik metalaksil 2g/L',
              isCompleted: true,
              completedAt: DateTime.now().subtract(const Duration(days: 12)),
            ),
            TreatmentStep(
              id: 'step-002-3',
              description: 'Perbaiki sirkulasi udara antar tanaman',
              isCompleted: true,
              completedAt: DateTime.now().subtract(const Duration(days: 10)),
            ),
          ],
        ),
        TreatmentPlan(
          id: 'tp-003',
          plantName: 'Tomat Servo Bedeng 1',
          diseaseName: 'Bercak Bakteri (Bacterial Spot)',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          targetDate: DateTime.now().add(const Duration(days: 14)),
          status: TreatmentStatus.belumDimulai,
          priority: TreatmentPriority.rendah,
          notes: 'Gejala masih awal, perlu pengamatan lebih lanjut.',
          steps: [
            const TreatmentStep(
              id: 'step-003-1',
              description: 'Semprot bakterisida berbahan aktif tembaga',
              isCompleted: false,
            ),
            const TreatmentStep(
              id: 'step-003-2',
              description: 'Hindari penyiraman dari atas pada sore hari',
              isCompleted: false,
            ),
            const TreatmentStep(
              id: 'step-003-3',
              description: 'Sterilkan alat pertanian sebelum digunakan',
              isCompleted: false,
            ),
          ],
        ),
      ];
}

