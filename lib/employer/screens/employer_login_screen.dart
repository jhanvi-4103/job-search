import 'package:flutter/material.dart';
import 'package:job_search_app/employer/screens/home_screen.dart';
import 'package:job_search_app/screens/job_seeker_login_screen.dart';
import 'package:job_search_app/widgets/login_form.dart';

class EmployerLoginScreen extends StatelessWidget {
  const EmployerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(
        userType: "Employer",
        homeScreen: const EmployerHomeScreen(),
        onRoleSwitch: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const JobSeekerLoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
