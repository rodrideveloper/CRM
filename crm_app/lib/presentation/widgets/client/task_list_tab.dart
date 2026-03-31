import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../providers/task_provider.dart';

class TaskListTab extends ConsumerWidget {
  final String clientId;
  const TaskListTab({super.key, required this.clientId});

  void _showTaskDialog(
    BuildContext context,
    WidgetRef ref, {
    String? taskId,
    String? initialTitle,
    DateTime? initialDate,
  }) {
    final titleController = TextEditingController(text: initialTitle ?? '');
    DateTime? selectedDate = initialDate;
    final isEditing = taskId != null;

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
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: Icon(
                      isEditing ? Icons.edit_rounded : Icons.add_task_rounded,
                      color: DesignTokens.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? context.l10n.editTask : context.l10n.newTask,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: context.l10n.taskTitle,
                  prefixIcon: const Icon(Icons.task_alt_rounded),
                ),
                textInputAction: TextInputAction.done,
                autofocus: true,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_rounded),
                label: Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : context.l10n.taskDueDate,
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate:
                        selectedDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setSheetState(() => selectedDate = date);
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  gradient: DesignTokens.primaryGradient,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    if (isEditing) {
                      ref
                          .read(clientTasksProvider(clientId).notifier)
                          .updateTask(
                            taskId,
                            title: titleController.text.trim(),
                            dueDate: selectedDate,
                          );
                    } else {
                      ref
                          .read(clientTasksProvider(clientId).notifier)
                          .addTask(
                            title: titleController.text.trim(),
                            dueDate: selectedDate,
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    isEditing
                        ? context.l10n.saveChanges
                        : context.l10n.createTask,
                  ),
                ),
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
                  Icon(
                    Icons.task_alt_rounded,
                    size: 48,
                    color: DesignTokens.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.noTasks,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.noTasksHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.onSurfaceVariant,
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
                        content: Text(context.l10n.taskDeleted),
                        action: SnackBarAction(
                          label: context.l10n.undo,
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
                        ? DesignTokens.error.withValues(alpha: 0.08)
                        : DesignTokens.surfaceContainer,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    border: Border.all(
                      color: isOverdue
                          ? DesignTokens.error.withValues(alpha: 0.3)
                          : DesignTokens.outlineVariant.withValues(alpha: 0.12),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    onTap: () => _showTaskDialog(
                      context,
                      ref,
                      taskId: task.id,
                      initialTitle: task.title,
                      initialDate: task.dueDate,
                    ),
                    leading: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: task.completed,
                        activeColor: DesignTokens.primaryContainer,
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
                            ? DesignTokens.onSurfaceVariant
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
                                    : DesignTokens.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.dueDate(
                                  '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                ),
                                style: TextStyle(
                                  color: isOverdue
                                      ? DesignTokens.error
                                      : DesignTokens.onSurfaceVariant,
                                  fontWeight: isOverdue
                                      ? FontWeight.w700
                                      : null,
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
        onPressed: () => _showTaskDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
