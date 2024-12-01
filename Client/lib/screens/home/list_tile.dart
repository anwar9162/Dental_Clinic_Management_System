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
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Row(
        children: [
          Expanded(
            child: Text(
              '$firstName $lastName',
              style: textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        '($gender, DOB: $dateOfBirth)',
        style: textStyle.copyWith(
          fontSize: 14,
          color: Colors.black54,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
