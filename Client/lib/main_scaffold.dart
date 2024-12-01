import 'package:flutter/material.dart';
import 'navigation_drawer.dart' as custom_drawer;
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation

class MainScaffold extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  MainScaffold({required this.child, required this.currentRoute});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool _isDrawerExpanded = true;

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }

  void _logout() {
    // Handle log out logic here
    // For example, clear user session and navigate to login page
    GoRouter.of(context).go('/login'); // Replace with your actual login route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          custom_drawer.NavigationDrawer(
            currentRoute: widget.currentRoute,
            isExpanded: _isDrawerExpanded,
            onToggleDrawer: _toggleDrawer,
            onLogout: _logout, // Pass the log out callback
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
