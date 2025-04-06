import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,

      /// Altura estándar de un AppBar.
      child: Row(
        children: const [
          Text(
            'ToDo App',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.search),
        ],
      ),
    );
  }
}
