import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String userType; // "Job Seeker" or "Employer"

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: _getNavBarItems(),
    );
  }

  /// Returns different bottom nav items based on user type
  List<BottomNavigationBarItem> _getNavBarItems() {
    if (userType == "Employer") {
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Jobs'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Applicants',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Saved',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }
}
