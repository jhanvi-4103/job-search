import 'package:flutter/material.dart';
import 'package:job_search_app/screens/job_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:job_search_app/providers/bottom_nav_provider.dart';
import 'package:job_search_app/screens/chat_list_screen.dart';
import 'package:job_search_app/screens/myjobs_screen.dart';
import 'package:job_search_app/screens/profile_screen.dart';
import 'package:job_search_app/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    return Scaffold(
      body: IndexedStack(
        // Prevents rebuilding of screens
        index: bottomNavProvider.selectedIndex,
        children: [
          const JobListScreen(), // Home Screen with job listings
          const MyJobsScreen(),
          ChatListScreen(jobSeekerId: 'jobSeekerId'),
          const JobSeekerProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: bottomNavProvider.selectedIndex,
        onTap: (index) => bottomNavProvider.updateIndex(index),
        userType: "Job Seeker",
      ),
    );
  }
}
