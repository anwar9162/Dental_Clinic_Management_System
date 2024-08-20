import 'package:flutter/material.dart';
import 'navigation_drawer.dart' as custom_drawer;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          custom_drawer.NavigationDrawer(
            currentRoute: widget.currentRoute,
            isExpanded: _isDrawerExpanded,
            onToggleDrawer: _toggleDrawer,
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
