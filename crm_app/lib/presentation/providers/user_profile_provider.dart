import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import 'repository_providers.dart';

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.read(userProfileRepositoryProvider).getMyProfile();
});

final userLimitsProvider = FutureProvider<UserLimits>((ref) async {
  return ref.read(userProfileRepositoryProvider).getUserLimits();
});
