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
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TaskEntitySchema],
        directory: dir.path,
        inspector: true,
      );
    }
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
}
