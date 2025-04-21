import 'package:todo_app_flutter/data/domain/datasource/task/task_datasource.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:todo_app_flutter/data/domain/repositories/task/task_repository.dart';

class TaskRepositoryImplementation extends TaskRepository {
  final TaskDatasource datasource;

  TaskRepositoryImplementation(this.datasource);
  @override
  Future<void> createTask(TaskEntity task) {
    return datasource.createTask(task);
  }

  @override
  Future<List<TaskEntity>> loadTasks({int limit = 5, offset = 0}) {
    return datasource.loadTasks(offset: offset, limit: limit);
  }

  @override
  Future<void> toogleComplete(TaskEntity task) {
    return datasource.toogleComplete(task);
  }

  @override
  Future<void> deleteTask(TaskEntity task) {
    return datasource.deleteTask(task);
  }

  @override
  Future<List<TaskEntity>> loadWithParameter(
    bool? isCompleted, {
    int limit = 5,
    offset = 0,
  }) {
    return datasource.loadWithParameter(
      isCompleted,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<List<TaskEntity>> loadWithParameter2(
    bool? isCompleted, {
    int limit = 5,
    offset = 0,
  }) {
    return datasource.loadWithParameter(
      isCompleted,
      offset: offset,
      limit: limit,
    );
  }
}
