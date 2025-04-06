import 'package:isar/isar.dart';

@collection
class TaskEntity {
  Id id = Isar.autoIncrement;

  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final int? categoryId;

  TaskEntity({
    required this.title,
    this.description,
    DateTime? createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.categoryId,
  }) : createdAt = createdAt ?? DateTime.now();
}
