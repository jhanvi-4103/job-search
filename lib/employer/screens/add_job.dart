// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_search_app/profile_components/text_field.dart';
import '../services/add_job_service.dart'; // Import JobService

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final JobService _jobService = JobService(); // Create JobService instance

  String? title,
      description,
      salary,
      location,
      requirements,
      experience,
      benefits;
  bool _isLoading = false;

  Future<void> _addJob() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await _jobService.addJob(
        title: title!,
        description: description!,
        salary: salary!,
        location: location!,
        requirements: requirements!,
        experience: experience!,
        benefits: benefits!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job added successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post a New Job")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: "Job Title",
                onSaved: (value) => title = value,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Job Description",
                onSaved: (value) => description = value,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Salary",
                onSaved: (value) => salary = value,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Location",
                onSaved: (value) => location = value,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Requirements",
                onSaved: (value) => requirements = value,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Experience",
                onSaved: (value) => experience = value,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Benefits",
                onSaved: (value) => benefits = value,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addJob,
                      icon: const Icon(Icons.send),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: const Text("Post Job"),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
