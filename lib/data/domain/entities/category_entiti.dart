import 'package:isar/isar.dart';
part 'category_entiti.g.dart';

@collection
class CategoryEntity {
  Id id;

  final String name;
  final int color; // Puedes guardar un color como entero (Colors.red.value)
  final int? icon;

  CategoryEntity({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.color,
    this.icon,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
