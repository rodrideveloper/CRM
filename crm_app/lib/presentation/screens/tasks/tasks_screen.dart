import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../providers/task_provider.dart';
import '../../providers/repository_providers.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(pendingTasksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas 📋'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DesignTokens.bgSubtle,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: const Icon(Icons.refresh_rounded, size: 20),
            ),
            onPressed: () => ref.invalidate(pendingTasksProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😕', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'Algo salió mal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$err',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(pendingTasksProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    '¡Todo al día!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No hay tareas pendientes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(pendingTasksProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final isOverdue = task.isOverdue;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? DesignTokens.error.withValues(alpha: 0.06)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    border: isOverdue
                        ? Border.all(
                            color: DesignTokens.error.withValues(alpha: 0.2),
                          )
                        : null,
                    boxShadow: DesignTokens.shadowSoft,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: isOverdue
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: DesignTokens.error.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusS,
                              ),
                            ),
                            child: const Icon(
                              Icons.warning_rounded,
                              color: DesignTokens.error,
                              size: 20,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: DesignTokens.info.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusS,
                              ),
                            ),
                            child: Icon(
                              Icons.task_alt_rounded,
                              color: DesignTokens.info,
                              size: 20,
                            ),
                          ),
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.clientName != null)
                          Text(
                            task.clientName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: DesignTokens.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (task.dueDate != null)
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 13,
                                color: isOverdue
                                    ? DesignTokens.error
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Vence: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                style: TextStyle(
                                  color: isOverdue
                                      ? DesignTokens.error
                                      : null,
                                  fontWeight:
                                      isOverdue ? FontWeight.w700 : null,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: DesignTokens.primaryLight,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusS,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: DesignTokens.primary,
                          size: 18,
                        ),
                      ),
                      tooltip: 'Completar',
                      onPressed: () async {
                        await ref
                            .read(taskRepositoryProvider)
                            .toggleComplete(task.id);
                        ref.invalidate(pendingTasksProvider);
                      },
                    ),
                    onTap: () => context.push('/client/${task.clientId}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
