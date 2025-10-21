import 'package: flutter/material.dart';
import 'package:flutter/material.dart';
import 'models/task.dart';


class TaskListScreeen extends StatefulWidget{
  const TaskListScreeen ({super.key});

  @override
  State<TaskListScreeen> create() => _TaskListScreenState();
}


class _TaskListScreenState extends State<TaskListScreen>{
  //list to store all tasks

  final List<Task> _task = [];

  // controller for the text input

  final TextEditingController _taskController = TextEditingController();


  //method to add a new task

  void _addTask(){
    if(_taskController.text.trim().isnotEmpty){
      setState((){
        _tasks.add(Task(name: _taskController.text.trim()));
        _taskController.clear();
      });
    }
  }


  // method to toggle task completion status

  void _toggleTaskCompletion(int index){
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  


}

