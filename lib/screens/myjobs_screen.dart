import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_search_app/providers/job_provider.dart';
import 'package:job_search_app/widgets/job_card.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Jobs"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, child) {
          final savedJobs = jobProvider.savedJobs;

          if (savedJobs.isEmpty) {
            return const _EmptyState(
              message: "No saved jobs yet. Start saving your favorite jobs!",
            );
          }

          return ListView.builder(
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              return JobCard(job: savedJobs[index]);
            },
          );
        },
      ),
    );
  }
}

// Custom Empty State Widget
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.work_off, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
