import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDatabase {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveProfile({
    required String name,
    required String mobile,
    required String skills,
    required String experience,
    required String education,
    String? resumeUrl,
    required String email,
    String? uid,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('job_seeker_profiles').doc(user.uid).set({
        "uid": user.uid,
        "name": name,
        "mobile": mobile,
        "skills": skills.split(","),
        "experience": experience,
        "education": education,
        "resumeUrl": resumeUrl ?? "",
        "email": email,
      });
    } catch (e) {
      throw Exception("Error saving profile: $e");
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc =
          await _firestore
              .collection('job_seeker_profiles')
              .doc(user.uid)
              .get();

      if (!doc.exists) return null;

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }

  Future<void> updateProfile({
    required String name,
    required String mobile,
    required String skills,
    required String experience,
    required String education,
    String? resumeUrl,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('job_seeker_profiles').doc(user.uid).update({
        "name": name,
        "mobile": mobile,
        "skills": skills.split(","),
        "experience": experience,
        "education": education,
      });
    } catch (e) {
      throw Exception("Error updating profile: $e");
    }
  }
}
