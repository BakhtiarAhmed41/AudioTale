import 'dart:async';

import 'package:audio_tale/admin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'fictional_stories.dart';
import 'home.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  void initState() {
    super.initState();

    final user = auth.currentUser;


    if(user != null){

      if(user.email.toString() == "admin@email.com"){
        Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AudioUploadPage(),
            ),
          ),
        );
      }
      else{Timer(
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        ),
      );}

    }
    else{
      Timer(
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        ),
      );
    }

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