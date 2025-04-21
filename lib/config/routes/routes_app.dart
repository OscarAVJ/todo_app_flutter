import 'package:go_router/go_router.dart';
import 'package:todo_app_flutter/presentation/views/Home/home_view.dart';
import 'package:todo_app_flutter/presentation/views/category/category_view.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeView.name,
      builder: (contex, state) => HomeView(),
    ),
    GoRoute(
      path: '/category',
      name: CategoryView.name,
      builder: (contex, state) => CategoryView(),
    ),
  ],
);
