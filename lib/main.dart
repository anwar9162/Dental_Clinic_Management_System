import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/patient/patient_list_screen.dart';
import 'screens/appointment/appointment_list_screen.dart';
import 'screens/doctor/doctor_list_screen.dart';
import 'screens/billing/billing_list_screen.dart';
import 'screens/appointment/add_appointment_screen.dart';
import 'screens/appointment/appointment_detail_screen.dart';
import 'screens/appointment/appointment_calendar_screen.dart';
import 'screens/patient/patient_record_screen.dart';
import 'models/patient_model.dart';
import 'models/appointment_model.dart';
import 'providers/appointment_provider.dart';
import 'widgets/navigation_drawer.dart';
import 'utils/constants.dart'; // Ensure this import is correct based on your file structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppointmentProvider(),
      child: MaterialApp(
        title: 'Dental Clinic Management',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor:
              backgroundColor, // Set the background color for the Scaffold

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/patients': (context) => PatientListScreen(),
          '/appointments': (context) => AppointmentListScreen(),
          '/appointment-calendar': (context) => AppointmentCalendarScreen(),
          '/doctors': (context) => DoctorListScreen(),
          '/billing': (context) => BillingListScreen(),
          '/add-appointment': (context) => AddAppointmentScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/patientrecord') {
            final patient = settings.arguments as Patient;
            return MaterialPageRoute(
              builder: (context) => PatientRecordScreen(patient: patient),
            );
          }
          if (settings.name == '/appointment-detail') {
            final appointment = settings.arguments as Appointment;
            return MaterialPageRoute(
              builder: (context) =>
                  AppointmentDetailScreen(appointment: appointment),
            );
          }
          return null;
        },
      ),
    );
  }
}
