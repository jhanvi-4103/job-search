// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:job_search_app/screens/job_seeker_login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const JobSeekerLoginScreen()),
      (route) => false, // Clears navigation stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
