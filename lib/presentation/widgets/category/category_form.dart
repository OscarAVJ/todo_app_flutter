// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/presentation/providers/category_provider/category_provider.dart';

class CategoryForm extends ConsumerStatefulWidget {
  final CategoryEntity? category;
  const CategoryForm({super.key, this.category});

  @override
  CategoryFormState createState() => CategoryFormState();
}

class CategoryFormState extends ConsumerState<CategoryForm> {
  final List<IconData> iconOptions = [
    Icons.home,
    Icons.star,
    Icons.work,
    Icons.school,
    Icons.favorite,
    Icons.pets,
    Icons.shopping_cart,
    Icons.music_note,
    Icons.book,
    Icons.sports_soccer,
    Icons.flight,
    Icons.fitness_center,
  ];

  final List<Color> availableColors = [
    const Color.fromARGB(255, 255, 17, 0),
    const Color.fromARGB(255, 0, 255, 8),
    const Color.fromARGB(255, 0, 140, 255),
    const Color.fromARGB(255, 255, 153, 0),
    const Color.fromARGB(255, 217, 0, 255),
    const Color.fromARGB(255, 0, 255, 229),
    const Color.fromARGB(255, 255, 0, 85),
    const Color.fromARGB(255, 255, 118, 68),
    const Color.fromARGB(255, 0, 225, 255),
  ];

  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  Color? selectedColor;
  IconData? selectedIcon;
  late bool isNew;

  @override
  void initState() {
    super.initState();
    final item = widget.category;
    isNew = item == null;
    titleController = TextEditingController(text: widget.category?.name ?? '');
    selectedColor =
        widget.category?.color != null
            ? Color(widget.category!.color)
            : availableColors.first;
    selectedIcon =
        widget.category?.icon != null
            ? IconData(widget.category!.icon!, fontFamily: 'MaterialIcons')
            : iconOptions.first;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la categoría',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Color', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children:
                    availableColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 18,
                            child:
                                selectedColor?.value == color.value
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Ícono', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    iconOptions.map((icon) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  selectedIcon == icon
                                      ? Colors.blue
                                      : Colors.grey,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            icon,
                            color:
                                selectedIcon == icon
                                    ? Colors.blue
                                    : const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Categoría'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Aquí iría el guardado
                      createCategory();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createCategory() async {
    if (formKey.currentState!.validate()) {
      final categoryNotifier = ref.read(categoryProvider.notifier);
      if (isNew) {
        final category = CategoryEntity(
          name: titleController.text,
          color: selectedColor!.value,
          icon: selectedIcon!.codePoint,
        );
        await categoryNotifier.createCategory(category);
      } else {
        final category = CategoryEntity(
          id: widget.category!.id,
          name: titleController.text,
          color: selectedColor!.value,
          icon: selectedIcon!.codePoint,
        );
        await categoryNotifier.editCaterory(category);
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Categoria creada exitosamente')));
    }
  }
}
