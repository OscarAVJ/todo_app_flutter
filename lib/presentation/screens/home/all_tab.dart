import 'package:flutter/material.dart';
import 'package:todo_app_flutter/config/items/items_app.dart';

class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //! Lista de ítems renderizados dinámicamente
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final MenuItem item = todoAppMenu[index];
            return ItemsTab(item: item);
          }, childCount: todoAppMenu.length),
        ),
      ],
    );
  }
}

class ItemsTab extends StatelessWidget {
  final MenuItem item;

  const ItemsTab({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(item.title), leading: Icon(item.icon));
  }
}
