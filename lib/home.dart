import 'package:flutter/material.dart';
import 'audio_books.dart';
import 'community_creations.dart';

class  Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("AudioTale", style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
        backgroundColor: const Color(0xff10263C),
        actions: const [Icon(Icons.settings)],

      ),
      body:Padding(
        padding:EdgeInsets.all(10),
        child: Column(
          children:[
            Text("Categories", style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center,),
            SizedBox(height:30),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AudioBooks()));
              },
              splashColor: Colors.transparent,
              child: Center(
                child: Container(
                  height:250,
                  width: 300,
                  margin:EdgeInsets.only(bottom:30),
                  decoration:BoxDecoration(
                    color:Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    image:DecorationImage(
                      fit:BoxFit.cover,
                      image:AssetImage("assets/Classic.jpg"),
                      colorFilter: ColorFilter.mode(
                        Colors.black38,
                        BlendMode.darken,
                      ),
                    )
                  ),
                  child:Center(child:Padding(padding:EdgeInsets.all(4),child:Text("Audio Books",style:Theme.of(context).textTheme.displayLarge))),

                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CommunityCreations()));
              },
              splashColor: Colors.transparent,
              child: Center(
                child: Container(
                  height:250,
                  width: 300,
                  margin:EdgeInsets.only(bottom:10),
                  decoration:BoxDecoration(
                      color:Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                      image:DecorationImage(
                        fit:BoxFit.cover,
                        image:AssetImage("assets/CommunityCreations.jpg"),
                        colorFilter: ColorFilter.mode(
                          Colors.black38, // Adjust the opacity and color here
                          BlendMode.darken,
                        ),
                      )
                  ),
                  child:Center(child:Padding(padding:EdgeInsets.all(4),child:Text("Community Creations",style:Theme.of(context).textTheme.displayLarge))),

                ),
              ),
            )
          ]
        ),
      )

    );
  }
}
