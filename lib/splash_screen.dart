import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override

  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color(0xff10263C),
        // backgroundColor: Colors.transparent,
      body: Container(
        child: Center(
          child: Image.asset('assets/AudioTale2.gif'),
        ),
      )
    );

  }
}
