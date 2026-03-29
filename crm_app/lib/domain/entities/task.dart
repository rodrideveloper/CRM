class Task {
  final String id;
  final String clientId;
  final String? clientName;
  final String title;
  final DateTime? dueDate;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.clientId,
    this.clientName,
    required this.title,
    this.dueDate,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOverdue =>
      !completed && dueDate != null && dueDate!.isBefore(DateTime.now());

  Task copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? title,
    DateTime? dueDate,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
