/*import 'package:flutter/material.dart';
import 'navigation_drawer.dart'; // Import your custom drawer
import '../screens/home/home_screen.dart';
import '../screens/patient/medical_information_screen.dart';
import '../screens/appointment/appointment_list_screen.dart';
import '../screens/doctor/doctor_list_screen.dart';
import '../screens/billing/billing_list_screen.dart';
import '../screens/appointment/add_appointment_screen.dart';
import '../screens/appointment/appointment_calendar_screen.dart';
import '../screens/patient/patient_list_screen.dart';
import '../screens/Tele_Medicine/telemedicine_screen.dart';

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
      drawer: CustomNavigationDrawer(
        onMenuTap: _onMenuTap,
        selectedRoute: _currentScreen, // Pass the current route here
      ),
      appBar: AppBar(
        title: Text('Dental Clinic Management'),
      ),
      body: Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (_currentScreen) {
            case '/':
              builder = (context) => HomeScreen();
              break;
            case '/medical-information':
              builder = (context) => MedicalInformationScreen();
              break;
            case '/patient-lists':
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
            case '/Telemedicine':
              builder = (context) => TelemedicineScreen();
              break;
            default:
              builder = (context) => HomeScreen();
              break;
          }
          return MaterialPageRoute(builder: builder);
        },
      ),
    );
  }
}
*/