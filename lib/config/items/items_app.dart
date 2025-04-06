import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;

  const MenuItem({required this.title, required this.icon});
}

const todoAppMenu = <MenuItem>[
  MenuItem(title: 'Inicio', icon: Icons.home),
  MenuItem(title: 'Categorias', icon: Icons.category),
  MenuItem(title: 'Condifuracion', icon: Icons.settings),
  MenuItem(title: 'Categorias', icon: Icons.category),
  MenuItem(title: 'Categorias', icon: Icons.category),
  MenuItem(title: 'Categorias', icon: Icons.category),
];
