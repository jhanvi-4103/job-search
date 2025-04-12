// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_search_app/employer/screens/add_job.dart';
import 'package:job_search_app/employer/screens/applications_screen.dart';
import 'package:job_search_app/employer/screens/profile_screen.dart';
import 'package:job_search_app/employer/widgets/dashboard_card.dart';
import 'package:job_search_app/employer/widgets/job_card.dart';
import '../../widgets/bottom_nav_bar.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployerHomeScreenState createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return ApplicationsScreen();
      // case 2:
      //   return const MessageScreen();
      case 2:
        return const EmployerProfileScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DashboardCard(
                title: "Total Jobs",
                icon: Icons.work,
                color: Colors.orange,
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collectionGroup('applications')
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> appSnapshot) {
                  if (!appSnapshot.hasData) {
                    return GestureDetector(
                      onTap: () => _navigateToApplications(),
                      child: DashboardCard(
                        title: "Applications (0)",
                        icon: Icons.notifications,
                        color: Colors.red,
                      ),
                    );
                  }
                  int totalApplications = appSnapshot.data!.docs.length;
                  return GestureDetector(
                    onTap: () => _navigateToApplications(),
                    child: DashboardCard(
                      title: "Applications ($totalApplications)",
                      icon: Icons.notifications,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddJobScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Job"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Posted Jobs",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildJobList()), // ✅ Fetch jobs posted by employer
        ],
      ),
    );
  }

  void _navigateToApplications() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  /// ✅ Fetch only jobs posted by the logged-in employer
  Widget _buildJobList() {
    String? employerId = _auth.currentUser?.uid;
    if (employerId == null) {
      return const Center(child: Text("User not logged in."));
    }

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('employers')
              .doc(employerId)
              .collection('jobs')
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No jobs posted yet."));
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) {
                var job = doc.data() as Map<String, dynamic>;
                return JobCard(jobId: doc.id, job: job);
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _getScreen(_selectedIndex)), // ✅ Fix applied here
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        userType: "Employer",
      ),
    );
  }
}
