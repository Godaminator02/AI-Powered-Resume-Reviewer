import 'package:flutter/material.dart';
import 'package:frontend/resume_upload_screen.dart';

import 'onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/ResumeUploadScreen': (context) => ResumeUploadScreen(),
      },
      initialRoute: '/',
      home: OnboardingScreen(),
    );
  }
}
