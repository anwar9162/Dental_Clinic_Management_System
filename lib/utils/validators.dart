// utils/validators.dart

String? requiredFieldValidator(String? value,
    {String fieldName = 'This field'}) {
  if (value == null || value.isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

String? dateValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date is required';
  }
  return null;
}

// Add more validators as needed
