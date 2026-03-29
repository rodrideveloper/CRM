import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
              Text(
                'Nueva tarea',
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea',
                  prefixIcon: Icon(Icons.task_outlined),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
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

    return Scaffold(
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(
              child: Text('Sin tareas. Creá una con el botón +'),
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
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
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
                child: Card(
                  color: isOverdue ? Colors.red.shade50 : null,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.completed,
                      onChanged: (_) {
                        ref
                            .read(clientTasksProvider(clientId).notifier)
                            .toggleComplete(task.id);
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: task.dueDate != null
                        ? Text(
                            'Vence: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                            style: TextStyle(
                              color: isOverdue ? Colors.red : null,
                              fontWeight: isOverdue ? FontWeight.bold : null,
                            ),
                          )
                        : null,
                    trailing: isOverdue
                        ? const Icon(Icons.warning, color: Colors.red)
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
