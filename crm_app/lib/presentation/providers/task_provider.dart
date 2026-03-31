import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/task.dart';
import 'repository_providers.dart';

// Tasks for a specific client
final clientTasksProvider =
    AsyncNotifierProvider.family<ClientTasksNotifier, List<Task>, String>(
      ClientTasksNotifier.new,
    );

class ClientTasksNotifier extends FamilyAsyncNotifier<List<Task>, String> {
  @override
  Future<List<Task>> build(String arg) async {
    return ref.read(taskRepositoryProvider).getTasksByClient(arg);
  }

  Future<void> addTask({required String title, DateTime? dueDate}) async {
    final task = await ref
        .read(taskRepositoryProvider)
        .createTask(clientId: arg, title: title, dueDate: dueDate);
    if (dueDate != null) {
      await NotificationService().scheduleTaskReminder(
        taskId: task.id,
        title: '⏰ $title',
        dueDate: dueDate,
        clientName: task.clientName,
      );
    }
    ref.invalidateSelf();
    // Also refresh global pending tasks
    ref.invalidate(pendingTasksProvider);
  }

  Future<void> updateTask(
    String taskId, {
    String? title,
    DateTime? dueDate,
  }) async {
    final task = await ref
        .read(taskRepositoryProvider)
        .updateTask(taskId, title: title, dueDate: dueDate);
    if (dueDate != null) {
      await NotificationService().scheduleTaskReminder(
        taskId: task.id,
        title: '⏰ ${task.title}',
        dueDate: dueDate,
        clientName: task.clientName,
      );
    }
    ref.invalidateSelf();
    ref.invalidate(pendingTasksProvider);
  }

  Future<void> toggleComplete(String taskId) async {
    await ref.read(taskRepositoryProvider).toggleComplete(taskId);
    // Cancel notification if task is completed
    await NotificationService().cancelTaskReminder(taskId);
    ref.invalidateSelf();
    ref.invalidate(pendingTasksProvider);
  }

  Future<void> deleteTask(String taskId) async {
    await ref.read(taskRepositoryProvider).softDeleteTask(taskId);
    await NotificationService().cancelTaskReminder(taskId);
    ref.invalidateSelf();
    ref.invalidate(pendingTasksProvider);
  }

  Future<void> restoreTask(String taskId) async {
    await ref.read(taskRepositoryProvider).restoreTask(taskId);
    ref.invalidateSelf();
    ref.invalidate(pendingTasksProvider);
  }
}

// Global pending tasks (for Tasks screen)
final pendingTasksProvider = FutureProvider<List<Task>>((ref) {
  return ref.read(taskRepositoryProvider).getPendingTasks();
});

// Overdue tasks count (for badge)
final overdueTaskCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(pendingTasksProvider);
  return tasks.maybeWhen(
    data: (list) => list.where((t) => t.isOverdue).length,
    orElse: () => 0,
  );
});
