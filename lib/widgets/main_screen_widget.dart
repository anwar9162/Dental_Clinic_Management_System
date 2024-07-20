import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/patient/patient_list_screen.dart';
import '../screens/appointment/appointment_list_screen.dart';
import '../screens/doctor/doctor_list_screen.dart';
import '../screens/billing/billing_list_screen.dart';
import '../screens/appointment/add_appointment_screen.dart';
import '../screens/appointment/appointment_calendar_screen.dart';
import '../widgets/navigation_drawer.dart';
import '../screens/patient/patient_record_screen.dart';
import '../models/patient_model.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentScreen = '/';
  Object? _arguments;

  void _onMenuTap(String route, {Object? arguments}) {
    setState(() {
      _currentScreen = route;
      _arguments = arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomNavigationDrawer(onMenuTap: _onMenuTap),
          Expanded(
            child: Navigator(
              key: GlobalKey<
                  NavigatorState>(), // Ensure each navigator has a unique key
              onGenerateRoute: (settings) {
                WidgetBuilder builder;
                switch (_currentScreen) {
                  case '/':
                    builder = (context) => HomeScreen();
                    break;
                  case '/patients':
                    builder = (context) => PatientListScreen();
                    break;
                  case '/appointments':
                    builder = (context) => AppointmentListScreen();
                    break;
                  case '/appointment-calendar':
                    builder = (context) => AppointmentCalendarScreen();
                    break;
                  case '/doctors':
                    builder = (context) => DoctorListScreen();
                    break;
                  case '/billing':
                    builder = (context) => BillingListScreen();
                    break;
                  case '/add-appointment':
                    builder = (context) => AddAppointmentScreen();
                    break;
                  case '/patientrecord':
                    builder = (context) =>
                        PatientRecordScreen(patient: _arguments as Patient);
                    break;
                  default:
                    builder = (context) => HomeScreen();
                    break;
                }
                return MaterialPageRoute(builder: builder);
              },
            ),
          ),
        ],
      ),
    );
  }
}
