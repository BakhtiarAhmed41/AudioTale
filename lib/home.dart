// This holds the skeleton (appbar and bottombar) for main screens for easy navigation

import 'package:audio_tale/login_screen.dart';
import 'package:flutter/material.dart';
import 'audio_books.dart';
import 'audiobooks.dart';
import 'community_creations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_tale/utils/toast.dart';

import 'fictional_stories.dart';
import 'homepage.dart';

class  Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;
  var selectedIndex = 0; // for current page

  @override
  Widget build(BuildContext context) {

    Widget currentPage = const Text("");

    switch(selectedIndex) {
      case 0:
        currentPage = HomePage();
        break;
      case 1:
        currentPage = AudiobookScreen();
        break;
      case 2:
        currentPage = FictionalStoriesScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/Appbar_logo.png"),
        centerTitle: true,
        backgroundColor: const Color(0xff10263C),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).primaryColor, // Color of the border
            height: 1.0,
          ),
        ),
        actions:  [IconButton(onPressed: (){
          auth.signOut().then((value) {
            toastMessage("Logged out successfully!", Colors.green);
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Login())
          ).onError((error, stackTrace) {
                toastMessage(error.toString(), Colors.red);
          },);
          });
        }, icon: const Icon(Icons.logout, size: 30,)),],

      ),
      body: currentPage,

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Theme.of(context).primaryColor,
            height: 2.0,
          ),
          
          BottomNavigationBar(
            backgroundColor: const Color(0xff10263C),
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: (newIndex) {
              setState(() {
                selectedIndex = newIndex;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.headset),
                label: "AudioBooks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "Community",
              ),
            ]
          ),
        ],
      )
    );
  }
}
