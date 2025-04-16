// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:todo_app_flutter/presentation/providers/task_provider/task_provider.dart';

// * Formulario para crear o editar tareas
class TaskForm extends ConsumerStatefulWidget {
  final TaskEntity?
  task; // ? Si se pasa una tarea, es edición; si no, es creación
  const TaskForm({super.key, this.task});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final bool isNew; // ? Determina si estamos creando o editando
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    final item = widget.task;
    isNew = item == null; // * Si no hay tarea pasada, es nuevo
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    _dueDate = item?.dueDate; // * Carga la fecha si existe
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // * Campo de título
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título de la tarea'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa un título';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // * Campo de descripción
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          const SizedBox(height: 16),

          // * Selector de fecha
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Fecha límite:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(133, 229, 222, 222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _dueDate == null
                        ? '-------------'
                        : DateFormat.yMMMd().format(_dueDate!),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(133, 229, 222, 222),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
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

          // * Botón para guardar (agregar o editar)
          ElevatedButton(
            onPressed: () => _editCreateTaskasync(),
            child: Text(isNew ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  void _editCreateTaskasync() async {
    if (_formKey.currentState!.validate()) {
      final taskNotifier = ref.read(tasksProvider.notifier);

      if (isNew) {
        final newTask = TaskEntity(
          title: _titleController.text,
          description: _descriptionController.text,
          createdAt: DateTime.now(),
          dueDate: _dueDate,
          isCompleted: false,
        );

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
