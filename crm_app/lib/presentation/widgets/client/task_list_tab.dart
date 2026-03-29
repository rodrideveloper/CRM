import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/design_tokens.dart';
import '../../providers/task_provider.dart';

class TaskListTab extends ConsumerWidget {
  final String clientId;
  const TaskListTab({super.key, required this.clientId});

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: DesignTokens.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusS,
                      ),
                    ),
                    child: Icon(
                      Icons.add_task_rounded,
                      color: DesignTokens.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Nueva tarea',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea',
                  prefixIcon: Icon(Icons.task_alt_rounded),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_rounded),
                label: Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Fecha de vencimiento (opcional)',
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setSheetState(() => selectedDate = date);
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;
                  Navigator.pop(ctx);
                  ref
                      .read(clientTasksProvider(clientId).notifier)
                      .addTask(
                        title: titleController.text.trim(),
                        dueDate: selectedDate,
                      );
                },
                child: const Text('Crear tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(clientTasksProvider(clientId));
    final theme = Theme.of(context);

    return Scaffold(
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✅', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'Sin tareas pendientes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Creá una con el botón +',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final isOverdue = task.isOverdue;

              return Dismissible(
                key: ValueKey(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: DesignTokens.error,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(clientTasksProvider(clientId).notifier)
                      .deleteTask(task.id);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: const Text('Tarea eliminada'),
                        action: SnackBarAction(
                          label: 'Deshacer',
                          onPressed: () {
                            ref
                                .read(clientTasksProvider(clientId).notifier)
                                .restoreTask(task.id);
                          },
                        ),
                      ),
                    );
                },
                child: Container(
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
                      horizontal: 12,
                      vertical: 4,
                    ),
                    leading: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: task.completed,
                        activeColor: DesignTokens.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (_) {
                          ref
                              .read(clientTasksProvider(clientId).notifier)
                              .toggleComplete(task.id);
                        },
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.w600,
                        color: task.completed
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                    subtitle: task.dueDate != null
                        ? Row(
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
                          )
                        : null,
                    trailing: isOverdue
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: DesignTokens.error.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusS,
                              ),
                            ),
                            child: const Icon(
                              Icons.warning_rounded,
                              color: DesignTokens.error,
                              size: 18,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'addTask',
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
