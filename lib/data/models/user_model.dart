import 'package:equatable/equatable.dart';
import 'role_model.dart';

class UserModel extends Equatable {
  final int id;
  final String email;
  final String? fullName;
  final String? profileImageUrl;
  final String? profileImageBase64;
  final RoleModel role;

  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.profileImageUrl,
    this.profileImageBase64,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      profileImageBase64: json['profile_image_base64'] as String?,
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'profile_image_base64': profileImageBase64,
      'role': role.toJson(),
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? profileImageUrl,
    String? profileImageBase64,
    RoleModel? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        profileImageUrl,
        profileImageBase64,
        role,
      ];

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, fullName: $fullName, role: ${role.name})';
}

class UserCreateModel {
  final String email;
  final String password;
  final String? fullName;
  final String? profileImageUrl;
  final String? profileImageBase64;
  final int roleId;

  const UserCreateModel({
    required this.email,
    required this.password,
    this.fullName,
    this.profileImageUrl,
    this.profileImageBase64,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'profile_image_base64': profileImageBase64,
      'role_id': roleId,
    };
  }
}

class UserUpdateModel {
  final String? fullName;
  final String? profileImageUrl;
  final String? profileImageBase64;

  const UserUpdateModel({
    this.fullName,
    this.profileImageUrl,
    this.profileImageBase64,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['full_name'] = fullName;
    if (profileImageUrl != null) data['profile_image_url'] = profileImageUrl;
    if (profileImageBase64 != null) {
      data['profile_image_base64'] = profileImageBase64;
    }
    return data;
  }
}
