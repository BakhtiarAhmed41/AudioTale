import 'package:audio_tale/login_screen.dart';
import 'package:flutter/material.dart';
import 'audio_books.dart';
import 'community_creations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_tale/utils/toast.dart';

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
        title: Text("Welcome to AudioTale", style: Theme.of(context).appBarTheme.titleTextStyle),
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
        }, icon: const Icon(Icons.logout, size: 30,)),
        const SizedBox(width: 10,)],

      ),
      body:Padding(
        padding:const EdgeInsets.all(10),
        child: Column(
          children:[
            const SizedBox(height:30),
            Text("Categories", style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
            const SizedBox(height:40),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AudioBooks()));
              },
              splashColor: Colors.transparent,
              child: Center(
                child: Container(
                  height:250,
                  width: 300,
                  margin:const EdgeInsets.only(bottom:50),
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
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const CommunityCreations()));
              },
              splashColor: Colors.transparent,
              child: Center(
                child: Container(
                  height:250,
                  width: 300,
                  margin:const EdgeInsets.only(bottom:10),
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
            )
          ]
        ),
      )

    );
  }
}
