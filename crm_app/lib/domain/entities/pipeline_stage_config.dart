import 'client.dart';

class PipelineStageConfig {
  final String key;
  final String label;
  final bool visible;
  final int position;

  const PipelineStageConfig({
    required this.key,
    required this.label,
    required this.visible,
    required this.position,
  });

  PipelineStageConfig copyWith({String? label, bool? visible, int? position}) {
    return PipelineStageConfig(
      key: key,
      label: label ?? this.label,
      visible: visible ?? this.visible,
      position: position ?? this.position,
    );
  }

  ClientStatus get status => ClientStatus.fromString(key);

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'visible': visible,
    'position': position,
  };

  factory PipelineStageConfig.fromJson(Map<String, dynamic> json) {
    return PipelineStageConfig(
      key: json['key'] as String,
      label: json['label'] as String,
      visible: json['visible'] as bool? ?? true,
      position: json['position'] as int? ?? 0,
    );
  }

  static List<PipelineStageConfig> defaults = [
    const PipelineStageConfig(
      key: 'new',
      label: 'Nuevo',
      visible: true,
      position: 0,
    ),
    const PipelineStageConfig(
      key: 'contacted',
      label: 'Contactado',
      visible: true,
      position: 1,
    ),
    const PipelineStageConfig(
      key: 'interested',
      label: 'Interesado',
      visible: true,
      position: 2,
    ),
    const PipelineStageConfig(
      key: 'negotiating',
      label: 'Negociando',
      visible: true,
      position: 3,
    ),
    const PipelineStageConfig(
      key: 'closed_won',
      label: 'Ganado',
      visible: true,
      position: 4,
    ),
    const PipelineStageConfig(
      key: 'closed_lost',
      label: 'Perdido',
      visible: true,
      position: 5,
    ),
  ];
}
