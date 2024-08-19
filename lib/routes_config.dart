// routes_config.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home/home_screen.dart';
import 'screens/patient/medical_information_screen.dart';
import 'screens/appointment/appointment_list_screen.dart';
import 'screens/doctor/doctor_list_screen.dart';
import 'screens/billing/billing_list_screen.dart';
import 'screens/appointment/add_appointment_screen.dart';
import 'screens/appointment/appointment_calendar_screen.dart';
import 'screens/patient/patient_list_screen.dart';
import 'screens/Tele_Medicine/telemedicine_screen.dart';
import 'widgets/navigation_drawer.dart'; // Import CustomNavigationDrawer
import 'main_scaffold.dart'; // Import MainScaffold

class RouteConfig {
  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, HomeScreen(), state),
        ),
        GoRoute(
          path: '/medical-information',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, MedicalInformationScreen(), state),
        ),
        GoRoute(
          path: '/patient-lists',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, PatientListScreen(), state),
        ),
        GoRoute(
          path: '/appointments',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, AppointmentListScreen(), state),
        ),
        GoRoute(
          path: '/appointment-calendar',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, AppointmentCalendarScreen(), state),
        ),
        GoRoute(
          path: '/doctors',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, DoctorListScreen(), state),
        ),
        GoRoute(
          path: '/billing',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, BillingListScreen(), state),
        ),
        GoRoute(
          path: '/add-appointment',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, AddAppointmentScreen(), state),
        ),
        GoRoute(
          path: '/Telemedicine',
          pageBuilder: (context, state) =>
              _buildPageWithDrawer(context, TelemedicineScreen(), state),
        ),
        // Add more routes as needed
      ],
    );
  }

  static Page<void> _buildPageWithDrawer(
      BuildContext context, Widget page, GoRouterState state) {
    return MaterialPage(
      child: MainScaffold(
        child: page,
        currentRoute:
            state.uri.toString(), // Get current route from GoRouterState
      ),
    );
  }
}
