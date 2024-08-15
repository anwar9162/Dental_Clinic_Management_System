import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../models/appointment_model.dart';
import 'blocs/appointment_bloc.dart';
import 'blocs/appointment_event.dart';
import 'blocs/appointment_state.dart';
import 'appointment_calendar_screen.dart';
import 'appointment_detail_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  String searchQuery = '';
  Appointment? selectedAppointment;

  @override
  void initState() {
    super.initState();
    // Fetch all appointments when the screen is initialized
    context.read<AppointmentBloc>().add(FetchAllAppointments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        elevation: 0,
        backgroundColor: Color(0xFF6ABEDC),
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AppointmentError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is AppointmentLoaded) {
            final filteredAppointments =
                state.appointments.where((appointment) {
              final patientName =
                  '${appointment.patientDetails?.firstName ?? ''} ${appointment.patientDetails?.lastName ?? ''}';
              final doctorName = appointment.doctorDetails?.name ?? '';
              return patientName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  doctorName.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Column(
              children: [
                _buildSearchAndAddRow(context),
                Expanded(
                  child: filteredAppointments.isEmpty
                      ? _buildEmptyState()
                      : _buildAppointmentTable(filteredAppointments),
                ),
              ],
            );
          } else {
            return Center(child: Text('No appointments available.'));
          }
        },
      ),
    );
  }

  Widget _buildSearchAndAddRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
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

  Widget _buildAppointmentTable(List<Appointment> filteredAppointments) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
            DataColumn2(label: Text('Doctor Name')),
            DataColumn2(label: Text('Date')),
            DataColumn2(label: Text('Status')),
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
                DataCell(Text(appointment.id ?? '')),
                DataCell(Text(
                    '${appointment.patientDetails?.firstName ?? ''} ${appointment.patientDetails?.lastName ?? ''}')),
                DataCell(Text(appointment.doctorDetails?.name ?? '')),
                DataCell(
                    Text(appointment.date.toLocal().toString().split(' ')[0])),
                DataCell(Text(appointment.status ?? '')),
                DataCell(_buildActionButtons(context, appointment)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Appointment appointment) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.details, color: Colors.teal),
          onPressed: () {
            _showAppointmentDetails(context, appointment);
          },
        ),
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.blue), // Calendar icon
          onPressed: () {
            _showAppointmentCalendar(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Confirm before deleting
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content:
                      Text('Are you sure you want to delete this appointment?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<AppointmentBloc>()
                            .add(DeleteAppointment(appointment.id!));
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: context
              .read<AppointmentBloc>(), // Use the existing AppointmentBloc
          child: AppointmentDetailScreen(
            appointment: appointment,
            onDelete: () {
              Navigator.pop(context); // Close the bottom sheet
              context
                  .read<AppointmentBloc>()
                  .add(DeleteAppointment(appointment.id!));
            },
            onUpdateSuccess: () {
              // Trigger an event to refresh the appointment list
              context.read<AppointmentBloc>().add(FetchAllAppointments());
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Text('No appointments found.'));
  }
}
