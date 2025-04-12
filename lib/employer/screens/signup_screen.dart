import 'package:flutter/material.dart';
import 'package:job_search_app/employer/screens/employer_login_screen.dart';
import 'package:job_search_app/employer/services/auth_service.dart';
import 'package:job_search_app/profile_components/text_field.dart';

class EmployerSignupScreen extends StatefulWidget {
  const EmployerSignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployerSignupScreenState createState() => _EmployerSignupScreenState();
}

class _EmployerSignupScreenState extends State<EmployerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Initialize AuthService
  String _name = "";
  String _email = "";
  String _password = "";
  String _companyName = "";
  String _role = "";
  bool _isLoading = false;

  Future<void> _signupEmployer() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    String? response = await _authService.signUpEmployer(
      name: _name,
      email: _email,
      password: _password,
      companyName: _companyName,
      role: _role,
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response ?? "Signup failed!")));
      if (response != null) {
        Navigator.pop(context); // Navigate to login screen after signup
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employer Signup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: "Name",
                onSaved: (value) => _name = value as String,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Email",
                email: true,
                onSaved: (value) => _email = value as String,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Password",
                password: true,
                onSaved: (value) => _password = value as String,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Company Name",
                onSaved: (value) => _companyName = value as String,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Your Role",
                onSaved: (value) => _role = value as String,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _signupEmployer,
                      icon: const Icon(Icons.person_add),
                      label: const Text("Sign Up"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployerLoginScreen(),
                    ),
                  );
                },
                child: const Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
