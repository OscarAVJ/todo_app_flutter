import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/data/domain/repositories/category_repository.dart/category_repositorie_domain.dart';
import 'package:todo_app_flutter/data/infraestructure/datasource/category/category_datasource_infraestructure.dart';
import 'package:todo_app_flutter/data/infraestructure/repositories/category/category_repository_infraestructure.dart';

final categoryProviderImpl = Provider((ref) {
  return CategoryRepositoryInfraestructure(CategoryDatasourceInfraestructure());
});
final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<CategoryEntity>>((ref) {
      final repository = ref.read(categoryProviderImpl);
      return CategoryNotifier(repository);
    });

class CategoryNotifier extends StateNotifier<List<CategoryEntity>> {
  int page = 0;
  final CategoryRepositorieDomain categoryRepository;
  bool isLoading = false;
  CategoryNotifier(this.categoryRepository) : super([]);
  Future<List<CategoryEntity>> loadNextCategory() async {
    if (isLoading) return [];
    isLoading = true;
    final categories = await categoryRepository.loadCategories(
      limit: 5,
      offset: page * 5,
    );
    if (categories.isNotEmpty) {
      state = [...state, ...categories];
      page++;
    }
    isLoading = false;
    return categories;
  }

  Future<void> createCategory(CategoryEntity category) async {
    await categoryRepository.createCategory(category);
    state = [...state, category];
  }

  Future<void> editCaterory(CategoryEntity category) async {
    await categoryRepository.createCategory(category);
    state = [
      for (final cat in state)
        if (cat.id == category.id) category else cat,
    ];
  }

  Future<List<CategoryEntity>> loadAllCategories() async {
    final categories = await categoryRepository.loadAllCategories();
    state = categories;
    return categories;
  }

  Future<void> deleteCategory(CategoryEntity category) async {
    await categoryRepository.deleteCategory(category);
    state = state.where((t) => t.id != category.id).toList();
  }
}
