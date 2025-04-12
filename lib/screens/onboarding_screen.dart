import 'package:flutter/material.dart';
import 'package:job_search_app/screens/job_seeker_login_screen.dart';
import 'package:job_search_app/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isDarkMode;

  const OnboardingScreen({super.key, required this.isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Job Finder",
      "description": "Find the best job opportunities around you.",
      "image": "assets/image1.jpeg",
    },
    {
      "title": "Search Jobs",
      "description": "Browse through thousands of job listings.",
      "image": "assets/image2.jpeg",
    },
    {
      "title": "Save & Apply",
      "description": "Save your favorite jobs and apply with one click.",
      "image": "assets/image3.jpeg",
    },
    {
      "title": "Get Notified",
      "description": "Get notifications for new job openings.",
      "image": "assets/image4.jpeg",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage == onboardingData.length - 1) {
      _navigateToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => JobSeekerLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
                image: onboardingData[index]["image"]!,
                isFullScreen: true,
                fit: BoxFit.cover, // Ensure images take up full screen
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text('Skip'),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          _currentPage > 0
                              ? () => _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                              : null,
                      icon: const Icon(Icons.arrow_back),
                      color: _currentPage > 0 ? Colors.black : Colors.grey,
                    ),
                    IconButton(
                      onPressed: _goToNextPage,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
