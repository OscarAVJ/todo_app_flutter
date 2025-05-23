import 'package:isar/isar.dart';
import 'package:todo_app_flutter/data/domain/entities/category_entiti.dart';
part 'task_entity.g.dart';

@collection
class TaskEntity {
  Id id;

  final String title;
  final String? description;
  final DateTime? createdAt;
  final DateTime? dueDate;
  bool isCompleted;
  final IsarLink<CategoryEntity> category = IsarLink(); // Relación real

  TaskEntity({
    this.id = Isar.autoIncrement,
    required this.title,
    this.description,
    this.createdAt,
    this.dueDate,
    this.isCompleted = false,
  });
}
