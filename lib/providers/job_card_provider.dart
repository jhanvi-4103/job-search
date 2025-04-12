import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobCardProvider with ChangeNotifier {
  final Map<String, String> _employerNames = {}; // Caches employer names

  /// Get employer name from cache or fetch from Firestore
  Future<String> getEmployerName(String employerId) async {
    if (_employerNames.containsKey(employerId)) {
      return _employerNames[employerId]!;
    }

    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('employers')
              .doc(employerId)
              .get();

      if (snapshot.exists && snapshot.data() != null) {
        String name = snapshot['companyName'] ?? 'No Company Name';
        _employerNames[employerId] = name;
        notifyListeners();
        return name;
      }
    } catch (e) {
      debugPrint("Error fetching employer name: $e");
    }

    return "Unknown Company";
  }
}
