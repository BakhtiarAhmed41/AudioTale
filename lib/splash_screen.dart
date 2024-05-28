import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';


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
          builder: (context) => const Home(),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xff10263C),
        // backgroundColor: Colors.transparent,
      body: Center(
        child: Image.asset('assets/AudioTale2.gif'),
      )
    );

  }
}
