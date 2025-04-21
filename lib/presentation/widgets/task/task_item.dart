import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:todo_app_flutter/presentation/widgets/task/task_form.dart';
import 'package:todo_app_flutter/presentation/providers/task_provider/task_provider.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class TaskItem extends ConsumerWidget {
  final TaskEntity task;
  final String title;
  final String description;

  const TaskItem({
    super.key,
    required this.task,
    required this.title,
    required this.description,
  });
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
          child: TaskForm(task: task),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Formatear la fecha si existe
    final dueDateText =
        task.dueDate != null
            ? 'Fecha límite: ${DateFormat.yMMMd().format(task.dueDate!)}'
            : 'Sin fecha límite';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ícono de estado (completado o pendiente)
              Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              // Contenido principal (título, descripción y fecha)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            task.isCompleted
                                ? Colors.green
                                : const Color.fromARGB(255, 171, 170, 170),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(135, 179, 178, 178),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dueDateText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(135, 179, 178, 178),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Acciones (Checkbox e ícono de eliminación)
              Column(
                children: [
                  IconButton(
                    onPressed: () => _showAddTaskModal(context),
                    icon: Icon(Icons.edit),
                  ),
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      if (value == null) return;

                      // Obtener el TaskNotifier desde el provider
                      final taskNotifier = ref.read(tasksProvider.notifier);

                      // Actualizar el estado de la tarea
                      await taskNotifier.toggleTaskCompletion(task);

                      // Mostrar un mensaje de éxito
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'Tarea marcada como completada'
                                : 'Tarea marcada como pendiente',
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Confirmar la eliminación
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
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        // Obtener el TaskNotifier desde el provider
                        final taskNotifier = ref.read(tasksProvider.notifier);

                        // Eliminar la tarea
                        await taskNotifier.deleteTask(task);

                        // Mostrar un mensaje de éxito
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarea eliminada exitosamente'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
