import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'apikey',
        appId: 'appId',
        messagingSenderId: 'messagingSenderId',
        projectId: 'projectId',
        storageBucket: 'storageBucket',   ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1499C6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff10263C)),
        scaffoldBackgroundColor: const Color(0xff10263C),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff10263C),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1499C6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
    // This is the theme of your application.
  }
}

