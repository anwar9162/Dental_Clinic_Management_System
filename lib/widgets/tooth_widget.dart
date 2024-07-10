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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 1),
                color: tooth.notes.contains('Needs')
                    ? Colors.red[100]
                    : Colors.green[100],
              ),
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${tooth.type}\n${tooth.notes}',
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showMarkDialog(BuildContext context) {
    TextEditingController notesController =
        TextEditingController(text: tooth.notes);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mark Tooth ${tooth.number}'),
          content: TextField(
            controller: notesController,
            decoration: InputDecoration(
              hintText: 'Enter notes or issues...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (notesController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notes cannot be empty')));
                  return;
                }

                tooth.notes = notesController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tooth updated successfully')));
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
