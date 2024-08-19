// main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/navigation_drawer.dart'; // Ensure this path is correct

class MainScaffold extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  MainScaffold({required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationDrawer(
        onMenuTap: (route, {Object? arguments}) {
          GoRouter.of(context).go(route);
        },
        selectedRoute: currentRoute,
      ),
      body: child,
    );
  }
}
