// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/appointment_provider.dart';
import 'screens/patient/patient_bloc/patient_bloc.dart';
import 'screens/patient/patient_bloc/payment_bloc.dart';
import 'services/patient_api_service.dart';
import 'services/doctor_api_service.dart';
import 'services/appointment_api_service.dart';
import 'services/arrival_service.dart';
import 'screens/doctor/blocs/doctor_bloc.dart';
import 'screens/doctor/blocs/doctor_detail_bloc.dart';
import 'screens/appointment/blocs/appointment_bloc.dart';
import 'screens/home/blocs/arrival_bloc.dart';
import 'utils/constants.dart';
import 'routes_config.dart'; // Import your route configuration

void main() {
  final patientApiService = PatientApiService();
  final doctorApiService = DoctorApiService();
  final appointmentApiService = AppointmentService();
  final arrivalService = ArrivalService();

  runApp(MyApp(
    patientApiService: patientApiService,
    doctorApiService: doctorApiService,
    appointmentService: appointmentApiService,
    arrivalService: arrivalService,
  ));
}

class MyApp extends StatelessWidget {
  final PatientApiService patientApiService;
  final DoctorApiService doctorApiService;
  final AppointmentService appointmentService;
  final ArrivalService arrivalService;

  MyApp({
    required this.patientApiService,
    required this.doctorApiService,
    required this.appointmentService,
    required this.arrivalService,
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
          create: (context) => ArrivalBloc(arrivalService),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: RouteConfig.returnRouter(),
        title: 'Dental Clinic Management',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: backgroundColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
