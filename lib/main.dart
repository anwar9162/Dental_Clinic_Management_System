import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'screens/patient/patient_bloc/patient_bloc.dart';
import 'screens/patient/patient_bloc/payment_bloc.dart'; // Import PaymentBloc
import 'services/patient_api_service.dart'; // Import the PatientApiService
import 'services/doctor_api_service.dart';
import 'screens/doctor/blocs/doctor_bloc.dart';
import 'screens/doctor/blocs/doctor_detail_bloc.dart'; // Import DoctorDetailBloc
import 'utils/constants.dart'; // Ensure this import is correct based on your file structure
import 'widgets/main_screen_widget.dart';

void main() {
  final patientApiService =
      PatientApiService(); // Create an instance of PatientApiService
  final doctorApiService = DoctorApiService();

  runApp(MyApp(
      patientApiService: patientApiService,
      doctorApiService: doctorApiService));
}

class MyApp extends StatelessWidget {
  final PatientApiService patientApiService;
  final DoctorApiService doctorApiService;

  MyApp({required this.patientApiService, required this.doctorApiService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
        BlocProvider(
          create: (context) => PatientBloc(patientApiService),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(patientApiService),
        ),
        BlocProvider(
          create: (context) => DoctorBloc(doctorApiService),
        ),
        BlocProvider(
          create: (context) =>
              DoctorDetailBloc(doctorApiService), // Provide DoctorDetailBloc
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
