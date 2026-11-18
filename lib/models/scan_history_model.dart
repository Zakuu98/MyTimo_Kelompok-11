/// Model entitas Riwayat Pemindaian sesuai PRD Bab 2.5 & Desain Baru MyTimo
class ScanHistoryModel {
  final String id;
  final String plantId;
  final String plantName;
  final String imagePath;
  final String timestamp;
  final String inputSource; // 'Kamera' atau 'Galeri'
  final String diseaseDetected; // 'Early Blight', 'Late Blight', 'Sehat', 'Septoria'
  final double confidence; // misal: 94.2
  final String severity; // 'Sedang', 'Parah', 'Sehat'
  final String notes;
  final bool isValidated;
  final DateTime createdAt;

  const ScanHistoryModel({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.imagePath,
    required this.timestamp,
    this.inputSource = 'Kamera',
    required this.diseaseDetected,
    required this.confidence,
    this.severity = 'Sedang',
    this.notes = '',
    this.isValidated = true,
    required this.createdAt,
  });

  bool get isHealthy => diseaseDetected.toLowerCase().contains('sehat');

  String get formattedConfidence => '${confidence.toStringAsFixed(1)}%';

  ScanHistoryModel copyWith({
    String? id,
    String? plantId,
    String? plantName,
    String? imagePath,
    String? timestamp,
    String? inputSource,
    String? diseaseDetected,
    double? confidence,
    String? severity,
    String? notes,
    bool? isValidated,
    DateTime? createdAt,
  }) {
    return ScanHistoryModel(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      plantName: plantName ?? this.plantName,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      inputSource: inputSource ?? this.inputSource,
      diseaseDetected: diseaseDetected ?? this.diseaseDetected,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
      isValidated: isValidated ?? this.isValidated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      plantName: json['plantName'] as String,
      imagePath: json['imagePath'] as String,
      timestamp: json['timestamp'] as String,
      inputSource: (json['inputSource'] as String?) ?? 'Kamera',
      diseaseDetected: json['diseaseDetected'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      severity: (json['severity'] as String?) ?? 'Sedang',
      notes: (json['notes'] as String?) ?? '',
      isValidated: (json['isValidated'] as bool?) ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'plantName': plantName,
      'imagePath': imagePath,
      'timestamp': timestamp,
      'inputSource': inputSource,
      'diseaseDetected': diseaseDetected,
      'confidence': confidence,
      'severity': severity,
      'notes': notes,
      'isValidated': isValidated,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
