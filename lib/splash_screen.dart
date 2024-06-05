import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xff10263C),
        body: Center(
          child: Image.asset('assets/images/AudioTale3.gif'),
        )
    );
  }
}