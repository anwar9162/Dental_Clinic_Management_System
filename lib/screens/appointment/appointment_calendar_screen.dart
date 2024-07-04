import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, Event, EventList;
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  List<Appointment> _appointments = [];
  List<Patient> _patients = [
    Patient(id: '1', name: 'John Doe'),
    Patient(id: '2', name: 'Jane Doe'),
    Patient(id: '3', name: 'Alice Smith'),
    Patient(id: '4', name: 'Bob Johnson'),
  ];
  Patient? _selectedPatient;
  EventList<Event> _markedDateMap = EventList<Event>();

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _appointments
        .where((appointment) => isSameDay(appointment.date, day))
        .toList();
  }

  void _addNewAppointment() {
    if (_selectedPatient != null) {
      setState(() {
        Appointment newAppointment = Appointment(
          id: DateTime.now().toString(),
          patientName: _selectedPatient!.name,
          date: _selectedDay,
          description: 'New Appointment',
          doctorName: 'Dr. Smith',
        );
        _appointments.add(newAppointment);
        _markedDateMap.add(
          newAppointment.date,
          Event(
            date: newAppointment.date,
            title: newAppointment.patientName,
            icon: _appointmentMarker(newAppointment.patientName),
          ),
        );
        _selectedPatient = null;
      });
    }
  }

  void _removeAppointment(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment);
      _markedDateMap.remove(
          appointment.date,
          Event(
            date: appointment.date,
            title: appointment.patientName,
            icon: _appointmentMarker(appointment.patientName),
          ));
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Calendar'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                setState(() => _selectedDay = date);
              },
              weekendTextStyle: TextStyle(color: Colors.red),
              thisMonthDayBorderColor: Colors.grey,
              selectedDateTime: _selectedDay,
              daysHaveCircularBorder: false,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              markedDatesMap: _markedDateMap,
              height: 420.0,
              selectedDayTextStyle: TextStyle(
                color: Colors.yellow,
              ),
              todayTextStyle: TextStyle(
                color: Colors.blue,
              ),
              markedDateShowIcon: true,
              markedDateIconBuilder: (event) {
                return event.icon ?? Container();
              },
              markedDateMoreShowTotal: null,
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              _getAppointmentsForDay(_selectedDay).length,
                          itemBuilder: (context, index) {
                            final appointment =
                                _getAppointmentsForDay(_selectedDay)[index];
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(appointment.patientName),
                                subtitle: Text(appointment.description),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _removeAppointment(appointment),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (_selectedPatient != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: _addNewAppointment,
                            child: Text('Add Appointment'),
                          ),
                        ),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search Patients',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _patients = _patients
                                  .where((patient) => patient.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _patients.length,
                          itemBuilder: (context, index) {
                            final patient = _patients[index];
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(patient.name),
                                onTap: () {
                                  setState(() {
                                    _selectedPatient = patient;
                                  });
                                },
                                selected: _selectedPatient == patient,
                                selectedTileColor: Colors.blue[100],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentMarker(String patientName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.all(4.0),
      child: Text(
        patientName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
