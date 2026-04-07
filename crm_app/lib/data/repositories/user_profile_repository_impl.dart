import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/pipeline_stage_config.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final SupabaseClient _client;

  UserProfileRepositoryImpl(this._client);

  @override
  Future<UserProfile> getMyProfile() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();
    return UserProfileModel.fromJson(data);
  }

  @override
  Future<UserLimits> getUserLimits() async {
    final data = await _client.rpc('get_user_limits');
    return UserLimitsModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> savePipelineConfig(List<PipelineStageConfig> config) async {
    final userId = _client.auth.currentUser!.id;
    await _client
        .from('user_profiles')
        .update({'pipeline_config': config.map((s) => s.toJson()).toList()})
        .eq('id', userId);
  }
}
