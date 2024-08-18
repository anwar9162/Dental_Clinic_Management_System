import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'screens/patient/patient_bloc/patient_bloc.dart';
import 'screens/patient/patient_bloc/payment_bloc.dart';
import 'services/patient_api_service.dart';
import 'services/doctor_api_service.dart';
import 'services/appointment_api_service.dart';
import 'services/arrival_service.dart'; // Import the arrival service
import 'screens/doctor/blocs/doctor_bloc.dart';
import 'screens/doctor/blocs/doctor_detail_bloc.dart';
import 'screens/appointment/blocs/appointment_bloc.dart';
import 'screens/home/blocs/arrival_bloc.dart'; // Import the arrival bloc
import 'utils/constants.dart';
import 'widgets/main_screen_widget.dart';

void main() {
  final patientApiService = PatientApiService();
  final doctorApiService = DoctorApiService();
  final appointmentApiService = AppointmentService();
  final arrivalService =
      ArrivalService(); // Create an instance of ArrivalService

  runApp(MyApp(
    patientApiService: patientApiService,
    doctorApiService: doctorApiService,
    appointmentService: appointmentApiService,
    arrivalService: arrivalService, // Pass ArrivalService to MyApp
  ));
}

class MyApp extends StatelessWidget {
  final PatientApiService patientApiService;
  final DoctorApiService doctorApiService;
  final AppointmentService appointmentService;
  final ArrivalService arrivalService; // Add ArrivalService

  MyApp({
    required this.patientApiService,
    required this.doctorApiService,
    required this.appointmentService,
    required this.arrivalService, // Add ArrivalService
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          create: (context) => DoctorDetailBloc(doctorApiService),
        ),
        BlocProvider(
          create: (context) => AppointmentBloc(appointmentService),
        ),
        BlocProvider(
          create: (context) => ArrivalBloc(arrivalService), // Add ArrivalBloc
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
