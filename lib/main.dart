import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_search_app/providers/bottom_nav_provider.dart';
import 'package:provider/provider.dart';

import 'package:job_search_app/firebase_options.dart';
import 'package:job_search_app/providers/auth_provider.dart';
import 'package:job_search_app/providers/job_provider.dart';
import 'package:job_search_app/screens/onboarding_screen.dart';
// ignore: depend_on_referenced_packages

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("🔥 Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => JobProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {'/': (context) => const OnboardingScreen(isDarkMode: false)},
      ),
    );
  }
}
