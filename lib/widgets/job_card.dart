// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_search_app/screens/job_detail_screen.dart';
import 'package:job_search_app/providers/job_provider.dart';

class JobCard extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  String companyName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchCompanyName();
  }

  Future<void> fetchCompanyName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await FirebaseFirestore.instance
                .collection('employers')
                .doc(
                  widget.job['employerId'],
                ) // Employer ID should be stored in job data
                .get();

        if (snapshot.exists && snapshot.data() != null) {
          setState(() {
            companyName = snapshot['companyName'] ?? 'No Company Name';
          });
        }
      }
    } catch (e) {
      print("Error fetching company name: $e");
      setState(() {
        companyName = "Error loading";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          widget.job['title'] ?? "No Title Available",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "$companyName - ${widget.job['location']}",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Consumer<JobProvider>(
          builder: (context, jobProvider, child) {
            final bool isSaved = jobProvider.isSaved(
              widget.job['id']?.toString() ?? "",
            );
            final bool isApplied = jobProvider.isApplied(
              widget.job['id']?.toString() ?? "",
            );

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Save/Bookmark Job Button
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () async {
                    await jobProvider.toggleSavedJob(widget.job);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSaved
                              ? "Removed from saved jobs"
                              : "Job saved successfully!",
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Apply for Job Button
                IconButton(
                  icon: Icon(
                    isApplied ? Icons.check_circle : Icons.check_circle_outline,
                    color: isApplied ? Colors.green : Colors.grey,
                  ),
                  onPressed:
                      isApplied
                          ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "You have already applied for this job.",
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                          : () async {
                            await jobProvider.applyForJob(widget.job);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Applied for ${widget.job['title']} successfully!",
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                ),
              ],
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(job: widget.job),
            ),
          );
        },
      ),
    );
  }
}
