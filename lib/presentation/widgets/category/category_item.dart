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
      // ignore: deprecated_member_use
      color: widget.color.withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 32), // Mostrar el ícono
            const SizedBox(width: 16),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (Menu item) {
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
                    PopupMenuItem(
                      value: Menu.edit,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Editar'),
                      ),
                    ),
                    PopupMenuItem(
                      value: Menu.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Eliminar'),
                      ),
                    ),
                  ],
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
            title: const Text('Eliminar tarea'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar esta tarea?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      // Obtener el TaskNotifier desde el provider
      final categoryNotifier = ref.read(categoryProvider.notifier);

      // Eliminar la tarea
      await categoryNotifier.deleteCategory(widget.cat);

      // Mostrar un mensaje de éxito
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea eliminada exitosamente')),
      );
    }
  }

  void _showEditTaskModal(BuildContext context) {
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
          child: CategoryForm(category: widget.cat),
        );
      },
    );
  }
}
