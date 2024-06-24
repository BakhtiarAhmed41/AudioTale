import 'audiobooks.dart';
import 'fictional_stories.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:const EdgeInsets.all(10),
        child: Column(
          children:[
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
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
      );
  }
}