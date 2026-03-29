import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        title: const Text('Tareas pendientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(pendingTasksProvider),
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $err'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(pendingTasksProvider),
                child: const Text('Reintentar'),
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
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text('¡Todo al día!', style: theme.textTheme.titleLarge),
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

                return Card(
                  color: isOverdue ? Colors.red.shade50 : null,
                  child: ListTile(
                    leading: isOverdue
                        ? const Icon(Icons.warning, color: Colors.red)
                        : const Icon(Icons.task_outlined),
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.clientName != null)
                          Text(
                            task.clientName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (task.dueDate != null)
                          Text(
                            'Vence: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            style: TextStyle(
                              color: isOverdue ? Colors.red : null,
                              fontWeight: isOverdue ? FontWeight.bold : null,
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle_outline),
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
