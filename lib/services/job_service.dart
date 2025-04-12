// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> applyForJob(String jobId, String employerId) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('job_seeker_profiles')
            .doc(userId)
            .get();

    String userName = userDoc['name'];
    String userEmail = userDoc['email'];
    String number = userDoc['mobile'];
    String resume = userDoc['resumeUrl'];

    DocumentSnapshot job =
        await FirebaseFirestore.instance
            .collection('employers')
            .doc(employerId)
            .collection('jobs')
            .doc(jobId)
            .get();

    String jobTitle = job['title'].toString();

    await FirebaseFirestore.instance
        .collection('employers')
        .doc(employerId)
        .collection('jobs')
        .doc(jobId)
        .collection('applications')
        .doc(userId)
        .set({
          'jobID': jobId,
          'userId': userId,
          'userName': userName,
          'userEmail': userEmail,
          'number': number,
          'jobTitle': jobTitle,
          'resumeUrl': resume, // ✅ Corrected field
          'appliedAt': Timestamp.now(),
        });

    print("Application submitted successfully!");
  } catch (e) {
    print("Failed to apply for job: $e");
  }
}
