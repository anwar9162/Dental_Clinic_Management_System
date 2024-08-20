import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawer extends StatelessWidget {
  final String currentRoute;
  final bool isExpanded;
  final VoidCallback onToggleDrawer;

  NavigationDrawer({
    required this.currentRoute,
    required this.isExpanded,
    required this.onToggleDrawer,
  });

  @override
  Widget build(BuildContext context) {
    double drawerWidth = isExpanded ? 250.0 : 50.0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: drawerWidth,
      color: Color(0xFF6ABEDC),
      child: Column(
        children: [
          // Smaller, more stylish header
          Container(
            height: isExpanded ? 100.0 : 50.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6ABEDC), Color(0xFF6ABEDC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: isExpanded
                ? Row(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 36.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'DentistFlow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 36.0,
                  ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  title: 'Home',
                  icon: Icons.home,
                  route: '/',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
                _buildDrawerItem(
                  context: context,
                  title: 'Medical Info',
                  icon: Icons.info,
                  route: '/medical-information',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
                _buildDrawerItem(
                  context: context,
                  title: 'Patient Lists',
                  icon: Icons.list,
                  route: '/patient-lists',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
                _buildDrawerItem(
                  context: context,
                  title: 'Appointments',
                  icon: Icons.calendar_today,
                  route: '/appointments',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
                _buildDrawerItem(
                  context: context,
                  title: 'Calendar',
                  icon: Icons.calendar_view_day,
                  route: '/appointment-calendar',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
                _buildDrawerItem(
                  context: context,
                  title: 'Doctors',
                  icon: Icons.local_hospital,
                  route: '/doctors',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
                _buildDrawerItem(
                  context: context,
                  title: 'Telemedicine',
                  icon: Icons.videocam,
                  route: '/Telemedicine',
                  currentRoute: currentRoute,
                  isExpanded: isExpanded,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isExpanded ? Icons.arrow_back : Icons.arrow_forward),
            color: Colors.white,
            onPressed: onToggleDrawer,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
    required bool isExpanded,
  }) {
    final bool isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white70,
      ),
      title: isExpanded
          ? Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          : null,
      selected: isSelected,
      selectedTileColor: Colors.white24,
      onTap: () {
        GoRouter.of(context).go(route);
      },
    );
  }
}
