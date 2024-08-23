import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_usernameController.text == 'admin' &&
          _passwordController.text == '123456') {
        GoRouter.of(context).go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFEAF5F5), // Soft light blue background
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: 500), // Reasonable max width
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 50),
                              // Clinic Logo
                              Container(
                                color: Colors
                                    .transparent, // Ensure the background is transparent
                                child: Image.asset(
                                  'assets/images/dental_clinic_logo2.jpg', // Path to your transparent PNG
                                  height: 75, // Adjust height as needed
                                  width: 150, // Adjust width as needed
                                  fit: BoxFit.cover, // Ensure proper fit
                                ),
                              ),
                              SizedBox(height: 20),
                              // Title and Description
                              Text(
                                "Dental Clinic Management System",
                                style: TextStyle(
                                  color: Colors.blueGrey[800],
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Please log in to manage clinic operations.",
                                style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 30),
                              _buildTextField(
                                controller: _usernameController,
                                label: 'Username',
                                icon: Icons.email,
                                validator: (value) => value?.isEmpty ?? true
                                    ? 'Enter your username'
                                    : null,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.vpn_key,
                                obscureText: _obscurePassword,
                                validator: (value) => value?.isEmpty ?? true
                                    ? 'Enter your password'
                                    : null,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF6ABEDC),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => _login(context),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      Color(0xFF6ABEDC), // Button color
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120, // Adjust width as needed
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 16), // Space between label and text field
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Color(0xFF6ABEDC)),
              suffixIcon: suffixIcon,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            obscureText: obscureText,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
