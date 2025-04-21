import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';

abstract class TaskDatasource {
  Future<void> createTask(TaskEntity task);
  Future<List<TaskEntity>> loadTasks({int limit = 5, offset = 0});
  Future<void> toogleComplete(TaskEntity task);
  Future<void> deleteTask(TaskEntity task);
  Future<List<TaskEntity>> loadWithParameter(
    bool? isCompleted, {
    int limit = 5,
    offset = 0,
  });
}
