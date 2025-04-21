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
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late bool isNew;
  Color? selectedColor;
  IconData? selectedIcon;

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
    Color(0xFFFF1100),
    Color(0xFF00FF08),
    Color(0xFF008CFF),
    Color(0xFFFF9900),
    Color(0xFFD900FF),
    Color(0xFF00FFE5),
    Color(0xFFFF0055),
    Color(0xFFFF7644),
    Color(0xFF00E1FF),
  ];

  @override
  void initState() {
    super.initState();
    isNew = widget.category == null;
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
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Título del formulario
            Row(
              children: [
                Expanded(
                  child: Text(
                    isNew ? 'Nueva Categoría' : 'Editar Categoría',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Campo de texto
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Nombre de la categoría',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? 'Campo obligatorio'
                          : null,
            ),

            const SizedBox(height: 24),

            /// Selector de color
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Color', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 18,
              runSpacing: 15,
              children:
                  availableColors.map((color) {
                    final isSelected = selectedColor?.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedColor = color);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 20,
                          child:
                              isSelected
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            /// Selector de íconos
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Ícono', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 15,
              children:
                  iconOptions.map((icon) {
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIcon = icon);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? Colors.blue.shade100
                                  : Colors.grey[200],
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 24,
                          color: isSelected ? Colors.blue : Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            /// Botón Guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  isNew ? 'Crear Categoría' : 'Actualizar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    createCategory();
                  }
                },
              ),
            ),
          ],
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
