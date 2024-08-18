import 'package:flutter/material.dart';
import '../../services/appointment_api_service.dart'; // Import the AppointmentService
import '../../models/appointment_model.dart';

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
  TimeOfDay? _arrivalTime;
  final _notesController = TextEditingController();
  final _searchQueryController = TextEditingController();

  String? _selectedPatientId;
  String _searchQuery = '';
  late List<Map<String, dynamic>> _patients;
  late List<Appointment> _todaysAppointments;
  final AppointmentService _appointmentService = AppointmentService();
  String _arrivalType = ''; // Hidden field to store arrival type

  @override
  void initState() {
    super.initState();
    _patients = widget.patients;
    _searchQueryController.addListener(() {
      setState(() {
        _searchQuery = _searchQueryController.text;
      });
    });
    _loadTodaysAppointments(); // Load today's appointments when the screen is initialized
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadTodaysAppointments() async {
    try {
      final todaysAppointments =
          await _appointmentService.getTodaysAppointments();
      setState(() {
        _todaysAppointments = todaysAppointments;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load today\'s appointments')),
      );
    }
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

  void _selectArrivalTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _arrivalTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _arrivalTime) {
      setState(() {
        _arrivalTime = pickedTime;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Patient marked as arrived with arrival type: $_arrivalType')),
      );
      widget.onClose(); // Close the form after handling arrival
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          width: 600,
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
                          'Arrival Time',
                          TextEditingController(
                              text: _arrivalTime == null
                                  ? ''
                                  : _arrivalTime!.format(context)),
                          onTap: _selectArrivalTime,
                          readOnly: true,
                        ),
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
      controller: _searchQueryController,
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
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
                    _searchQueryController.clear();
                    _searchQuery = '';
                  });
                },
              )
            : Icon(Icons.search),
      ),
    );
  }

  Widget _buildPatientCard() {
    if (_selectedPatientId != null) {
      final selectedPatient = _patients.firstWhere(
        (patient) => patient['_id'].toString() == _selectedPatientId,
        orElse: () => {
          'firstName': 'Unknown',
          'lastName': '',
          'phoneNumber': '',
          '_id': ''
        },
      );

      // Check if the selected patient is in today's appointments
      final selectedPatientId =
          selectedPatient['_id'].toString(); // Ensure ID is a string
      final isInAppointments = _todaysAppointments.any((appointment) {
        final appointmentPatientId =
            appointment.patientDetails!.id.toString(); // Ensure ID is a string

        return appointmentPatientId == selectedPatientId;
      });

      setState(() {
        _arrivalType = isInAppointments ? 'On Appointment' : 'Walk-in';
      });

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
                _selectedPatientId = null;
                _searchQuery = '';
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
        final patientId =
            patient['_id'].toString(); // Use patient ID for comparison

        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          elevation: 4,
          child: ListTile(
            title: Text(patientName),
            subtitle: Text(patientPhone),
            onTap: () {
              setState(() {
                _selectedPatientId = patientId;
                // Update arrival type based on selected patient
                final isInAppointments = _todaysAppointments.any(
                  (appointment) =>
                      appointment.patientDetails!.id.toString() == patientId,
                );
                _arrivalType = isInAppointments ? 'On Appointment' : 'Walk-in';
              });
            },
            selected: _selectedPatientId == patientId,
            selectedTileColor: Colors.blue[50],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      VoidCallback? onTap,
      bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
              readOnly: readOnly,
              onTap: onTap,
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
              backgroundColor: Color.fromARGB(255, 194, 199, 230),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
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
