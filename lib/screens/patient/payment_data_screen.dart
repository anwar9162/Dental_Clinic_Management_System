import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import to use DateFormat

import 'package:flutter_bloc/flutter_bloc.dart';
import 'patient_bloc/payment_bloc.dart';
import 'patient_bloc/payment_event.dart';
import 'patient_bloc/payment_state.dart';

class PaymentDataScreen extends StatefulWidget {
  final VoidCallback onClose;
  final List<Map<String, dynamic>> patients;

  PaymentDataScreen({required this.onClose, required this.patients});

  @override
  _PaymentDataScreenState createState() => _PaymentDataScreenState();
}

class _PaymentDataScreenState extends State<PaymentDataScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String _selectedStatus = 'Pending';
  String? _selectedPatientId;
  String? _selectedPatientName;

  late List<Map<String, dynamic>> _patients;

  final List<String> _statusOptions = ['Paid', 'Pending'];

  @override
  void initState() {
    super.initState();
    _patients = widget.patients;
  }

  List<Map<String, dynamic>> get _filteredPatients {
    final query = _searchController.text.toLowerCase();
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
      backgroundColor: Colors.grey[200],
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
                  setState(() {});
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
                      Container(
                        width: 250,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'ETB',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Enter amount',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(fontSize: 16),
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
                      PopupMenuButton<String>(
                        onSelected: (String newStatus) {
                          setState(() {
                            _selectedStatus = newStatus;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return _statusOptions.map((status) {
                            return PopupMenuItem<String>(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList();
                        },
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedStatus,
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF00796B),
                              ),
                            ],
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
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      // Submit Button
                      BlocConsumer<PaymentBloc, PaymentState>(
                        listener: (context, state) {
                          if (state is PaymentSuccess) {
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
                                        widget
                                            .onClose(); // Notify that the dialog has been closed
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (state is PaymentError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Payment failed: ${state.message}')),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_selectedPatientId != null) {
                                final paymentData = {
                                  'amount': _amountController.text,
                                  'date': DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  'status': _selectedStatus,
                                  'reason': _reasonController.text,
                                };
                                context.read<PaymentBloc>().add(
                                      AddPayment(
                                        patientId: _selectedPatientId!,
                                        paymentData: paymentData,
                                      ),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6ABEDC),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            child: Text('Save Payment'),
                          );
                        },
                      )
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
                      final patientId = patient['_id'];
                      final patientName =
                          '${patient['firstName']} ${patient['lastName']}';
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: _selectedPatientName == patientName
                                  ? Color(0xFF00796B)
                                  : Colors.transparent,
                              width: 5,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(patientName),
                          subtitle: Text(patient['phoneNumber'] ?? ''),
                          onTap: () {
                            setState(() {
                              _selectedPatientId = patientId;
                              _selectedPatientName = patientName;
                              _searchController.text = patientName;
                            });
                          },
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                        ),
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
