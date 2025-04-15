import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/presentation/screens/home/all_tab.dart';
import 'package:todo_app_flutter/presentation/screens/home/compleated_tab.dart';
import 'package:todo_app_flutter/presentation/screens/home/pending_tab.dart';
import 'package:todo_app_flutter/presentation/widgets/shared/custom_app_bar.dart';
import 'package:todo_app_flutter/presentation/widgets/shared/custom_drawer.dart';
import 'package:todo_app_flutter/presentation/widgets/task/task_form.dart';

class HomeView extends ConsumerStatefulWidget {
  //! Nombre de ruta estática para navegación
  static const name = 'home_screen';
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    //! Envuelve todo en un controlador de pestañas con 3 tabs
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        /// Drawer lateral personalizado
        drawer: CustomDrawer(scaffoldKey: GlobalKey<ScaffoldState>()),

        /// NestedScrollView permite usar Slivers + TabBarView correctamente
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                //! AppBar superior que se queda fija (pinned)
                SliverAppBar(
                  title: const CustomAppBar(),
                  pinned: true,
                  floating: false,
                  expandedHeight: 0, // no se expande
                ),

                /// Sección de bienvenida antes de las pestañas
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '¡Bienvenido a tu lista de tareas!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                //! TabBar que queda pegado al tope cuando se hace scroll
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    tabBar: const TabBar(
                      tabs: [
                        Tab(text: 'Todos'),
                        Tab(text: 'Completados'),
                        Tab(text: 'Pendientes'),
                      ],
                    ),
                  ),
                ),
              ],
          //! Contenido de cada pestaña
          body: const TabBarView(
            children: [AllTab(), CompletedTab(), PendingTab()],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskModal(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Método para mostrar el modal con el formulario
  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: TaskForm(),
        );
      },
    );
  }
}

/// Widget del formulario para agregar una nueva tarea

///
/// Delegate para renderizar el TabBar dentro del SliverPersistentHeader
///
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    //! Fondo dinámico que se adapta al modo oscuro/claro
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
