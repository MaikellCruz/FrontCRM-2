import 'package:equatable/equatable.dart';
import 'role_model.dart';

class CategoryModel extends Equatable {
  final int id;
  final String nome;
  final String tipo;
  final String descricao;
  final RoleModel role;
  final int orcamentoId;
  final int clientId;

  const CategoryModel({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.descricao,
    required this.role,
    required this.orcamentoId,
    required this.clientId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      // aceita 'descricao' sem acento ou 'descrição' com acento (servidores diferentes)
      descricao: (json['descricao'] ?? json['descrição'] ?? json['descr'] ) as String,
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
      orcamentoId: json['orcamento_id'] as int,
      clientId: json['client_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      // envia sem acento para maior compatibilidade
      'descricao': descricao,
      'role': role.toJson(),
      'orcamento_id': orcamentoId,
      'client_id': clientId,
    };
  }

  CategoryModel copyWith({
    int? id,
    String? nome,
    String? tipo,
    String? descricao,
    RoleModel? role,
    int? orcamentoId,
    int? clientId,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      role: role ?? this.role,
      orcamentoId: orcamentoId ?? this.orcamentoId,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nome,
        tipo,
        descricao,
        role,
        orcamentoId,
        clientId,
      ];
}

class CategoryCreateModel {
  final String nome;
  final String tipo;
  final String descricao;
  final int roleId;
  final int orcamentoId;
  final int clientId;

  const CategoryCreateModel({
    required this.nome,
    required this.tipo,
    required this.descricao,
    required this.roleId,
    required this.orcamentoId,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'descricao': descricao,
      'role_id': roleId,
      'orcamento_id': orcamentoId,
      'client_id': clientId,
    };
  }
}

class CategoryUpdateModel {
  final String nome;
  final String tipo;
  final String descricao;
  final int orcamentoId;
  final int clientId;

  const CategoryUpdateModel({
    required this.nome,
    required this.tipo,
    required this.descricao,
    required this.orcamentoId,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'descrição': descricao,
      'orcamento_id': orcamentoId,
      'client_id': clientId,
    };
  }
}
