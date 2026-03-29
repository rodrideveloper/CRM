import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.clientId,
    required super.title,
    super.dueDate,
    required super.completed,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      title: json['title'] as String,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static Map<String, dynamic> toInsertJson({
    required String clientId,
    required String title,
    DateTime? dueDate,
  }) {
    return {
      'client_id': clientId,
      'title': title,
      if (dueDate != null) 'due_date': dueDate.toIso8601String(),
    };
  }
}
