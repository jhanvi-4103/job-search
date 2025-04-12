// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_search_app/profile_components/text_field.dart';
import 'package:job_search_app/widgets/app_drawer.dart';

class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployerProfileScreenState createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _email = "";
  String _name = "";
  String _companyName = "";
  String _role = "";
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchEmployerData();
  }

  Future<void> _fetchEmployerData() async {
    setState(() => _isLoading = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userId = user.uid;
        DocumentSnapshot doc =
            await FirebaseFirestore.instance
                .collection('employers')
                .doc(_userId)
                .get();

        if (doc.exists) {
          setState(() {
            _name = doc['name'] ?? "";
            _email = doc['email'] ?? "";
            _companyName = doc['companyName'] ?? "";
            _role = doc['role'] ?? "";
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Employer data not found")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching profile: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmployerProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not found")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('employers')
          .doc(_userId)
          .update({'name': _name, 'companyName': _companyName, 'role': _role});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const AppDrawer(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: "Name",
                        initialValue: _name,
                        onSaved: (value) => _name = value as String,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Email",
                        email: true,
                        initialValue: _email,
                        onSaved: (value) => _email = value as String,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Company Name",
                        initialValue: _companyName,
                        onSaved: (value) => _companyName = value as String,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Your Role",
                        initialValue: _role,
                        onSaved: (value) => _role = value as String,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _updateEmployerProfile,
                          icon: const Icon(Icons.save),
                          label: const Text("Update Profile"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blueAccent[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
