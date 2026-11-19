import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Model entitas Data Tanaman tomat sesuai Desain Figma Frame: plant_list
class PlantModel {
  final String id;
  final String name;
  final String variety;
  final int hst; // Hari Setelah Tanam
  final String location;
  final String status; // 'Sehat', 'Perlu Rawat', 'Parah'
  final String badgeText; // 'Early Blight', 'Sehat', 'Late Blight', dll.
  final String imagePath;
  final bool isNew; // Penanda untuk data yang baru ditambahkan
  final String? plantingDate; // Tanggal tanam
  final String? notes; // Catatan awal

  const PlantModel({
    required this.id,
    required this.name,
    required this.variety,
    required this.hst,
    required this.location,
    required this.status,
    required this.badgeText,
    required this.imagePath,
    this.isNew = false,
    this.plantingDate,
    this.notes,
  });

  /// Warna latar belakang badge diagnosis
  Color get badgeBgColor {
    switch (badgeText.toLowerCase()) {
      case 'sehat':
        return AppColors.plantBadgeSehatBg;
      case 'early blight':
        return AppColors.plantBadgeEarlyBlightBg;
      case 'late blight':
      case 'septoria':
        return AppColors.plantBadgeLateBlightBg;
      default:
        if (status.toLowerCase() == 'sehat') {
          return AppColors.plantBadgeSehatBg;
        } else if (status.toLowerCase() == 'perlu rawat') {
          return AppColors.plantBadgeEarlyBlightBg;
        } else {
          return AppColors.plantBadgeLateBlightBg;
        }
    }
  }

  /// Warna teks badge diagnosis
  Color get badgeTextColor {
    switch (badgeText.toLowerCase()) {
      case 'sehat':
        return AppColors.plantBadgeSehatText;
      case 'early blight':
        return AppColors.plantBadgeEarlyBlightText;
      case 'late blight':
      case 'septoria':
        return AppColors.plantBadgeLateBlightText;
      default:
        if (status.toLowerCase() == 'sehat') {
          return AppColors.plantBadgeSehatText;
        } else if (status.toLowerCase() == 'perlu rawat') {
          return AppColors.plantBadgeEarlyBlightText;
        } else {
          return AppColors.plantBadgeLateBlightText;
        }
    }
  }

  PlantModel copyWith({
    String? id,
    String? name,
    String? variety,
    int? hst,
    String? location,
    String? status,
    String? badgeText,
    String? imagePath,
    bool? isNew,
    String? plantingDate,
    String? notes,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      hst: hst ?? this.hst,
      location: location ?? this.location,
      status: status ?? this.status,
      badgeText: badgeText ?? this.badgeText,
      imagePath: imagePath ?? this.imagePath,
      isNew: isNew ?? this.isNew,
      plantingDate: plantingDate ?? this.plantingDate,
      notes: notes ?? this.notes,
    );
  }

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      variety: json['variety'] as String,
      hst: json['hst'] as int,
      location: json['location'] as String,
      status: json['status'] as String,
      badgeText: json['badgeText'] as String,
      imagePath: json['imagePath'] as String,
      isNew: json['isNew'] as bool? ?? false,
      plantingDate: json['plantingDate'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'hst': hst,
      'location': location,
      'status': status,
      'badgeText': badgeText,
      'imagePath': imagePath,
      'isNew': isNew,
      'plantingDate': plantingDate,
      'notes': notes,
    };
  }
}
