import 'package:isar/isar.dart';
part 'category_entiti.g.dart';

@collection
class CategoryEntity {
  Id id = Isar.autoIncrement;

  final String name;

  CategoryEntity({required this.name});
}
