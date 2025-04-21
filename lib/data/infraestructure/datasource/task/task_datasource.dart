import 'package:isar/isar.dart';
import 'package:todo_app_flutter/data/domain/datasource/task/task_datasource.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:path_provider/path_provider.dart';

class TaskDatasourceImpl extends TaskDatasource {
  late Future<Isar> db;

  /// Constructor que inicializa la base de datos
  TaskDatasourceImpl() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();

    /// En caso de que no tengamos una instancia creada retornamos Isar.Open
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TaskEntitySchema, CategoryEntitySchema],

        /// Inspector permite inspeccionar la base de datos en el dispositivo
        inspector: true,
        directory: dir.path,
      );
    }

    /// Si ya hay una instancia, retornamos esa instancia
    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> createTask(TaskEntity task) async {
    final isar = await db;

    /// Usar una transacción explícita para la operación de escritura
    // await isar.writeTxn(() async {
    //   await isar.taskEntitys.put(task);
    // });
    isar.writeTxnSync(() => isar.taskEntitys.putSync(task));
  }

  @override
  Future<void> toogleComplete(TaskEntity task) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.taskEntitys.putSync(task));
  }

  @override
  Future<List<TaskEntity>> loadTasks({int limit = 5, offset = 0}) async {
    final isar = await db;
    return isar.taskEntitys.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> deleteTask(TaskEntity task) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.taskEntitys.delete(task.id);
    });
  }

  @override
  Future<List<TaskEntity>> loadWithParameter(
    bool? isCompleted, {
    int limit = 5,
    offset = 0,
  }) async {
    final isar = await db;

    // Filtrar las tareas basadas en el estado de completado
    final query = isar.taskEntitys.where();

    if (isCompleted != null) {
      query.filter().isCompletedEqualTo(isCompleted);
    }

    return query.offset(offset).limit(limit).findAll();
  }

  @override
  Future<List<TaskEntity>> loadWithParameter2(
    bool? isCompleted, {
    int limit = 5,
    offset = 0,
  }) async {
    final isar = await db;

    // Filtrar las tareas basadas en el estado de completado
    final query = isar.taskEntitys.where();

    if (isCompleted != null) {
      query.filter().isCompletedEqualTo(!isCompleted);
    }

    return query.offset(offset).limit(limit).findAll();
  }
}
