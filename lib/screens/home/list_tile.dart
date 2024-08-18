import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final TextStyle textStyle;

  const ListTileWidget({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(firstName, style: textStyle),
          SizedBox(width: 8), // Space between first name and last name
          Text(lastName, style: textStyle),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gender: $gender', style: textStyle),
          Text('Date of Birth: $dateOfBirth', style: textStyle),
        ],
      ),
    );
  }
}
