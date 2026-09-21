/// Model entitas Riwayat Diagnosa sesuai PRD Bab 2.5 & Desain Figma
class DiagnosisHistoryModel {
  final String id;
  final String title;
  final double confidence;
  final String timeLabel;
  final String locationTag;
  final bool isHealthy;
  final String statusText;

  const DiagnosisHistoryModel({
    required this.id,
    required this.title,
    required this.confidence,
    required this.timeLabel,
    required this.locationTag,
    required this.isHealthy,
    required this.statusText,
  });

  String get formattedSubtitle => '$timeLabel $locationTag';
  String get formattedBadge => '${confidence.toStringAsFixed(1)}% $statusText';

  factory DiagnosisHistoryModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisHistoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timeLabel: json['timeLabel'] as String,
      locationTag: json['locationTag'] as String,
      isHealthy: json['isHealthy'] as bool,
      statusText: json['statusText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'confidence': confidence,
      'timeLabel': timeLabel,
      'locationTag': locationTag,
      'isHealthy': isHealthy,
      'statusText': statusText,
    };
  }
}
