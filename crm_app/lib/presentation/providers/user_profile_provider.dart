import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pipeline_stage_config.dart';
import '../../domain/entities/user_profile.dart';
import 'repository_providers.dart';

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.read(userProfileRepositoryProvider).getMyProfile();
});

final userLimitsProvider = FutureProvider<UserLimits>((ref) async {
  return ref.read(userProfileRepositoryProvider).getUserLimits();
});

/// Active (visible + sorted) pipeline stages for the current user.
final pipelineStagesProvider = Provider<List<PipelineStageConfig>>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.whenOrNull(data: (p) => p.activeStages) ??
      PipelineStageConfig.defaults;
});

/// All pipeline stages (including hidden) for settings screen.
final allPipelineStagesProvider = Provider<List<PipelineStageConfig>>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.whenOrNull(data: (p) => p.allStages) ??
      PipelineStageConfig.defaults;
});
