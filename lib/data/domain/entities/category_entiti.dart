import 'package:isar/isar.dart';

@collection
class CategoryEntity {
  Id id = Isar.autoIncrement;

  final String name;

  CategoryEntity({required this.name});
}
