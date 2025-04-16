import 'package:todo_app_flutter/data/domain/datasource/category/category_datasource_domain.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/data/domain/repositories/category_repository.dart/category_repositorie_domain.dart';

class CategoryRepositoryInfraestructure extends CategoryRepositorieDomain {
  final CategoryDatasourceDomain dt;

  CategoryRepositoryInfraestructure(this.dt);

  @override
  Future<void> createCategory(CategoryEntity category) {
    return dt.createCategory(category);
  }

  @override
  Future<void> deleteCategory(CategoryEntity category) {
    return dt.deleteCategory(category);
  }

  @override
  Future<List<CategoryEntity>> loadCategories({int limit = 5, int offset = 0}) {
    return dt.loadCategories(offset: offset, limit: limit);
  }
}
