import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SupabaseClient _client;

  TaskRepositoryImpl(this._client);

  @override
  Future<List<Task>> getTasksByClient(String clientId) async {
    final data = await _client
        .from('tasks')
        .select()
        .eq('client_id', clientId)
        .order('due_date', ascending: true);
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<List<Task>> getPendingTasks() async {
    final data = await _client
        .from('tasks')
        .select('*, clients!inner(name)')
        .eq('completed', false)
        .order('due_date', ascending: true);
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<Task> createTask({
    required String clientId,
    required String title,
    DateTime? dueDate,
  }) async {
    final data = await _client
        .from('tasks')
        .insert(
          TaskModel.toInsertJson(
            clientId: clientId,
            title: title,
            dueDate: dueDate,
          ),
        )
        .select()
        .single();
    return TaskModel.fromJson(data);
  }

  @override
  Future<Task> updateTask(
    String id, {
    String? title,
    DateTime? dueDate,
    bool? completed,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (dueDate != null) updates['due_date'] = dueDate.toIso8601String();
    if (completed != null) updates['completed'] = completed;
    if (updates.isEmpty) throw ArgumentError('No fields to update');
    final data = await _client
        .from('tasks')
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return TaskModel.fromJson(data);
  }

  @override
  Future<Task> toggleComplete(String id) async {
    // Fetch current, then toggle
    final current = await _client.from('tasks').select().eq('id', id).single();
    final data = await _client
        .from('tasks')
        .update({'completed': !(current['completed'] as bool)})
        .eq('id', id)
        .select()
        .single();
    return TaskModel.fromJson(data);
  }

  @override
  Future<void> softDeleteTask(String id) async {
    await _client
        .from('tasks')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  @override
  Future<void> restoreTask(String id) async {
    await _client.rpc('restore_task', params: {'p_task_id': id});
  }
}
