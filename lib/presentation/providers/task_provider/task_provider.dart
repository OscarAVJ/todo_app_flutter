import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:todo_app_flutter/data/domain/repositories/task/task_repository.dart';
import 'package:todo_app_flutter/data/infraestructure/datasource/task/task_datasource.dart';
import 'package:todo_app_flutter/data/infraestructure/repositories/task/task_repository_implementation.dart';

final taskProviderImpl = Provider((ref) {
  return TaskRepositoryImplementation(TaskDatasourceImpl());
});

final tasksProvider = StateNotifierProvider<TaskNotifier, List<TaskEntity>>((
  ref,
) {
  final repository = ref.read(taskProviderImpl);
  return TaskNotifier(repository);
});

class TaskNotifier extends StateNotifier<List<TaskEntity>> {
  int page = 0;

  final TaskRepository taskRepository;
  bool _isLoading = false;

  TaskNotifier(this.taskRepository) : super([]);

  Future<List<TaskEntity>> loadNextPage() async {
    if (_isLoading) return []; // Evitar múltiples cargas simultáneas

    _isLoading = true;

    // Cargar las tareas de la siguiente página
    final newTasks = await taskRepository.loadTasks(
      limit: 5,
      offset: page * 5, // Calcular el offset correctamente
    );

    if (newTasks.isNotEmpty) {
      // Agregar las nuevas tareas al estado existente
      state = [...state, ...newTasks];
      page++; // Incrementar el contador de páginas solo si hay nuevas tareas
    }

    _isLoading = false;

    return newTasks; // Devolver las nuevas tareas cargadas
  }

  Future<List<TaskEntity>> loadParameter({
    bool? isCompleted, // Filtro opcional para tareas completadas
    int limit = 5,
    int offset = 0,
  }) async {
    if (_isLoading) return []; // Evitar múltiples cargas simultáneas

    _isLoading = true;

    // Cargar las tareas basadas en el filtro proporcionado
    final newTasks = await taskRepository.loadWithParameter(
      isCompleted,
      offset: 5 * page,
      limit: 5,
    );

    if (newTasks.isNotEmpty) {
      // Agregar las nuevas tareas al estado existente
      state = [...state, ...newTasks];
      page++; // Incrementar el contador de páginas solo si hay nuevas tareas
    }

    _isLoading = false;

    return newTasks; // Devolver las nuevas tareas cargadas
  }

  Future<List<TaskEntity>> loadParameter2({
    bool? isCompleted, // Filtro opcional para tareas completadas
    int limit = 5,
    int offset = 0,
  }) async {
    if (_isLoading) return []; // Evitar múltiples cargas simultáneas

    _isLoading = true;

    // Cargar las tareas basadas en el filtro proporcionado
    final newTasks = await taskRepository.loadWithParameter2(
      isCompleted,
      offset: 5 * page,
      limit: 5,
    );

    if (newTasks.isNotEmpty) {
      // Agregar las nuevas tareas al estado existente
      state = [...state, ...newTasks];
      page++; // Incrementar el contador de páginas solo si hay nuevas tareas
    }

    _isLoading = false;

    return newTasks; // Devolver las nuevas tareas cargadas
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    // Toggle the completion status
    task.isCompleted = !task.isCompleted;

    // Update the task in the database
    await taskRepository.createTask(task);

    // Update the state
    state = [
      for (final task in state)
        if (task.id == task.id) task else task,
    ];
  }

  Future<void> addTask(TaskEntity newTask) async {
    // Agregar la tarea a la base de datos
    await taskRepository.createTask(newTask);

    // Actualizar el estado agregando la nueva tarea
    state = [...state, newTask];
  }

  Future<void> editTask(TaskEntity updatedTask) async {
    await taskRepository.createTask(updatedTask);
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  Future<void> deleteTask(TaskEntity task) async {
    // Eliminar la tarea de la base de datos
    await taskRepository.deleteTask(task);

    // Actualizar el estado eliminando la tarea
    state = state.where((t) => t.id != task.id).toList();
  }
}
