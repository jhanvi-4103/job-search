import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_search_app/providers/job_provider.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final bool isApplied = jobProvider.isApplied(job['id']?.toString() ?? "");

    return Scaffold(
      appBar: AppBar(
        title: Text(job['title']),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'],
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job['location'], style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Experience: ${job['experience']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  "Salary: ${job['salary']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1.5),
            Text(
              "Requirements:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(job['requirements'], style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            Text(
              "Job Description:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(job['description'], style: const TextStyle(fontSize: 15)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  isApplied ? Icons.check_circle : Icons.send,
                  // color: Colors.white,
                ),
                label: Text(
                  isApplied ? "Already Applied" : "Apply Now",
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed:
                    isApplied
                        ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "You have already applied for this job.",
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        : () async {
                          await jobProvider.applyForJob(job);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Applied for ${job['title']} successfully!",
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isApplied ? Colors.grey : Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
