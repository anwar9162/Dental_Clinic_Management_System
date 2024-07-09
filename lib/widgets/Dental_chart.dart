import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../widgets/tooth_widget.dart';

class DentalChart extends StatelessWidget {
  final List<Tooth> dentalChart;

  DentalChart({required this.dentalChart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Upper Teeth
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dentalChart
              .where((tooth) => tooth.isUpper)
              .map((tooth) => ToothWidget(tooth: tooth))
              .toList(),
        ),
        SizedBox(height: 20),
        // Lower Teeth
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dentalChart
              .where((tooth) => !tooth.isUpper)
              .map((tooth) => ToothWidget(tooth: tooth))
              .toList(),
        ),
      ],
    );
  }
}
