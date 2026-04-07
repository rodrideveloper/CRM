import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/design_tokens.dart';
import '../../domain/entities/pipeline_stage_config.dart';
import '../providers/repository_providers.dart';
import '../providers/user_profile_provider.dart';

void showPipelineSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) =>
          _PipelineSettingsSheet(scrollController: scrollController),
    ),
  );
}

class _PipelineSettingsSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const _PipelineSettingsSheet({required this.scrollController});

  @override
  ConsumerState<_PipelineSettingsSheet> createState() =>
      _PipelineSettingsSheetState();
}

class _PipelineSettingsSheetState
    extends ConsumerState<_PipelineSettingsSheet> {
  late List<PipelineStageConfig> _stages;
  bool _saving = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _stages = List.from(ref.read(allPipelineStagesProvider));
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(userProfileRepositoryProvider).savePipelineConfig(_stages);
      ref.invalidate(userProfileProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toggleVisibility(int index) {
    final visibleCount = _stages.where((s) => s.visible).length;
    if (_stages[index].visible && visibleCount <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Necesitás al menos 2 columnas visibles')),
      );
      return;
    }
    setState(() {
      _stages[index] = _stages[index].copyWith(
        visible: !_stages[index].visible,
      );
      _dirty = true;
    });
  }

  void _editLabel(int index) {
    final controller = TextEditingController(text: _stages[index].label);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renombrar columna'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Nombre de la columna'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final newLabel = controller.text.trim();
              if (newLabel.isNotEmpty) {
                setState(() {
                  _stages[index] = _stages[index].copyWith(label: newLabel);
                  _dirty = true;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    controller.dispose;
  }

  void _reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    setState(() {
      final item = _stages.removeAt(oldIndex);
      _stages.insert(newIndex, item);
      // Update positions
      for (var i = 0; i < _stages.length; i++) {
        _stages[i] = _stages[i].copyWith(position: i);
      }
      _dirty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DesignTokens.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                const Icon(
                  Icons.view_column_rounded,
                  color: DesignTokens.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Configurar pipeline',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (_dirty)
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Guardar'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Arrastrá para reordenar, tocá el ojo para ocultar/mostrar, '
              'y el lápiz para renombrar.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: DesignTokens.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Stage list
          Expanded(
            child: ReorderableListView.builder(
              scrollController: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _stages.length,
              onReorder: _reorder,
              proxyDecorator: (child, index, animation) {
                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final stage = _stages[index];
                final color = DesignTokens.statusColor(stage.key);
                return _StageRow(
                  key: ValueKey(stage.key),
                  stage: stage,
                  color: color,
                  onToggle: () => _toggleVisibility(index),
                  onEdit: () => _editLabel(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  final PipelineStageConfig stage;
  final Color color;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const _StageRow({
    super.key,
    required this.stage,
    required this.color,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: stage.visible
            ? DesignTokens.surfaceContainer
            : DesignTokens.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: stage.visible
              ? color.withValues(alpha: 0.3)
              : DesignTokens.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: stage.visible ? 0.15 : 0.05),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: Icon(
            Icons.circle,
            color: color.withValues(alpha: stage.visible ? 1 : 0.3),
            size: 16,
          ),
        ),
        title: Text(
          stage.label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: stage.visible ? null : DesignTokens.onSurfaceVariant,
            decoration: stage.visible ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          stage.visible ? 'Visible' : 'Oculta',
          style: theme.textTheme.bodySmall?.copyWith(
            color: DesignTokens.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_rounded, size: 20),
              color: DesignTokens.onSurfaceVariant,
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                stage.visible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 20,
              ),
              color: stage.visible
                  ? DesignTokens.primary
                  : DesignTokens.onSurfaceVariant,
              onPressed: onToggle,
            ),
            const Icon(
              Icons.drag_handle_rounded,
              color: DesignTokens.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
