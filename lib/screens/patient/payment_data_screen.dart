import 'package:flutter/material.dart';

class PaymentDataScreen extends StatefulWidget {
  final VoidCallback onClose;

  PaymentDataScreen({required this.onClose});

  @override
  _PaymentDataScreenState createState() => _PaymentDataScreenState();
}

class _PaymentDataScreenState extends State<PaymentDataScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String _selectedStatus = 'Pending'; // Default status
  String? _selectedPatientName; // Holds the name of the selected patient

  final List<Map<String, String>> _patients = [
    {'firstName': 'Abebe', 'lastName': 'Alemu', 'phoneNumber': '0912345678'},
    {'firstName': 'Abel', 'lastName': 'Hagos', 'phoneNumber': '0987654321'},
    // Add more mock patients as needed
  ];

  final List<String> _statusOptions = ['Paid', 'Pending', 'Cancelled'];

  List<Map<String, String>> get _filteredPatients {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      // Return an empty list if there is no query
      return [];
    } else {
      return _patients.where((patient) {
        final name = '${patient['firstName']} ${patient['lastName']}';
        final phone = patient['phoneNumber'] ?? '';
        return name.toLowerCase().contains(query) || phone.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Data'),
        backgroundColor: Color(0xFF6ABEDC),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onClose,
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Patients',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF00796B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (query) {
                  setState(
                      () {}); // Update the patient list on search query change
                },
              ),
            ),
            // Patient List
            Expanded(
              child: _buildPatientList(),
            ),
            // Payment Form
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Name
                      if (_selectedPatientName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Selected Patient: $_selectedPatientName',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      // Amount
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Payment Amount',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Enter amount',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Payment Status
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Payment Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: _statusOptions.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (newStatus) {
                          setState(() {
                            _selectedStatus = newStatus!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Reason
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Reason for Payment',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Enter reason for payment',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle form submission
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Payment Saved'),
                                  content: Text(
                                      'Payment details have been saved successfully.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00796B),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                          child: Text('Save Payment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList() {
    final filteredPatients = _filteredPatients;
    final isQueryEmpty = _searchController.text.isEmpty;

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredPatients.isNotEmpty || isQueryEmpty
            ? filteredPatients.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      final patientName =
                          '${patient['firstName']} ${patient['lastName']}';
                      return ListTile(
                        title: Text(patientName),
                        subtitle: Text(patient['phoneNumber'] ?? ''),
                        onTap: () {
                          setState(() {
                            _selectedPatientName = patientName;
                          });
                        },
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'Please enter a search query.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
            : Center(
                child: Text(
                  'No patients found.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
      ),
    );
  }
}
