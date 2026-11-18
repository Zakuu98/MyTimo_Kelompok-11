/// Model entitas Data Tanaman sesuai PRD Bab 2.5 & Desain Baru MyTimo
class PlantModel {
  final String id;
  final String name;
  final String variety;
  final String plantingDate;
  final String location;
  final String initialNotes;
  final String status; // 'Sehat', 'Perlu Rawat', 'Parah', 'Late Blight'
  final int totalScans;
  final String imagePath;
  final DateTime createdAt;

  const PlantModel({
    required this.id,
    required this.name,
    this.variety = '',
    required this.plantingDate,
    required this.location,
    this.initialNotes = '',
    this.status = 'Sehat',
    this.totalScans = 0,
    this.imagePath = 'assets/images/hero_tomatoes.webp',
    required this.createdAt,
  });

  PlantModel copyWith({
    String? id,
    String? name,
    String? variety,
    String? plantingDate,
    String? location,
    String? initialNotes,
    String? status,
    int? totalScans,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      plantingDate: plantingDate ?? this.plantingDate,
      location: location ?? this.location,
      initialNotes: initialNotes ?? this.initialNotes,
      status: status ?? this.status,
      totalScans: totalScans ?? this.totalScans,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      variety: (json['variety'] as String?) ?? '',
      plantingDate: json['plantingDate'] as String,
      location: json['location'] as String,
      initialNotes: (json['initialNotes'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'Sehat',
      totalScans: (json['totalScans'] as num?)?.toInt() ?? 0,
      imagePath: (json['imagePath'] as String?) ?? 'assets/images/hero_tomatoes.webp',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'plantingDate': plantingDate,
      'location': location,
      'initialNotes': initialNotes,
      'status': status,
      'totalScans': totalScans,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
