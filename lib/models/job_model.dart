import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String title;
  final String description;
  final String experience;
  final String location;
  final String salary;
  final String requirements;
  final DateTime postedAt;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.experience,
    required this.location,
    required this.salary,
    required this.requirements,
    required this.postedAt,
  });

  factory Job.fromMap(String id, Map<String, dynamic> data) {
    return Job(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      experience: data['experience'] ?? '',
      location: data['location'] ?? '',
      salary: data['salary'] ?? '',
      requirements: data['requirements'] ?? '',
      postedAt: (data['postedAt'] as Timestamp).toDate(),
    );
  }
}
