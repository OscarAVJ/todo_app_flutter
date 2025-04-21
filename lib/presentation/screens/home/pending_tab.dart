import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/domain/entities/task_entity.dart';
import 'package:todo_app_flutter/presentation/providers/task_provider/task_provider.dart';
import 'package:todo_app_flutter/presentation/widgets/task/task_item.dart';

class PendingTab extends ConsumerStatefulWidget {
  final List<TaskEntity> tasks; // Cambiar a una lista de tareas

  const PendingTab({super.key, required this.tasks});

  @override
  PendingTabState createState() => PendingTabState();
}

class PendingTabState extends ConsumerState<PendingTab> {
  ///Declaramos variables
  bool isLoading = false;
  bool isLastPage = false;
  void loadNextPage() async {
    //!Si is loading o isLastPage es verdadero, no hacemos nada
    if (isLoading || isLastPage) return;

    ///isLoading pasa a ser verdadero
    isLoading = true;

    ///Llamamos al provider de tareas para cargar la siguiente pagina
    final newTasks = await ref.read(tasksProvider.notifier).loadParameter2();

    ///Como ya termino la accion isLoading pasa a ser falso
    isLoading = false;

    ///Si no hay tareas, isLastPage pasa a ser verdadero y por ende al hacer scroll no se ejecuta el metodo
    if (newTasks.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.isEmpty) {
      return const Center(child: Text('No hay tareas completadas.'));
    }

    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return TaskItem(
          task: task,
          title: task.title,
          description: task.description.toString(),
        );
      },
    );
  }
}
