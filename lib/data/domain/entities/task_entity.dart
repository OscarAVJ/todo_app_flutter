import 'package:isar/isar.dart';
part 'task_entity.g.dart';

@collection
class TaskEntity {
  Id id;

  final String title;
  final String? description;
  final DateTime? createdAt;
  final DateTime? dueDate;
  bool isCompleted;
  final int? categoryId;

  TaskEntity({
    this.id = Isar.autoIncrement,
    required this.title,
    this.description,
    this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.categoryId,
  });
}
