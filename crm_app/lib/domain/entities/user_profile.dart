class UserProfile {
  final String id;
  final String formToken;
  final bool formEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.formToken,
    required this.formEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
}
