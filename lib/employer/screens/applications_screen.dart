// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_search_app/employer/screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchApplications() async {
    List<Map<String, dynamic>> applicationsList = [];

    try {
      String? employerId = FirebaseAuth.instance.currentUser?.uid;
      if (employerId == null) return [];

      QuerySnapshot jobSnapshot =
          await FirebaseFirestore.instance
              .collection('employers')
              .doc(employerId)
              .collection('jobs')
              .get();

      for (var jobDoc in jobSnapshot.docs) {
        String jobId = jobDoc.id;
        String jobTitle = jobDoc['title'].toString();

        QuerySnapshot applicationsSnapshot =
            await FirebaseFirestore.instance
                .collection('employers')
                .doc(employerId)
                .collection('jobs')
                .doc(jobId)
                .collection('applications')
                .get();

        for (var appDoc in applicationsSnapshot.docs) {
          Map<String, dynamic> appData = appDoc.data() as Map<String, dynamic>;
          appData['jobId'] = jobId;
          appData['jobTitle'] = jobTitle;
          appData['applicantId'] = appDoc.id;

          // Format timestamp
          if (appData.containsKey('appliedAt') &&
              appData['appliedAt'] is Timestamp) {
            appData['appliedAt'] =
                (appData['appliedAt'] as Timestamp).toDate().toString();
          } else {
            appData['appliedAt'] = 'N/A';
          }

          applicationsList.add(appData);
        }
      }
    } catch (e) {
      print("❌ Error fetching applications: $e");
    }

    return applicationsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Job Applicants")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No applicants found"));
          }

          var applications = snapshot.data!;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var application = applications[index];
              String jobId = application['jobId'];
              String jobTitle = application['jobTitle'] ?? 'N/A';
              String jobSeekerId = application['applicantId'];
              String userName = application['userName'] ?? 'Unknown';
              String userEmail = application['userEmail'] ?? 'N/A';
              String appliedAt = application['appliedAt'];
              String resumeUrl = application['resumeUrl'] ?? 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(userName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📧 Email: $userEmail"),
                      Text("💼 Job Title: $jobTitle"),
                      Text("📅 Applied At: $appliedAt"),
                      const SizedBox(height: 4),
                      if (resumeUrl != 'N/A')
                        TextButton.icon(
                          onPressed: () async {
                            final Uri url = Uri.parse(resumeUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not open resume'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.download),
                          label: const Text("Download Resume"),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.chat, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                jobId: jobId,
                                employerId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                jobSeekerId: jobSeekerId,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
