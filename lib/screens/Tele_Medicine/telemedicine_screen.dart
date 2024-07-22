import 'package:flutter/material.dart';

class TelemedicineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telemedicine'),
        backgroundColor: Colors.teal, // Set the background color of the app bar
      ),
      body: Center(
        child: Text(
          'Telemedicine Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
