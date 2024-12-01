import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_api_service.dart'; // Ensure this path is correct

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  final Function() onDelete;
  final Function() onUpdateSuccess; // Add this callback

  AppointmentDetailScreen({
    required this.appointment,
    required this.onDelete,
    required this.onUpdateSuccess, // Initialize the callback
  });

  @override
  _AppointmentDetailScreenState createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _statusController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedStatus = 'New';
  late AppointmentService _appointmentService;
  List<Note> _newNotes = []; // List to track newly added notes

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.appointment.status ?? 'New';
    _statusController.text = widget.appointment.status ?? '';
    _appointmentService = AppointmentService(); // Initialize your service
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: theme.textTheme.headlineMedium ??
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('ID: ${widget.appointment.id ?? 'N/A'}'),
            Text(
                'Patient: ${widget.appointment.patientDetails?.firstName ?? ''} ${widget.appointment.patientDetails?.lastName ?? ''}'),
            Text('Doctor: ${widget.appointment.doctorDetails?.name ?? ''}'),
            Text(
                'Date: ${widget.appointment.date.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 16),
            _buildStatusDropdown(),
            SizedBox(height: 16),
            if (widget.appointment.appointmentReason != null &&
                widget.appointment.appointmentReason!.isNotEmpty)
              _buildSection(
                title: 'Appointment Reason',
                content: Text(widget.appointment.appointmentReason!),
              ),
            SizedBox(height: 16),
            if ((widget.appointment.notes != null &&
                    widget.appointment.notes!.isNotEmpty) ||
                _newNotes.isNotEmpty)
              _buildSection(
                title: 'Notes',
                content: _buildNotesList(),
              ),
            SizedBox(height: 16),
            _buildNoteInput(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Delete Appointment'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateAppointment,
              child: Text('Update Appointment'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButton<String>(
      value: _selectedStatus,
      items: <String>['New', 'Completed', 'No-Show'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue!;
        });
      },
    );
  }

  Widget _buildNoteInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Add a new note',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _addNote,
          child: Text('Add Note'),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildNotesList() {
    // Combine existing notes with newly added notes
    final allNotes = [...?widget.appointment.notes, ..._newNotes];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: allNotes.map((note) {
        final isNewNote = _newNotes.contains(note);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _buildSection(
                  title: 'Note',
                  content: Text(
                      '${note.content} (Created on ${note.createdAt.toLocal().toString().split(' ')[0]})'),
                ),
              ),
              if (isNewNote)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeNoteFromNewNotes(note),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        _newNotes.add(Note(
          content: _noteController.text,
          createdAt: DateTime.now(),
        ));
        _noteController.clear();
      });
    }
  }

  void _removeNoteFromNewNotes(Note note) {
    setState(() {
      _newNotes.remove(note);
    });
  }

  Future<void> _updateAppointment() async {
    try {
      await _appointmentService.updateAppointment(
        widget.appointment.id!,
        _selectedStatus,
        _newNotes, // Only send newly added notes
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment updated successfully')),
      );
      widget.onUpdateSuccess(); // Call the callback function
      Navigator.pop(context); // Close the modal
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment')),
      );
    }
  }
}
