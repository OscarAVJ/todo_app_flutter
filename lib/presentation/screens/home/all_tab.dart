import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/presentation/widgets/task/task_item.dart';
import 'package:todo_app_flutter/providers/task_provider/task_provider.dart';

class AllTab extends ConsumerStatefulWidget {
  const AllTab({super.key});

  @override
  AllTabState createState() => AllTabState();
}

class AllTabState extends ConsumerState<AllTab> {
  bool isLoading = false;
  bool isLastPage = false;

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;

    final newTasks = await ref.read(tasksProvider.notifier).loadNextPage();

    isLoading = false;
    if (newTasks.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
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
