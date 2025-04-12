import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:job_search_app/profile_components/text_field.dart';
import 'package:job_search_app/screens/job_seeker_login_screen.dart';
import '../services/profile_database.dart';

class JobSeekerSignUp extends StatefulWidget {
  const JobSeekerSignUp({super.key});

  @override
  _JobSeekerSignUpState createState() => _JobSeekerSignUpState();
}

class _JobSeekerSignUpState extends State<JobSeekerSignUp> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final ProfileDatabase _profileDatabase = ProfileDatabase();

  String name = "",
      mobile = "",
      skills = "",
      experience = "",
      education = "",
      email = "",
      password = "";
  String? resumeUrl;
  bool isUploading = false;
  String? resumeFileName;

  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        isUploading = true;
        resumeFileName = result.files.first.name;
      });

      PlatformFile file = result.files.first;
      try {
        String url = await uploadFileToCloudinary(file.bytes!, file.name);
        setState(() {
          resumeUrl = url;
          isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume Uploaded Successfully!")),
        );
      } catch (e) {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
      }
    }
  }

  Future<String> uploadFileToCloudinary(
    Uint8List fileBytes,
    String fileName,
  ) async {
    const cloudName = 'dnajex8wd';
    const uploadPreset = 'job_finder';

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/auto/upload",
    );

    var request =
        http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
          );

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(resBody);
      return jsonData['secure_url'];
    } else {
      throw Exception("Cloudinary upload failed: $resBody");
    }
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: email.trim(),
              password: password.trim(),
            );

        User? user = userCredential.user;

        await user?.sendEmailVerification();

        await _profileDatabase.saveProfile(
          name: name,
          mobile: mobile,
          skills: skills,
          experience: experience,
          education: education,
          resumeUrl: resumeUrl,
          email: email,
          uid: user?.uid,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Sign-Up Successful! A verification link has been sent to your email.",
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobSeekerLoginScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create an Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Join us to find your dream job",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: "Full Name",
                    onSaved: (val) => name = val as String,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Mobile Number",
                    onSaved: (val) => mobile = val as String,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Skills",
                    onSaved: (val) => skills = val as String,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Experience",
                    onSaved: (val) => experience = val as String,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Education",
                    onSaved: (val) => education = val as String,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Email",
                    onSaved: (val) => email = val as String,
                    email: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Password",
                    onSaved: (val) => password = val as String,
                    password: true,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: pickResume,
                    icon:
                        isUploading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Icon(Icons.upload_file),
                    label: Text(resumeFileName ?? "Upload Resume"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Sign Up"),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobSeekerLoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Already have an account? Log in",
                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
