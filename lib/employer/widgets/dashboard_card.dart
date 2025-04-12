// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            FutureBuilder<int>(
              future: _fetchCount(title),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("Error");
                }
                return Text(
                  snapshot.data.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _fetchCount(String type) async {
    try {
      String? employerId = FirebaseAuth.instance.currentUser?.uid;
      // if (employerId == null) {
      //   print("User not logged in.");
      //   return 0;
      // }

      if (type == "Total Jobs") {
        // ✅ Fetch total jobs count for the logged-in employer
        QuerySnapshot jobsSnapshot =
            await FirebaseFirestore.instance
                .collection('employers')
                .doc(employerId)
                .collection('jobs')
                .get();
        return jobsSnapshot.docs.length;
      } else if (type == "Applied Jobs") {
        // ✅ Fetch total number of applications across all jobs
        QuerySnapshot applicationsSnapshot =
            await FirebaseFirestore.instance
                .collectionGroup('applications')
                .get();
        return applicationsSnapshot.docs.length;
      }
    } catch (e) {
      // print("Error fetching count: $e");
    }
    return 0;
  }
}
