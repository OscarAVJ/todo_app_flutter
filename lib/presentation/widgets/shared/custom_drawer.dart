import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_flutter/config/items/items_app.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int navDrawerIndex = 0;
  void navigationMenu(value) {
    final manuItem = todoAppMenu[value];
    context.push(manuItem.route);
  }

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    return NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = (value);
          widget.scaffoldKey.currentState?.closeDrawer();
        });
        navigationMenu(value);
      },
      children: [
        Padding(padding: EdgeInsets.fromLTRB(28, hasNotch ? 10 : 20, 16, 10)),
        ...todoAppMenu
            .sublist(0, 2)
            .map(
              (item) => NavigationDrawerDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              ),
            ),
      ],
    );
  }
}
