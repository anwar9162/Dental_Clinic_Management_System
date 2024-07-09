import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/patient_model.dart';

class ToothWidget extends StatelessWidget {
  final Tooth tooth;

  ToothWidget({required this.tooth});

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/${tooth.type.toLowerCase()}.svg';

    return GestureDetector(
      onTap: () => _showMarkDialog(context),
      child: Column(
        children: [
          Tooltip(
            message: "Tooth ${tooth.number}\nNotes: ${tooth.notes}",
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(4),
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${tooth.type}\n ${tooth.notes}',
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showMarkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mark Tooth ${tooth.number}'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter notes or issues...',
            ),
            onSubmitted: (value) {
              // Update the notes or issues for the tooth
              // This is where you would typically update the state
              tooth.notes = value;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
