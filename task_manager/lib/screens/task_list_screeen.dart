import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/database_helper.dart';
import '../widgets/task_input_field.dart';
import '../widgets/task_list_view.dart';
import '../widgets/task_counter.dart';
import '../widgets/empty_state.dart';

class TaskListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const TaskListScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List to store all tasks
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _isLoading = true;
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from database
  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getAllTasks();
    setState(() {
      _tasks.clear();
      _tasks.addAll(tasks);
      _sortTasks();
      _isLoading = false;
    });
  }

  // Sort tasks by priority (high to low)
  void _sortTasks() {
    _tasks.sort((a, b) => a.priority.sortOrder.compareTo(b.priority.sortOrder));
  }

  // Add a new task
  Future<void> _addTask() async {
    if (_taskController.text.trim().isNotEmpty) {
      final newTask = Task(
        name: _taskController.text.trim(),
        priority: _selectedPriority,
      );

      final task = await _dbHelper.createTask(newTask);

      setState(() {
        _tasks.add(task);
        _sortTasks();
        _taskController.clear();
        _selectedPriority = TaskPriority.medium;
      });
    }
  }

  // Toggle task completion status
  Future<void> _toggleTaskCompletion(int index) async {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    await _dbHelper.updateTask(_tasks[index]);
  }

  // Delete a task
  Future<void> _deleteTask(int index) async {
    final taskId = _tasks[index].id;
    if (taskId != null) {
      await _dbHelper.deleteTask(taskId);
      setState(() {
        _tasks.removeAt(index);
      });
    }
  }

  // Update task priority
  Future<void> _updateTaskPriority(int index, TaskPriority newPriority) async {
    setState(() {
      _tasks[index].priority = newPriority;
      _sortTasks();
    });
    await _dbHelper.updateTask(_tasks[index]);
  }

  // Clear all tasks
  void _clearAllTasks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('Are you sure you want to delete all tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteAllTasks();
              setState(() {
                _tasks.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle theme',
          ),
          if (_tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllTasks,
              tooltip: 'Clear all tasks',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TaskInputField(
                  controller: _taskController,
                  selectedPriority: _selectedPriority,
                  onPriorityChanged: (priority) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  onAdd: _addTask,
                ),
                Expanded(
                  child: _tasks.isEmpty
                      ? const EmptyState()
                      : TaskListView(
                          tasks: _tasks,
                          onToggle: _toggleTaskCompletion,
                          onDelete: _deleteTask,
                          onPriorityChanged: _updateTaskPriority,
                        ),
                ),
                if (_tasks.isNotEmpty)
                  TaskCounter(
                    totalTasks: _tasks.length,
                    completedTasks: _tasks.where((t) => t.isCompleted).length,
                  ),
              ],
            ),
    );
  }
}

