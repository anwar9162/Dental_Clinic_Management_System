import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/patient_model.dart';

class ToothWidget extends StatelessWidget {
  final Tooth tooth;

  ToothWidget({required this.tooth});

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/${tooth.type.toLowerCase()}.svg';
    Color bgColor =
        tooth.notes.contains('Needs') ? Colors.red[100]! : Colors.green[100]!;

    return GestureDetector(
      onTap: () => _showMarkDialog(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            message: "Tooth ${tooth.number}\nNotes: ${tooth.notes}",
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1),
                color: bgColor,
              ),
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tooth ${tooth.number}\n${tooth.notes}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
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
          title: Text('Update Tooth ${tooth.number}'),
          content: TextField(
            controller: notesController,
            decoration: InputDecoration(
              hintText: 'Enter notes or issues...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
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
