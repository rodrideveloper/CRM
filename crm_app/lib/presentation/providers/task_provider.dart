import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    await ref
        .read(taskRepositoryProvider)
        .createTask(clientId: arg, title: title, dueDate: dueDate);
    ref.invalidateSelf();
    // Also refresh global pending tasks
    ref.invalidate(pendingTasksProvider);
  }

  Future<void> toggleComplete(String taskId) async {
    await ref.read(taskRepositoryProvider).toggleComplete(taskId);
    ref.invalidateSelf();
    ref.invalidate(pendingTasksProvider);
  }

  Future<void> deleteTask(String taskId) async {
    await ref.read(taskRepositoryProvider).softDeleteTask(taskId);
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
