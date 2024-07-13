import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';
import '../../models/appointment_model.dart';
import '../../providers/appointment_provider.dart';
import './add_appointment_screen.dart';
import './appointment_detail_screen.dart';
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
          backgroundColor: Colors.teal,
        ),
        drawer: CustomNavigationDrawer(),
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
                        .contains(searchQuery.toLowerCase()) ||
                    appointment.description
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Search',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.teal),
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
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AddAppointmentScreen(),
                                );
                              },
                              child: Text('Add Appointment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                          DataColumn2(label: Text('Description')),
                          DataColumn2(label: Text('Doctor Name')),
                          DataColumn2(label: Text('Actions')),
                        ],
                        rows: filteredAppointments.map((appointment) {
                          bool isSelected = selectedAppointment == appointment;

                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: (value) {
                              setState(() {
                                selectedAppointment =
                                    isSelected ? null : appointment;
                              });
                            },
                            cells: [
                              DataCell(Text(appointment.id)),
                              DataCell(Text(appointment.patientName)),
                              DataCell(Text(appointment.date
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0])),
                              DataCell(Text(appointment.description)),
                              DataCell(Text(appointment.doctorName)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.details, color: Colors.teal),
                                    onPressed: () {
                                      setState(() {
                                        selectedAppointment = appointment;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            AddAppointmentScreen(
                                                appointment: appointment),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      provider
                                          .deleteAppointment(appointment.id);
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (selectedAppointment != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AppointmentDetailPanel(
                          appointment: selectedAppointment!),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AppointmentDetailPanel extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailPanel({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Patient Name: ${appointment.patientName}'),
            Text(
                'Date: ${appointment.date.toLocal().toString().split(' ')[0]}'),
            Text('Description: ${appointment.description}'),
            Text('Doctor Name: ${appointment.doctorName}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your edit functionality here
                  },
                  child: Text('Edit'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add your delete functionality here
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
