import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import '../../models/appointment_model.dart';
import 'add_appointment_screen.dart';
import 'appointment_detail_screen.dart';
import '../../widgets/navigation_drawer.dart' as custom;
import '../../widgets/appointment_card.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  List<Appointment> _appointments = [];

  void _addNewAppointment(Appointment newAppointment) {
    setState(() {
      _appointments.add(newAppointment);
    });
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
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: DraggableGridViewBuilder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              dragCompletion: (List<DraggableGridItem> list, int beforeIndex,
                  int afterIndex) {
                _showAddAppointmentDialog(context, _selectedDay);
              },
              children: List.generate(
                _appointments.length,
                (index) => DraggableGridItem(
                  child: AppointmentCard(
                    appointment: _appointments[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailScreen(
                              appointment: _appointments[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              isOnlyLongPress: false,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAppointment = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAppointmentScreen()),
          );

          if (newAppointment != null) {
            _addNewAppointment(newAppointment);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Add Appointment on ${selectedDate.toLocal()}'.split(' ')[0]),
          content: AddAppointmentScreen(),
        );
      },
    );
  }
}
