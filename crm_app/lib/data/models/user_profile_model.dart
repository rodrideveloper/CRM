import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.formToken,
    required super.formEnabled,
    super.plan,
    super.planExpiresAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      formToken: json['form_token'] as String,
      formEnabled: json['form_enabled'] as bool,
      plan: json['plan'] as String? ?? 'free',
      planExpiresAt: json['plan_expires_at'] != null
          ? DateTime.parse(json['plan_expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class UserLimitsModel extends UserLimits {
  const UserLimitsModel({
    required super.plan,
    super.planExpiresAt,
    required super.clientCount,
    required super.clientLimit,
  });

  factory UserLimitsModel.fromJson(Map<String, dynamic> json) {
    return UserLimitsModel(
      plan: json['plan'] as String,
      planExpiresAt: json['plan_expires_at'] != null
          ? DateTime.parse(json['plan_expires_at'] as String)
          : null,
      clientCount: json['client_count'] as int,
      clientLimit: json['client_limit'] as int,
    );
  }
}
