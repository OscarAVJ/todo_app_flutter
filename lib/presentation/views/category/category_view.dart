import 'package:flutter/material.dart';
import 'package:todo_app_flutter/presentation/screens/category/category_screen.dart';

class CategoryView extends StatefulWidget {
  static const name = 'category_view';

  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.category),
          ),
        ],
      ),
      body: CategoryScreen(),
    );
  }
}
