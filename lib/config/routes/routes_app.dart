import 'package:go_router/go_router.dart';
import 'package:todo_app_flutter/presentation/views/Home/home_view.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeView.name,
      builder: (contex, state) => HomeView(),
    ),
  ],
);
