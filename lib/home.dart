import 'package:flutter/material.dart';

class  Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AudioTale", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
        backgroundColor: Color(0xff10263C),
      ),
      body: Center(
        child: Text("Welcome to the HomePage")
      ),
    );
  }
}
