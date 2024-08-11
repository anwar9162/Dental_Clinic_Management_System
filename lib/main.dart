import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'screens/patient/patient_bloc/patient_bloc.dart';
import 'screens/patient/patient_bloc/payment_bloc.dart';
import 'services/patient_api_service.dart';
import 'services/doctor_api_service.dart';
import 'services/appointment_api_service.dart';
import 'screens/doctor/blocs/doctor_bloc.dart';
import 'screens/doctor/blocs/doctor_detail_bloc.dart';
import 'screens/appointment/blocs/appointment_bloc.dart';
import 'utils/constants.dart';
import 'widgets/main_screen_widget.dart';

void main() {
  final patientApiService = PatientApiService();
  final doctorApiService = DoctorApiService();
  final appointmentApiService =
      AppointmentService(); // Corrected the service name

  runApp(MyApp(
    patientApiService: patientApiService,
    doctorApiService: doctorApiService,
    appointmentService: appointmentApiService, // Corrected the parameter name
  ));
}

class MyApp extends StatelessWidget {
  final PatientApiService patientApiService;
  final DoctorApiService doctorApiService;
  final AppointmentService appointmentService; // Corrected type

  MyApp({
    required this.patientApiService,
    required this.doctorApiService,
    required this.appointmentService,
  });

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
          create: (context) => DoctorDetailBloc(doctorApiService),
        ),
        BlocProvider(
          create: (context) => AppointmentBloc(appointmentService),
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
