import 'package:isar/isar.dart';
import 'package:todo_app_flutter/data/domain/datasource/task/task_datasource.dart';
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
        [TaskEntitySchema],

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
    await isar.writeTxn(() async {
      await isar.taskEntitys.put(task);
    });
  }

  @override
  Future<List<TaskEntity>> loadTasks({int limit = 5, offset = 0}) async {
    final isar = await db;
    return isar.taskEntitys.where().offset(offset).limit(limit).findAll();
  }
}
