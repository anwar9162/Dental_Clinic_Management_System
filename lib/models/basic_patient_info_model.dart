class PatientBasicInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  PatientBasicInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  factory PatientBasicInfo.fromJson(Map<String, dynamic> json) {
    return PatientBasicInfo(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
