import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.clientId,
    super.clientName,
    required super.title,
    super.dueDate,
    required super.completed,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // When joined with clients table, name comes as nested object
    String? clientName;
    if (json['clients'] is Map) {
      clientName = (json['clients'] as Map<String, dynamic>)['name'] as String?;
    }

    return TaskModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      clientName: clientName,
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
