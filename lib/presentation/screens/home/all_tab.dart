import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/presentation/widgets/task/task_item.dart';
import 'package:todo_app_flutter/presentation/providers/task_provider/task_provider.dart';

//!Tab bar con todas las tareas
class AllTab extends ConsumerStatefulWidget {
  const AllTab({super.key});

  @override
  AllTabState createState() => AllTabState();
}

class AllTabState extends ConsumerState<AllTab> {
  ///Declaramos variables
  bool isLoading = false;
  bool isLastPage = false;

  ///Metodo para cargar la siguiente pagina
  void loadNextPage() async {
    //!Si is loading o isLastPage es verdadero, no hacemos nada
    if (isLoading || isLastPage) return;

    ///isLoading pasa a ser verdadero
    isLoading = true;

    ///Llamamos al provider de tareas para cargar la siguiente pagina
    final newTasks = await ref.read(tasksProvider.notifier).loadNextPage();

    ///Como ya termino la accion isLoading pasa a ser falso
    isLoading = false;

    ///Si no hay tareas, isLastPage pasa a ser verdadero y por ende al hacer scroll no se ejecuta el metodo
    if (newTasks.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ///Llamamos al provider de tareas para cargar la primera pagina
      loadNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent - 100) {
          loadNextPage();
        }
        return false;
      },
      child:
          tasks.isEmpty
              ? const Center(child: Text('No hay tareas disponibles.'))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskItem(
                    task: task,
                    title: task.title,
                    description: task.description ?? '',
                  );
                },
              ),
    );
  }
}
