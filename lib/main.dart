import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';

import 'utils/constants.dart'; // Ensure this import is correct based on your file structure
import 'widgets/main_screen_widget.dart';

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
          scaffoldBackgroundColor: backgroundColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
