import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/doctor_bloc.dart';
import 'blocs/doctor_event.dart';
import 'blocs/doctor_state.dart';

class AddDoctorScreen extends StatefulWidget {
  final VoidCallback onDoctorAdded;

  AddDoctorScreen({required this.onDoctorAdded});

  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedGender;
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final doctorData = {
        'name': _nameController.text,
        'specialty': _specialtyController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'contactInfo': {
          'gender': _selectedGender,
          'phone': _phoneController.text,
          'address': _addressController.text,
        },
      };
      context.read<DoctorBloc>().add(AddDoctor(doctorData));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Doctor added successfully!')),
          );
          widget.onDoctorAdded();
        } else if (state is DoctorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add doctor: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Doctor'),
          backgroundColor: Color(0xFF6ABEDC),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildSectionHeader('Doctor Information'),
                _buildTextField(_nameController, 'Name', Icons.person),
                _buildTextField(
                    _specialtyController, 'Specialty', Icons.local_hospital),
                _buildGenderDropdown(),
                _buildTextField(_phoneController, 'Phone', Icons.phone),
                _buildTextField(
                    _addressController, 'Address', Icons.location_on),
                const SizedBox(
                    height: 24), // Space before the credentials section
                _buildSectionHeader('Login Credentials'),
                _buildTextField(_usernameController, 'Username', Icons.person),
                _buildPasswordField(_passwordController, 'Password'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Doctor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6ABEDC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6ABEDC),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF6ABEDC)),
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF6ABEDC)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6ABEDC), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Color(0xFF6ABEDC)),
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF6ABEDC)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6ABEDC), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        items: [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.transgender, color: Color(0xFF6ABEDC)),
          labelText: 'Gender',
          labelStyle: TextStyle(color: Color(0xFF6ABEDC)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6ABEDC), width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null) {
            return 'Please select a gender';
          }
          return null;
        },
      ),
    );
  }
}
