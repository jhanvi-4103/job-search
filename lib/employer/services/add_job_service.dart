import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Adds a new job under the employer's document
  Future<void> addJob({
    required String title,
    required String description,
    required String salary,
    required String location,
    required String requirements,
    required String experience,
    required String benefits,
  }) async {
    try {
      // Get the current employer's ID
      String employerId = _auth.currentUser!.uid;

      // Reference to the employer's jobs subcollection
      DocumentReference employerRef = _firestore
          .collection('employers')
          .doc(employerId);

      // Add job to the subcollection
      await employerRef.collection('jobs').add({
        'title': title,
        'description': description,
        'salary': salary,
        'location': location,
        'requirements': requirements,
        'experience': experience,
        'benefits': benefits,
        'postedAt': FieldValue.serverTimestamp(), // Store timestamp
        'employerId': employerId, // Store employer reference
      });
    } catch (e) {
      throw Exception("Failed to add job: ${e.toString()}");
    }
  }
}
