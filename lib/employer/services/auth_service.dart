import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUpEmployer({
    required String name,
    required String email,
    required String password,
    required String companyName,

    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = userCredential.user;
      if (user != null) {
        // Send email verification
        await user.sendEmailVerification();

        // Save employer details in Firestore
        await _firestore.collection('employers').doc(user.uid).set({
          'name': name,
          'email': email,
          'companyName': companyName,
          'role': role,
          'isVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return "Verification email sent! Please check your inbox.";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
    return null;
  }
}
