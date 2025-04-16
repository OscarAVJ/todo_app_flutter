import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app_flutter/data/domain/datasource/category/category_datasource_domain.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';

class CategoryDatasourceInfraestructure extends CategoryDatasourceDomain {
  late Future<Isar> db;

  CategoryDatasourceInfraestructure() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();

    /// En caso de que no tengamos una instancia creada retornamos Isar.Open
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          CategoryEntitySchema,
          TaskEntitySchema,
        ], // Asegúrate de incluir todos los esquemas necesarios
        inspector: true, // Permite inspeccionar la base de datos
        directory: dir.path,
      );
    }

    /// Si ya hay una instancia, retornamos esa instancia
    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> createCategory(CategoryEntity category) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.categoryEntitys.putSync(category));
  }

  @override
  Future<void> deleteCategory(CategoryEntity category) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.categoryEntitys.delete(category.id);
    });
  }

  @override
  Future<List<CategoryEntity>> loadCategories({
    int limit = 5,
    int offset = 0,
  }) async {
    final isar = await db;
    return isar.categoryEntitys.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<List<CategoryEntity>> loadAllCategories() async {
    final isar = await db;
    return isar.categoryEntitys.where().findAll();
  }
}
