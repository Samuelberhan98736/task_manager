import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(TaskPriority) onPriorityChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onPriorityChanged,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  void _showPriorityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskPriority.values.map((priority) {
            return RadioListTile<TaskPriority>(
              title: Text(priority.displayName),
              value: priority,
              groupValue: task.priority,
              onChanged: (value) {
                if (value != null) {
                  onPriorityChanged(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted
                ? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 16,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () => _showPriorityDialog(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 14,
                  color: _getPriorityColor(),
                ),
                const SizedBox(width: 4),
                Text(
                  task.priority.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getPriorityColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 12, color: Colors.grey),
              ],
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: onDelete,
          tooltip: 'Delete task',
        ),
      ),
    );
  }
}
