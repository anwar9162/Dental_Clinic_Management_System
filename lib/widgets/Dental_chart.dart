import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../widgets/tooth_widget.dart';

class DentalChart extends StatelessWidget {
  final List<Tooth> dentalChart;

  DentalChart({required this.dentalChart});

  @override
  Widget build(BuildContext context) {
    List<Widget> upperTeeth = [];
    List<Widget> lowerTeeth = [];

    for (int i = 0; i < dentalChart.length; i++) {
      if (dentalChart[i].isUpper) {
        upperTeeth.add(Expanded(child: ToothWidget(tooth: dentalChart[i])));
      } else {
        lowerTeeth.add(Expanded(child: ToothWidget(tooth: dentalChart[i])));
      }
    }

    return Column(
      children: [
        // Upper Teeth
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            ...upperTeeth.sublist(0, 8), // First 8 upper teeth
            SizedBox(width: 20),
            ...upperTeeth.sublist(8, 16), // Next 8 upper teeth
          ],
        ),
        SizedBox(height: 20),
        // Lower Teeth
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            ...lowerTeeth.sublist(0, 8), // First 8 lower teeth
            SizedBox(width: 20),
            ...lowerTeeth.sublist(8, 16), // Next 8 lower teeth
          ],
        ),
      ],
    );
  }
}
