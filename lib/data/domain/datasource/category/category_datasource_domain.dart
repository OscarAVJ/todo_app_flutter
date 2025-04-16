import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';

abstract class CategoryDatasourceDomain {
  Future<void> createCategory(CategoryEntity category);
  Future<List<CategoryEntity>> loadCategories({int limit = 5, int offset = 0});
  Future<void> deleteCategory(CategoryEntity category);
}
