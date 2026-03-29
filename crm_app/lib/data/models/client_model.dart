import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.userId,
    required super.name,
    super.phone,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      status: ClientStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static Map<String, dynamic> toInsertJson({
    required String userId,
    required String name,
    String? phone,
  }) {
    return {'user_id': userId, 'name': name, if (phone != null) 'phone': phone};
  }

  static Map<String, dynamic> toUpdateJson({
    String? name,
    String? phone,
    ClientStatus? status,
  }) {
    return {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (status != null) 'status': status.value,
    };
  }
}
