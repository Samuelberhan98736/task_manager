import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_item.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) onToggle;
  final Function(int) onDelete;
  final Function(int, TaskPriority) onPriorityChanged;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onToggle: () => onToggle(index),
          onDelete: () => onDelete(index),
          onPriorityChanged: (priority) => onPriorityChanged(index, priority),
        );
      },
    );
  }
}
