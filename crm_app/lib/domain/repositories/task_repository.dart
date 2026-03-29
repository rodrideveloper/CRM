import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasksByClient(String clientId);
  Future<List<Task>> getPendingTasks();
  Future<Task> createTask({
    required String clientId,
    required String title,
    DateTime? dueDate,
  });
  Future<Task> updateTask(
    String id, {
    String? title,
    DateTime? dueDate,
    bool? completed,
  });
  Future<Task> toggleComplete(String id);
  Future<void> softDeleteTask(String id);
  Future<void> restoreTask(String id);
}
