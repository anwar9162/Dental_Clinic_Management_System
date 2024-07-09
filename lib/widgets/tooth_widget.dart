import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class ToothWidget extends StatelessWidget {
  final Tooth tooth;

  ToothWidget({required this.tooth});

  @override
  Widget build(BuildContext context) {
    String imagePath =
        'assets/images/${tooth.type.toLowerCase()}_${tooth.condition.toLowerCase()}.jpg';

    return Tooltip(
      message:
          "Tooth ${tooth.number}: ${tooth.condition}\nNotes: ${tooth.notes}",
      child: Container(
        // Adjust width and height as needed to control image size
        width: 50, // Example width
        height: 50, // Example height
        padding: EdgeInsets.all(4), // Optional padding for the image
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain, // Ensure the image fits within the container
        ),
      ),
    );
  }
}
