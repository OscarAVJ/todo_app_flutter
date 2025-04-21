// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:todo_app_flutter/presentation/providers/category_provider/category_provider.dart';
import 'package:todo_app_flutter/presentation/providers/task_provider/task_provider.dart';

class TaskForm extends ConsumerStatefulWidget {
  final TaskEntity? task;

  const TaskForm({super.key, this.task});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  ///Declaramos los controladores de nuestro formulario
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final bool isNew;
  DateTime? _dueDate;
  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final item = widget.task;
    isNew = item == null;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    _dueDate = item?.dueDate;

    if (!isNew) {
      widget.task!.category.load().then((_) {
        setState(() {
          _selectedCategory = widget.task!.category.value;
        });
      });
    }
  }

  @override
  void dispose() {
    ///Cancelamos nuestros controladores
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
              ),

              ///Validacion para el formulario
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Por favor ingresa un título'
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),

            /// Selector de fecha
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Fecha límite:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _dueDate == null
                          ? '-------------'
                          : DateFormat.yMMMd().format(_dueDate!),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    ///Con este metodo abrimos un datePicker
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dueDate = selectedDate;
                      });
                    }
                  },
                  child: const Text('Seleccionar fecha'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ///Dropdown de categoría
            _DropDownButton(
              initialCategory: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),

            ///Boton de confirmacion
            ElevatedButton(
              onPressed: _editCreateTaskasync,
              child: Text(isNew ? 'Agregar' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _editCreateTaskasync() async {
    if (_formKey.currentState!.validate()) {
      ///Hacemos un red al taskProvider para poder ejecutar el metodo create o edit segun corresponda
      final taskNotifier = ref.read(tasksProvider.notifier);

      if (isNew) {
        final newTask = TaskEntity(
          title: _titleController.text,
          description: _descriptionController.text,
          createdAt: DateTime.now(),
          dueDate: _dueDate,
          isCompleted: false,
        );
        if (_selectedCategory != null) {
          newTask.category.value = _selectedCategory!;
        }

        await taskNotifier.addTask(newTask);
      } else {
        final updatedTask = TaskEntity(
          id: widget.task!.id, // 👈 necesario para actualizar en Isar
          title: _titleController.text,
          description: _descriptionController.text,
          createdAt: widget.task!.createdAt,
          dueDate: _dueDate,
          isCompleted: widget.task!.isCompleted,
        );
        if (_selectedCategory != null) {
          updatedTask.category.value = _selectedCategory!;
        }

        await taskNotifier.editTask(updatedTask);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNew
                ? 'Tarea creada exitosamente'
                : 'Tarea actualizada exitosamente',
          ),
        ),
      );
    }
  }
}

class _DropDownButton extends ConsumerStatefulWidget {
  final Function(CategoryEntity?) onChanged;
  final CategoryEntity? initialCategory;

  const _DropDownButton({required this.onChanged, this.initialCategory});

  @override
  ConsumerState<_DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends ConsumerState<_DropDownButton> {
  CategoryEntity? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadAllCat();
  }

  //! Este método detecta si el widget cambió y actualiza selectedCategory si es necesario
  @override
  void didUpdateWidget(covariant _DropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialCategory != null &&
        (oldWidget.initialCategory == null ||
            widget.initialCategory!.id != oldWidget.initialCategory!.id)) {
      setState(() {
        selectedCategory = widget.initialCategory; //! sincroniza con el padre
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return DropdownButtonFormField<CategoryEntity>(
      value: selectedCategory,
      decoration: const InputDecoration(labelText: 'Categoría'),
      items:
          categories.map((cat) {
            return DropdownMenuItem<CategoryEntity>(
              value: cat,
              child: Text(cat.name),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
        widget.onChanged(value);
      },
    );
  }

  Future<void> loadAllCat() async {
    await ref.read(categoryProvider.notifier).loadAllCategories();
  }
}
