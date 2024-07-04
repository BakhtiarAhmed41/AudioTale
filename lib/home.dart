import 'package:flutter/material.dart';
import 'audiobooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_tale/utils/toast.dart';

import 'fictional_stories.dart';
import 'homepage.dart';
import 'login_screen.dart';

class Home extends StatefulWidget {
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
        currentPage = HomePage(onNavigate: (index) {
          setState(() {
            selectedIndex = index;
          });
        });
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
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back) ,
        ),
        backgroundColor: const Color(0xff10263C),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).primaryColor, // Color of the border
            height: 1.0,
          ),
        ),
        actions:  [IconButton(
          onPressed: () {
            auth.signOut().then((value) {
              toastMessage("Logged out successfully!", Colors.green);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false, // This will remove all previous routes
              ).onError((error, stackTrace) {
                toastMessage(error.toString(), Colors.red);
              });
            });
          },
          icon: Icon(Icons.logout),
        )
          ,],

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
                label: "Stories",
              ),
            ]
          ),
        ],
      )
    );
  }
}

