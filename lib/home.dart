import 'package:audio_tale/login_screen.dart';
import 'package:flutter/material.dart';
import 'audio_books.dart';
import 'audiobooks.dart';
import 'community_creations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_tale/utils/toast.dart';

import 'fictional_stories.dart';

class  Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/Appbar_logo.png"),
        centerTitle: true,
        backgroundColor: const Color(0xff10263C),
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
      body:Padding(
        padding:const EdgeInsets.all(10),
        child: Column(
          children:[
            Expanded(
              flex: 8,
              child: Text("Categories", style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center)
            ),
            
            Expanded(
              flex: 45,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AudiobookScreen()));
                },
                splashColor: Colors.transparent,
                child: Center(
                  child: Container(
                    height:250,
                    width: 300,
                    margin: EdgeInsets.all(8.0),
                    decoration:BoxDecoration(
                      color:Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      image:const DecorationImage(
                        fit:BoxFit.cover,
                        image:AssetImage("assets/images/Classic.jpg"),
                        colorFilter: ColorFilter.mode(
                          Colors.black38,
                          BlendMode.darken,
                        ),
                      )
                    ),
                    child:Center(child:Padding(padding:const EdgeInsets.all(4),child:Text("AudioBooks",style:Theme.of(context).textTheme.displayLarge))),
              
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 45,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FictionalStoriesScreen()));
                },
                splashColor: Colors.transparent,
                child: Center(
                  child: Container(
                    height:250,
                    width: 300,
                    margin: EdgeInsets.all(10.0),
                    decoration:BoxDecoration(
                        color:Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                        image:const DecorationImage(
                          fit:BoxFit.cover,
                          image:AssetImage("assets/images/CommunityCreations.jpg"),
                          colorFilter: ColorFilter.mode(
                            Colors.black38,
                            BlendMode.darken,
                          ),
                        )
                    ),
                    child:Center(child:Padding(padding:const EdgeInsets.all(4),child:Text("Community Creations",style:Theme.of(context).textTheme.displayLarge))),
              
                  ),
                ),
              ),
            )
          ]
        ),
      )

    );
  }
}
