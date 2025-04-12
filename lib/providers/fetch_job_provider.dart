// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:job_search_app/models/job_model.dart';

// class FetchJobProvider with ChangeNotifier {
//   List<Job> _jobs = [];
//   bool _isLoading = false;

//   List<Job> get jobs => _jobs;
//   bool get isLoading => _isLoading;

//   Future<void> fetchJobs(String employerId) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       QuerySnapshot jobSnapshot =
//           await firestore
//               .collection('employers')
//               .doc(employerId)
//               .collection('jobs')
//               .get();

//       _jobs =
//           jobSnapshot.docs
//               .map(
//                 (doc) =>
//                     Job.fromMap(doc.id, doc.data() as Map<String, dynamic>),
//               )
//               .toList();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching job details: $e");
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
