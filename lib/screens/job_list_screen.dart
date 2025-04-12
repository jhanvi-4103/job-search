import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_search_app/widgets/job_card.dart';
import 'package:job_search_app/widgets/search_filter_bar.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  String searchQuery = "";
  String selectedLocation = "All Locations";
  List<String> locations = [
    "All Locations",
    "Ahmedabad",
    "Vadodara",
    "Pune",
    "Mumbai",
    "Bangalore",
    "Hyderabad",
    "Delhi",
    "Rajkot",
    "Surat",
    "Chennai",
    "Kolkata",
  ];

  void filterJobs() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Job Finder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchFilterBar(
              searchQuery: searchQuery,
              selectedLocation: selectedLocation,
              locations: locations,
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterJobs();
                });
              },
              onLocationChanged: (value) {
                setState(() {
                  selectedLocation = value;
                  filterJobs();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collectionGroup('jobs')
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No jobs available.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                var jobs =
                    snapshot.data!.docs.map((doc) {
                      var job = doc.data() as Map<String, dynamic>;
                      job['id'] = doc.id;
                      return job;
                    }).toList();

                var filteredJobs =
                    jobs.where((job) {
                      final matchesQuery =
                          searchQuery.isEmpty ||
                          job['title'].toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          );
                      final matchesLocation =
                          selectedLocation == "All Locations" ||
                          job['location'] == selectedLocation;
                      return matchesQuery && matchesLocation;
                    }).toList();

                return filteredJobs.isEmpty
                    ? const Center(
                      child: Text(
                        "No jobs found",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: JobCard(job: filteredJobs[index]),
                        );
                      },
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
