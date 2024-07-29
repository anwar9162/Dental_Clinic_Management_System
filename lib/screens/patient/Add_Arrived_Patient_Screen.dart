import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddArrivedPatientScreen extends StatefulWidget {
  final VoidCallback onClose;

  const AddArrivedPatientScreen({Key? key, required this.onClose})
      : super(key: key);

  @override
  _AddArrivedPatientScreenState createState() =>
      _AddArrivedPatientScreenState();
}

class _AddArrivedPatientScreenState extends State<AddArrivedPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _arrivalTimeController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedPatient;

  // Sample patient data
  final List<Map<String, String>> _patients = [
    {'name': 'John Doe', 'phone': '123-456-7890'},
    {'name': 'Jane Smith', 'phone': '987-654-3210'},
    {'name': 'Alice Johnson', 'phone': '555-666-7777'},
    // Add more patient records here
  ];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a patient')),
        );
        return;
      }
      // Handle the form submission logic here
      widget.onClose(); // Close the form after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          width: 700, // Fixed width for the container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchableDropdown(),
                        SizedBox(height: 16),
                        _buildLabeledTextField(
                            'Arrival Time', _arrivalTimeController,
                            keyboardType: TextInputType.datetime),
                        SizedBox(height: 16),
                        _buildLabeledTextField('Notes', _notesController),
                        SizedBox(height: 24),
                        _buildSubmitButton(),
                        SizedBox(height: 16),
                        _buildCancelButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Add Arrived Patient',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown() {
    return DropdownSearch<String>(
      items: _patients
          .map((patient) => '${patient['name']} (${patient['phone']})')
          .toList(),
      onChanged: (selectedItem) {
        setState(() {
          _selectedPatient = selectedItem;
        });
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: 'Search by name or phone',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        menuProps: MenuProps(
          backgroundColor: Colors.grey[100], // Change background color here
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Patient",
          hintText: "Search by name or phone",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      itemAsString: (String? item) => item ?? '',
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150, // Fixed width for labels
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none, // Remove border line
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 194, 199, 230), // Updated color
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5, // Subtle shadow for a modern effect
      ),
      child: Text(
        'Mark as Arrived',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: widget.onClose,
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.indigo, fontSize: 16),
      ),
    );
  }
}
