import 'package:flutter/material.dart';
import 'package:job_search_app/employer/screens/employer_login_screen.dart';
import 'package:job_search_app/screens/home_screen.dart';
import 'package:job_search_app/widgets/login_form.dart';

class JobSeekerLoginScreen extends StatelessWidget {
  const JobSeekerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(
        userType: "Job Seeker",
        homeScreen: const HomeScreen(),
        onRoleSwitch: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployerLoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
