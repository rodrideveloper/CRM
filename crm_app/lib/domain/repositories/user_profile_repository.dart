import '../entities/pipeline_stage_config.dart';
import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getMyProfile();
  Future<UserLimits> getUserLimits();
  Future<void> savePipelineConfig(List<PipelineStageConfig> config);
}
