import 'package:flutter/material.dart';

class AddArrivedPatientScreen extends StatefulWidget {
  final VoidCallback onClose;
  final List<Map<String, dynamic>> patients;

  const AddArrivedPatientScreen({
    Key? key,
    required this.onClose,
    required this.patients,
  }) : super(key: key);

  @override
  _AddArrivedPatientScreenState createState() =>
      _AddArrivedPatientScreenState();
}

class _AddArrivedPatientScreenState extends State<AddArrivedPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _arrivalTimeController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedPatient;
  String _searchQuery = '';
  late List<Map<String, dynamic>> _patients;

  @override
  void initState() {
    super.initState();
    _patients = widget.patients; // Initialize _patients with widget.patients
  }

  List<Map<String, dynamic>> get _filteredPatients {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) {
      return _patients;
    } else {
      return _patients.where((patient) {
        final name = '${patient['firstName']} ${patient['lastName']}';
        final phone = patient['phoneNumber'] ?? '';
        return name.toLowerCase().contains(query) || phone.contains(query);
      }).toList();
    }
  }

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
          width: 600, // Adjust width as needed
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
                        _buildSearchField(),
                        SizedBox(height: 16),
                        _buildPatientCard(),
                        SizedBox(height: 16),
                        _buildLabeledTextField(
                            'Arrival Time', _arrivalTimeController,
                            keyboardType: TextInputType.datetime),
                        SizedBox(height: 16),
                        _buildLabeledTextField('Notes', _notesController),
                        SizedBox(height: 24),
                        _buildButtonRow(),
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

  Widget _buildSearchField() {
    return TextField(
      controller: TextEditingController(text: _searchQuery),
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
          if (_selectedPatient != null) {
            final selectedPatientName = _selectedPatient?.split(' (')[0] ?? '';
            if (selectedPatientName.isNotEmpty) {
              _searchQuery = selectedPatientName;
            }
          }
        });
      },
      decoration: InputDecoration(
        labelText: 'Search by name or phone',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : Icon(Icons.search),
      ),
    );
  }

  Widget _buildPatientCard() {
    if (_selectedPatient != null) {
      final selectedPatientName = _selectedPatient?.split(' (')[0] ?? '';
      final selectedPatient = _patients.firstWhere(
        (patient) =>
            '${patient['firstName']} ${patient['lastName']}' ==
            selectedPatientName,
        orElse: () =>
            {'firstName': 'Unknown', 'lastName': '', 'phoneNumber': ''},
      );
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: ListTile(
          title: Text(
              '${selectedPatient['firstName']} ${selectedPatient['lastName']}'),
          subtitle: Text(selectedPatient['phoneNumber'] ?? 'No Phone'),
          trailing: IconButton(
            icon: Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedPatient = null; // Clear the selection
                _searchQuery = ''; // Optionally clear the search query
              });
            },
          ),
        ),
      );
    }

    final filteredPatients = _filteredPatients;

    if (_searchQuery.isEmpty) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: ListTile(
          title: Text(
            'Please enter a search query',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    if (filteredPatients.isEmpty) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: ListTile(
          title: Text(
            'No patient found',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: filteredPatients.map((patient) {
        final patientName = '${patient['firstName']} ${patient['lastName']}';
        final patientPhone = patient['phoneNumber'] ?? '';
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          elevation: 4,
          child: ListTile(
            title: Text(patientName),
            subtitle: Text(patientPhone),
            onTap: () {
              setState(() {
                _selectedPatient = '$patientName ($patientPhone)';
                _searchQuery =
                    patientName; // Set search query to selected patient
              });
            },
            selected: _selectedPatient == '$patientName ($patientPhone)',
            selectedTileColor: Colors.blue[50],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Adjust width for labels
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
                  borderSide: BorderSide.none,
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
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromARGB(255, 194, 199, 230), // Updated color
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
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextButton(
            onPressed: widget.onClose,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.indigo, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
