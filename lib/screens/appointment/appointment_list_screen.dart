import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../providers/appointment_provider.dart';
import './appointment_calendar_screen.dart';
import '../../widgets/navigation_drawer.dart';

class AppointmentListScreen extends StatefulWidget {
  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  String searchQuery = '';
  Appointment? selectedAppointment;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppointmentProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
          elevation: 0,
          backgroundColor: Color(0xFF6ABEDC),
        ),
        body: Center(
          child: Consumer<AppointmentProvider>(
            builder: (context, provider, child) {
              final filteredAppointments =
                  provider.appointments.where((appointment) {
                return appointment.patientName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    appointment.doctorName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
              }).toList();

              return Column(
                children: [
                  _buildSearchAndAddRow(context),
                  Expanded(
                    child:
                        _buildAppointmentTable(filteredAppointments, provider),
                  ),
                  if (selectedAppointment != null)
                    _buildAppointmentDetailPanel(selectedAppointment!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndAddRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _showAppointmentCalendar(context);
            },
            child: Text('Add Appointment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6ABEDC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: AppointmentCalendarScreen(),
        );
      },
    );
  }

  Widget _buildAppointmentTable(
      List<Appointment> filteredAppointments, AppointmentProvider provider) {
    return Container(
      padding: EdgeInsets.all(16),
      constraints: BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: [
          DataColumn2(label: Text('ID'), size: ColumnSize.S),
          DataColumn2(label: Text('Patient Name')),
          DataColumn2(label: Text('Date')),
          DataColumn2(label: Text('Doctor Name')),
          DataColumn2(label: Text('Actions')),
        ],
        rows: filteredAppointments.map((appointment) {
          bool isSelected = selectedAppointment == appointment;

          return DataRow(
            selected: isSelected,
            onSelectChanged: (value) {
              setState(() {
                selectedAppointment = isSelected ? null : appointment;
              });
            },
            cells: [
              DataCell(Text(appointment.id)),
              DataCell(Text(appointment.patientName)),
              DataCell(
                  Text(appointment.date.toLocal().toString().split(' ')[0])),
              DataCell(Text(appointment.doctorName)),
              DataCell(_buildActionButtons(context, appointment, provider)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Appointment appointment,
      AppointmentProvider provider) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.details, color: Colors.teal),
          onPressed: () {
            setState(() {
              selectedAppointment = appointment;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.orange),
          onPressed: () {
            _showAppointmentCalendar(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            provider.deleteAppointment(appointment.id);
          },
        ),
      ],
    );
  }

  Widget _buildAppointmentDetailPanel(Appointment appointment) {
    return Container(
      color: Color.fromARGB(255, 247, 242, 242),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildDetailRow(
              Icons.person, 'Patient Name: ${appointment.patientName}'),
          _buildDetailRow(Icons.calendar_today,
              'Date: ${appointment.date.toLocal().toString().split(' ')[0]}'),
          _buildDetailRow(
              Icons.medical_services, 'Doctor Name: ${appointment.doctorName}'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAppointmentCalendar(context);
                },
                child: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Implement delete functionality
                },
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
