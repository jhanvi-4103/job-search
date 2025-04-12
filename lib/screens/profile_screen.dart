// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:job_search_app/profile_components/text_field.dart';
import 'package:job_search_app/widgets/app_drawer.dart';
import '../services/profile_database.dart';

class JobSeekerProfile extends StatefulWidget {
  const JobSeekerProfile({super.key});

  @override
  _JobSeekerProfileState createState() => _JobSeekerProfileState();
}

class _JobSeekerProfileState extends State<JobSeekerProfile> {
  final _formKey = GlobalKey<FormState>();
  final ProfileDatabase _profileDatabase = ProfileDatabase();

  String name = "";
  String mobile = "";
  String skills = "";
  String experience = "";
  String education = "";
  String? resumeUrl;

  bool _isLoading = true;

  void fetchUserData() async {
    Map<String, dynamic>? userData = await _profileDatabase.getProfile();
    if (userData != null) {
      setState(() {
        name = userData["name"] ?? "";
        mobile = userData["mobile"] ?? "";
        skills =
            userData["skills"] != null ? userData["skills"].join(", ") : "";
        experience = userData["experience"] ?? "";
        education = userData["education"] ?? "";
        resumeUrl = userData["resumeUrl"];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _profileDatabase.updateProfile(
        name: name,
        mobile: mobile,
        skills: skills,
        experience: experience,
        education: education,
        resumeUrl: resumeUrl,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
    }
  }

  void openResumeLink() async {
    if (resumeUrl != null && await canLaunchUrl(Uri.parse(resumeUrl!))) {
      await launchUrl(
        Uri.parse(resumeUrl!),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open resume")));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Seeker Profile"),
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
                        initialValue: name,
                        onSaved: (val) => name = val as String,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Mobile Number",
                        initialValue: mobile,
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => mobile = val as String,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Skills (comma separated)",
                        initialValue: skills,
                        onSaved: (val) => skills = val as String,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Experience",
                        initialValue: experience,
                        onSaved: (val) => experience = val as String,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Education",
                        initialValue: education,
                        onSaved: (val) => education = val as String,
                      ),
                      const SizedBox(height: 10),
                      resumeUrl != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Resume Uploaded:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: openResumeLink,
                                child: const Text(
                                  "View Resume",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          )
                          : ElevatedButton(
                            onPressed: () {
                              // Implement resume upload logic here (e.g., Cloudinary or Firebase Storage)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Resume upload not implemented yet",
                                  ),
                                ),
                              );
                            },
                            child: const Text("Upload Resume"),
                          ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: updateProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(fontSize: 18),
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
