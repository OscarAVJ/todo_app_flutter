// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/presentation/providers/category_provider/category_provider.dart';
import 'package:todo_app_flutter/presentation/widgets/category/category_form.dart';

enum Menu { edit, delete }

class CategoryItem extends ConsumerStatefulWidget {
  final CategoryEntity cat;
  final String title;
  final IconData icon;
  final Color color;

  const CategoryItem({
    super.key,
    required this.cat,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  CategoryItemState createState() => CategoryItemState();
}

class CategoryItemState extends ConsumerState<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: widget.color.withOpacity(0.8),
          child: Icon(widget.icon, color: Colors.white),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: PopupMenuButton<Menu>(
          icon: const Icon(Icons.more_vert),
          onSelected: (item) {
            switch (item) {
              case Menu.edit:
                _showEditTaskModal(context);
                break;
              case Menu.delete:
                deleteCategory(context);
                break;
            }
          },
          itemBuilder:
              (context) => <PopupMenuEntry<Menu>>[
                const PopupMenuItem(
                  value: Menu.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text('Editar'),
                  ),
                ),
                const PopupMenuItem(
                  value: Menu.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Eliminar'),
                  ),
                ),
              ],
        ),
      ),
    );
  }

  void deleteCategory(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar categoría'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar esta categoría?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final categoryNotifier = ref.read(categoryProvider.notifier);
      await categoryNotifier.deleteCategory(widget.cat);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría eliminada exitosamente')),
      );
    }
  }

  void _showEditTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: CategoryForm(category: widget.cat),
        );
      },
    );
  }
}
