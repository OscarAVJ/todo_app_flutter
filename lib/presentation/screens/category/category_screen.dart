import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/presentation/providers/category_provider/category_provider.dart';
import 'package:todo_app_flutter/presentation/widgets/category/category_form.dart';
import 'package:todo_app_flutter/presentation/widgets/category/category_item.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends ConsumerState<CategoryScreen> {
  bool isLoading = false;
  bool isLastPage = false;
  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    ///Eviatamos peticiones simultaneas
    isLoading = true;

    ///Hacemos la peticion al provider para poder cargar la siguiente pagina
    final loadCategories =
        await ref.read(categoryProvider.notifier).loadNextCategory();
    isLoading = false;

    ///En caso de que no hayan mas categorias quiere decir que ya estamos en la ultima pagina
    if (loadCategories.isEmpty) {
      isLastPage = true;
    }
  }

  //!Metodo para inicalizar nuestas categorias
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent - 100) {
          loadNextPage();
        }
        return false;
      },
      child: Scaffold(
        body:
            category.isEmpty
                ? const Center(child: Text('No hay categorías disponibles'))
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          category.map((cat) {
                            final icon = IconData(
                              cat.icon ?? 0,
                              fontFamily: 'MaterialIcons',
                            );
                            return CategoryItem(
                              cat: cat,
                              title: cat.name,
                              icon: icon,
                              color: Color(cat.color),
                            );
                          }).toList(),
                    ),
                  ),
                ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskModal(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: CategoryForm(),
        );
      },
    );
  }
}
