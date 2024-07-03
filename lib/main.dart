import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/patient/patient_list_screen.dart';
import 'screens/appointment/appointment_list_screen.dart';
import 'screens/doctor/doctor_list_screen.dart';
import 'screens/billing/billing_list_screen.dart';
import 'screens/appointment/add_appointment_screen.dart';
import 'screens/appointment/appointment_detail_screen.dart';
import 'screens/appointment/appointment_calendar_screen.dart';
import './models/appointment_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Clinic Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        '/appointment-detail': (context) => AppointmentDetailScreen(
            appointment:
                ModalRoute.of(context)!.settings.arguments as Appointment),
      },
    );
  }
}
