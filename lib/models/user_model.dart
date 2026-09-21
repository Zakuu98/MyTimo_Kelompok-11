/// Model data Petani / Pengguna MyTimo
class UserModel {
  final String id;
  final String name;
  final String email;
  final String farmLocation;
  final String avatarPath;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.farmLocation,
    required this.avatarPath,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? farmLocation,
    String? avatarPath,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      farmLocation: farmLocation ?? this.farmLocation,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      farmLocation: json['farmLocation'] as String,
      avatarPath: json['avatarPath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'farmLocation': farmLocation,
      'avatarPath': avatarPath,
    };
  }
}
