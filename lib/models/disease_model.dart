/// Model entitas Data Penyakit sesuai PRD Bab 2.5
class DiseaseModel {
  final String id;
  final String localName;
  final String scientificName;
  final String category;
  final String description;
  final List<String> treatmentSteps;
  final List<String> preventionSteps;
  final String imagePath;

  const DiseaseModel({
    required this.id,
    required this.localName,
    required this.scientificName,
    required this.category,
    required this.description,
    required this.treatmentSteps,
    required this.preventionSteps,
    required this.imagePath,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] as String,
      localName: json['localName'] as String,
      scientificName: json['scientificName'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      treatmentSteps: List<String>.from(json['treatmentSteps'] as List),
      preventionSteps: List<String>.from(json['preventionSteps'] as List),
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localName': localName,
      'scientificName': scientificName,
      'category': category,
      'description': description,
      'treatmentSteps': treatmentSteps,
      'preventionSteps': preventionSteps,
      'imagePath': imagePath,
    };
  }
}
