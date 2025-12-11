import 'package:equatable/equatable.dart';
import 'role_model.dart';

class ClientModel extends Equatable {
  final int id;
  final String email;
  final String? fullName;
  final String? enterpriseName;
  final String? celNumber;
  final String? address;
  final String? profileImageUrl;
  final String? profileImageBase64;
  final RoleModel role;
  final int orcamentoId;
  final int categoryId;

  const ClientModel({
    required this.id,
    required this.email,
    this.fullName,
    this.enterpriseName,
    this.celNumber,
    this.address,
    this.profileImageUrl,
    this.profileImageBase64,
    required this.role,
    required this.orcamentoId,
    required this.categoryId,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      enterpriseName: json['enterprise_name'] as String?,
      celNumber: json['cel_number'] as String?,
      address: json['address'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      profileImageBase64: json['profile_image_base64'] as String?,
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
      orcamentoId: json['orcamento_id'] as int,
      categoryId: json['category_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'enterprise_name': enterpriseName,
      'cel_number': celNumber,
      'address': address,
      'profile_image_url': profileImageUrl,
      'profile_image_base64': profileImageBase64,
      'role': role.toJson(),
      'orcamento_id': orcamentoId,
      'category_id': categoryId,
    };
  }

  ClientModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? enterpriseName,
    String? celNumber,
    String? address,
    String? profileImageUrl,
    String? profileImageBase64,
    RoleModel? role,
    int? orcamentoId,
    int? categoryId,
  }) {
    return ClientModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      enterpriseName: enterpriseName ?? this.enterpriseName,
      celNumber: celNumber ?? this.celNumber,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      role: role ?? this.role,
      orcamentoId: orcamentoId ?? this.orcamentoId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        enterpriseName,
        celNumber,
        address,
        profileImageUrl,
        profileImageBase64,
        role,
        orcamentoId,
        categoryId,
      ];
}

class ClientCreateModel {
  final String email;
  final String password;
  final String? fullName;
  final String? enterpriseName;
  final String? celNumber;
  final String? adress;
  final String? profileImageUrl;
  final String? profileImageBase64;
  final int roleId;
  final int orcamentoId;
  final int categoryId;

  const ClientCreateModel({
    required this.email,
    required this.password,
    this.fullName,
    this.enterpriseName,
    this.celNumber,
    this.adress,
    this.profileImageUrl,
    this.profileImageBase64,
    required this.roleId,
    required this.orcamentoId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'enterprise_name': enterpriseName,
      'cel_number': celNumber,
      'adress': adress,
      'profile_image_url': profileImageUrl,
      'profile_image_base64': profileImageBase64,
      'role_id': roleId,
      'orcamento_id': orcamentoId,
      'category_id': categoryId,
    };
  }
}

class ClientUpdateModel {
  final String email;
  final String? fullName;
  final String? enterpriseName;
  final String? celNumber;
  final String? address;
  final String? profileImageUrl;
  final String? profileImageBase64;
  final int orcamentoId;
  final int categoryId;

  const ClientUpdateModel({
    required this.email,
    this.fullName,
    this.enterpriseName,
    this.celNumber,
    this.address,
    this.profileImageUrl,
    this.profileImageBase64,
    required this.orcamentoId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'enterprise_name': enterpriseName,
      'cel_number': celNumber,
      'address': address,
      'profile_image_url': profileImageUrl,
      'profile_image_base64': profileImageBase64,
      'orcamento_id': orcamentoId,
      'category_id': categoryId,
    };
  }
}
