import 'package:isar/isar.dart';
part 'category_entiti.g.dart';

@collection
class CategoryEntity {
  Id id = Isar.autoIncrement;

  final String name;
  final int color; // Puedes guardar un color como entero (Colors.red.value)
  final int? icon;

  CategoryEntity({required this.name, required this.color, this.icon});
}
