import 'package:equatable/equatable.dart';

class OrcamentoModel extends Equatable {
  final int id;
  final String name;
  final double value;
  final int? date;
  final String descr;
  final int clientId;
  final int categoryId;

  const OrcamentoModel({
    required this.id,
    required this.name,
    required this.value,
    this.date,
    required this.descr,
    required this.clientId,
    required this.categoryId,
  });

  factory OrcamentoModel.fromJson(Map<String, dynamic> json) {
    return OrcamentoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      date: json['date'] as int?,
      descr: json['descr'] as String,
      clientId: json['client_id'] as int,
      categoryId: json['category_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'date': date,
      'descr': descr,
      'client_id': clientId,
      'category_id': categoryId,
    };
  }

  OrcamentoModel copyWith({
    int? id,
    String? name,
    double? value,
    int? date,
    String? descr,
    int? clientId,
    int? categoryId,
  }) {
    return OrcamentoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      date: date ?? this.date,
      descr: descr ?? this.descr,
      clientId: clientId ?? this.clientId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        date,
        descr,
        clientId,
        categoryId,
      ];
}

class OrcamentoCreateModel {
  final String name;
  final double value;
  final int date;
  final String descr;
  final int clientId;
  final int categoryId;

  const OrcamentoCreateModel({
    required this.name,
    required this.value,
    required this.date,
    required this.descr,
    required this.clientId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'date': date,
      'descr': descr,
      'client_id': clientId,
      'category_id': categoryId,
    };
  }
}

class OrcamentoUpdateModel {
  final String name;
  final double value;
  final int date;
  final String descr;
  final int clientId;
  final int categoryId;

  const OrcamentoUpdateModel({
    required this.name,
    required this.value,
    required this.date,
    required this.descr,
    required this.clientId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'date': date,
      'descr': descr,
      'client_id': clientId,
      'category_id': categoryId,
    };
  }
}
