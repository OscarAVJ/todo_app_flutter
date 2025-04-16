import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/data/domain/repositories/category_repository.dart/category_repositorie_domain.dart';

class CategoryRepositoryInfraestructure extends CategoryRepositorieDomain {
  @override
  Future<void> createCategory(CategoryEntity category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(CategoryEntity category) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryEntity>> loadCategories({int limit = 5, int offset = 0}) {
    // TODO: implement loadCategories
    throw UnimplementedError();
  }
}
