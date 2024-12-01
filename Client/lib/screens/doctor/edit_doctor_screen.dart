import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/doctor_detail_bloc.dart';
import 'blocs/doctor_event.dart';
import 'blocs/doctor_state.dart';

class EditDoctorScreen extends StatefulWidget {
  final String doctorId;
  final VoidCallback onDoctorUpdated;

  const EditDoctorScreen(
      {required this.doctorId, required this.onDoctorUpdated});

  @override
  _EditDoctorScreenState createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;
  String? _selectedGender;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _specialtyController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    context.read<DoctorDetailBloc>().add(FetchDoctorById(widget.doctorId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<DoctorDetailBloc>().state;

    if (state is DoctorDetailLoaded) {
      _nameController.text = state.doctor['name'];
      _specialtyController.text = state.doctor['specialty'];
      _usernameController.text = state.doctor['username'];
      _phoneController.text = state.doctor['phone'];
      _addressController.text = state.doctor['address'];
      _selectedGender = state.doctor['gender'];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedDoctorData = {
        'name': _nameController.text,
        'specialty': _specialtyController.text,
        'username': _usernameController.text,
        'contactInfo': {
          'gender': _selectedGender,
          'phone': _phoneController.text,
          'address': _addressController.text,
        },
        // Include password only if _isPasswordVisible is true
        if (_isPasswordVisible) 'password': _passwordController.text,
      };
      context
          .read<DoctorDetailBloc>()
          .add(UpdateDoctor(widget.doctorId, updatedDoctorData));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorDetailBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorUpdated) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Doctor updated successfully')),
          );
          // Call the callback function
          widget.onDoctorUpdated();
        } else if (state is DoctorError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update doctor: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Doctor'),
          backgroundColor: Color(0xFF6ABEDC),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<DoctorDetailBloc, DoctorState>(
          builder: (context, state) {
            if (state is DoctorDetailLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6ABEDC),
                ),
              );
            } else if (state is DoctorDetailLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      _buildSectionHeader('Doctor Information'),
                      _buildTextField(_nameController, 'Name', Icons.person),
                      _buildTextField(_specialtyController, 'Specialty',
                          Icons.local_hospital),
                      _buildGenderDropdown(),
                      _buildTextField(_phoneController, 'Phone', Icons.phone),
                      _buildTextField(
                          _addressController, 'Address', Icons.location_on),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Login Credentials'),
                      _buildTextField(
                          _usernameController, 'Username', Icons.person),
                      _buildPasswordPrompt(),
                      if (_isPasswordVisible) _buildPasswordField(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Update Doctor'),
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
              );
            } else {
              return Center(
                child: Text('Error loading doctor details.'),
              );
            }
          },
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
          prefixIcon: Icon(Icons.person, color: Color(0xFF6ABEDC)),
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
          if (value == null || value.isEmpty) {
            return 'Please select gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordPrompt() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Checkbox(
            value: _isPasswordVisible,
            onChanged: (value) {
              // Safely handle null value by using null-aware operator
              setState(() {
                _isPasswordVisible = value ?? false;
                if (!(_isPasswordVisible)) {
                  _passwordController.clear();
                }
              });
            },
            activeColor: Color(0xFF6ABEDC),
          ),
          const Text('Change Password'),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Color(0xFF6ABEDC)),
          labelText: 'New Password',
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
          // Safely handle null value by using null-aware operator
          if (_isPasswordVisible && (value == null || value.isEmpty)) {
            return 'Please enter a new password';
          }
          return null;
        },
      ),
    );
  }
}
