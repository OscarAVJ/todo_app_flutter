import 'package:flutter/material.dart';

class PendingTab extends StatelessWidget {
  const PendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No hay tareas pendientes.'),
            ),
          ),
        ),
      ],
    );
  }
}
