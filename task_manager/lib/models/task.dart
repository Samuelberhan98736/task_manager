enum TaskPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  int get sortOrder {
    switch (this) {
      case TaskPriority.high:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.low:
        return 2;
    }
  }

  int get value {
    switch (this) {
      case TaskPriority.low:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.high:
        return 2;
    }
  }

  static TaskPriority fromValue(int value) {
    switch (value) {
      case 0:
        return TaskPriority.low;
      case 1:
        return TaskPriority.medium;
      case 2:
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }
}

class Task {
  int? id;
  String name;
  bool isCompleted;
  TaskPriority priority;
  DateTime createdAt;

  Task({
    this.id,
    required this.name,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Task to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      name: map['name'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
      priority: TaskPriority.fromValue(map['priority'] as int),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
