import 'package:flutter/material.dart';

import 'splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        primaryColor: Color(0xff10263C),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
    // This is the theme of your application.
  }
}

