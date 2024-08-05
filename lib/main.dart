import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'screens/patient/patient_bloc/patient_bloc.dart';
import 'screens/patient/patient_bloc/payment_bloc.dart'; // Import PaymentBloc
import 'services/patient_api_service.dart'; // Import the PatientApiService
import 'utils/constants.dart'; // Ensure this import is correct based on your file structure
import 'widgets/main_screen_widget.dart';

void main() {
  final patientApiService =
      PatientApiService(); // Create an instance of PatientApiService

  runApp(MyApp(patientApiService: patientApiService));
}

class MyApp extends StatelessWidget {
  final PatientApiService patientApiService;

  MyApp({required this.patientApiService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
        BlocProvider(
          create: (context) => PatientBloc(
              patientApiService), // Provide PatientApiService to PatientBloc
        ),
        BlocProvider(
          create: (context) =>
              PaymentBloc(patientApiService), // Provide PaymentBloc
        ),
      ],
      child: MaterialApp(
        title: 'Dental Clinic Management',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: backgroundColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
