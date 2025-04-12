import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _savedJobs = [];
  List<Map<String, dynamic>> _appliedJobs = [];

  JobProvider() {
    _loadJobs(); // ✅ Ensures jobs are loaded on initialization
  }

  List<Map<String, dynamic>> get savedJobs => _savedJobs;
  List<Map<String, dynamic>> get appliedJobs => _appliedJobs;

  bool isSaved(String jobId) {
    return _savedJobs.any((job) => job['id'].toString() == jobId);
  }

  bool isApplied(String jobId) {
    return _appliedJobs.any((job) => job['jobId'].toString() == jobId); // ✅ Fix
  }

  Future<void> toggleSavedJob(Map<String, dynamic> job) async {
    String userId = _auth.currentUser!.uid;
    String jobId = job['id'].toString();
    DocumentReference jobRef = _firestore
        .collection('job_seeker_profiles')
        .doc(userId)
        .collection('savedJobs')
        .doc(jobId);

    if (isSaved(jobId)) {
      await jobRef.delete();
      _savedJobs.removeWhere((savedJob) => savedJob['id'].toString() == jobId);
    } else {
      await jobRef.set(_convertTimestamps({...job, 'id': jobId}));
      _savedJobs.add(_convertTimestamps({...job, 'id': jobId}));
    }

    notifyListeners();
  }

  Future<void> applyForJob(Map<String, dynamic> job) async {
    try {
      String userId = _auth.currentUser!.uid;
      String jobId = job['id'].toString();
      String employerId = job['employerId'].toString();

      DocumentSnapshot userDoc =
          await _firestore.collection('job_seeker_profiles').doc(userId).get();

      String userName = userDoc['name'].toString();
      String userEmail = userDoc['email'].toString();
      String userMobile = userDoc['mobile'].toString();

      // ✅ Store application in Firestore
      await _firestore
          .collection('employers')
          .doc(employerId)
          .collection('jobs')
          .doc(jobId)
          .collection('applications')
          .doc(userId)
          .set({
            'userId': userId,
            'userName': userName,
            'userEmail': userEmail,
            'mobile': userMobile,
            'appliedAt': FieldValue.serverTimestamp(),
          });

      await _firestore
          .collection('job_seeker_profiles')
          .doc(userId)
          .collection('appliedJobs')
          .doc(jobId)
          .set({
            'jobId': jobId, // ✅ Ensure 'jobId' key is used
            'title': job['title'].toString(),
            'employerId': employerId,
            'appliedAt': FieldValue.serverTimestamp(),
          });

      _appliedJobs.add(
        _convertTimestamps({
          'jobId': jobId,
          'title': job['title'].toString(),
          'employerId': employerId,
          'appliedAt': DateTime.now().toIso8601String(),
        }),
      );

      notifyListeners();
      // print("✅ Job application successful.");
    } catch (e) {
      // print("❌ Failed to apply for job: $e");
    }
  }

  Future<void> _loadJobs() async {
    try {
      String userId = _auth.currentUser!.uid;

      // Fetch saved jobs
      QuerySnapshot savedJobsSnapshot =
          await _firestore
              .collection('job_seeker_profiles')
              .doc(userId)
              .collection('savedJobs')
              .get();
      _savedJobs =
          savedJobsSnapshot.docs
              .map(
                (doc) => _convertTimestamps(doc.data() as Map<String, dynamic>),
              )
              .toList();
      // print("✅ Fetched Saved Jobs: $_savedJobs");

      // Fetch applied jobs
      QuerySnapshot appliedJobsSnapshot =
          await _firestore
              .collection('job_seeker_profiles')
              .doc(userId)
              .collection('appliedJobs')
              .get();
      _appliedJobs =
          appliedJobsSnapshot.docs
              .map(
                (doc) => _convertTimestamps(doc.data() as Map<String, dynamic>),
              )
              .toList();
      // print(
      //   "✅ Fetched Applied Jobs: ${_appliedJobs.map((job) => job['jobId']).toList()}",
      // );

      notifyListeners();
    } catch (e) {
      print("❌ Error loading jobs: $e");
    }
  }

  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> job) {
    return job.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
