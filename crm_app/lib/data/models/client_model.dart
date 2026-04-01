import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.userId,
    required super.name,
    super.phone,
    super.email,
    super.company,
    super.source,
    required super.status,
    super.dealValue,
    super.currency,
    super.nextFollowUp,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      company: json['company'] as String?,
      source: json['source'] as String?,
      status: ClientStatus.fromString(json['status'] as String),
      dealValue: json['deal_value'] != null
          ? (json['deal_value'] as num).toDouble()
          : null,
      currency: json['currency'] as String?,
      nextFollowUp: json['next_follow_up'] != null
          ? DateTime.parse(json['next_follow_up'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static Map<String, dynamic> toInsertJson({
    required String userId,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? source,
    double? dealValue,
    String? currency,
  }) {
    return {
      'user_id': userId,
      'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (company != null) 'company': company,
      if (source != null) 'source': source,
      if (dealValue != null) 'deal_value': dealValue,
      if (currency != null) 'currency': currency,
    };
  }

  static Map<String, dynamic> toUpdateJson({
    String? name,
    String? phone,
    String? email,
    String? company,
    String? source,
    ClientStatus? status,
    double? dealValue,
    String? currency,
    bool clearDealValue = false,
    DateTime? nextFollowUp,
    bool clearFollowUp = false,
  }) {
    return {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (company != null) 'company': company,
      if (source != null) 'source': source,
      if (status != null) 'status': status.value,
      if (clearDealValue) 'deal_value': null,
      if (dealValue != null) 'deal_value': dealValue,
      if (currency != null) 'currency': currency,
      if (clearFollowUp) 'next_follow_up': null,
      if (nextFollowUp != null)
        'next_follow_up': nextFollowUp.toIso8601String(),
    };
  }
}
