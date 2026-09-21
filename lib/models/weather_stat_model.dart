/// Model informasi cuaca dan ringkasan metrik dashboard
class WeatherStatModel {
  final String location;
  final String temperature;
  final String humidity;
  final String humidityAlertTitle;
  final String humidityBadgeText;
  final int totalDetections;
  final int healthyPercentage;
  final int activeThreatCount;

  const WeatherStatModel({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.humidityAlertTitle,
    required this.humidityBadgeText,
    required this.totalDetections,
    required this.healthyPercentage,
    required this.activeThreatCount,
  });

  WeatherStatModel copyWith({
    String? location,
    String? temperature,
    String? humidity,
    String? humidityAlertTitle,
    String? humidityBadgeText,
    int? totalDetections,
    int? healthyPercentage,
    int? activeThreatCount,
  }) {
    return WeatherStatModel(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      humidityAlertTitle: humidityAlertTitle ?? this.humidityAlertTitle,
      humidityBadgeText: humidityBadgeText ?? this.humidityBadgeText,
      totalDetections: totalDetections ?? this.totalDetections,
      healthyPercentage: healthyPercentage ?? this.healthyPercentage,
      activeThreatCount: activeThreatCount ?? this.activeThreatCount,
    );
  }
}
