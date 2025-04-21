import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String route;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

const todoAppMenu = <MenuItem>[
  MenuItem(title: 'Inicio', icon: Icons.home, route: '/'),
  MenuItem(title: 'Categorias', icon: Icons.category, route: '/category'),
];
  // MenuItems(
  //   title: 'Counter',
  //   subTitle: 'A lot of numbers',
  //   route: '/counter_screen',
  //   icon: Icons.add,
  // ),