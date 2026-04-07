import 'pipeline_stage_config.dart';

class UserProfile {
  final String id;
  final String formToken;
  final bool formEnabled;
  final String plan;
  final DateTime? planExpiresAt;
  final List<PipelineStageConfig>? pipelineConfig;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.formToken,
    required this.formEnabled,
    this.plan = 'free',
    this.planExpiresAt,
    this.pipelineConfig,
    required this.createdAt,
    required this.updatedAt,
  });

  List<PipelineStageConfig> get activeStages {
    final config = pipelineConfig ?? PipelineStageConfig.defaults;
    return (List<PipelineStageConfig>.from(config)
          ..sort((a, b) => a.position.compareTo(b.position)))
        .where((s) => s.visible)
        .toList();
  }

  List<PipelineStageConfig> get allStages {
    final config = pipelineConfig ?? PipelineStageConfig.defaults;
    return List<PipelineStageConfig>.from(config)
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  bool get isPro => plan == 'pro';
  bool get isFree => plan == 'free';
}

class UserLimits {
  final String plan;
  final DateTime? planExpiresAt;
  final int clientCount;
  final int clientLimit;

  const UserLimits({
    required this.plan,
    this.planExpiresAt,
    required this.clientCount,
    required this.clientLimit,
  });

  bool get isPro => plan == 'pro';
  bool get isFree => plan == 'free';
  bool get isUnlimited => clientLimit == -1;
  bool get canCreateClient => isUnlimited || clientCount < clientLimit;
  int get remaining => isUnlimited ? -1 : clientLimit - clientCount;
}
