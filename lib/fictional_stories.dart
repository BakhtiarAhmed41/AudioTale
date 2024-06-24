import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'audio_player.dart';
import 'models/models.dart';

class FictionalStoriesScreen extends StatefulWidget {
  @override
  _FictionalStoriesScreenState createState() => _FictionalStoriesScreenState();
}

class _FictionalStoriesScreenState extends State<FictionalStoriesScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('fictional-stories');
  List<FictionalStory> _stories = [];

  @override
  void initState() {
    super.initState();
    _fetchFictionalStories();
  }

  void _fetchFictionalStories() {
    _databaseRef.onValue.listen((event) {
      final List<FictionalStory> stories = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        stories.add(FictionalStory.fromSnapshot(event.snapshot.child(key)));
      });
      setState(() {
        _stories = stories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: _stories.isEmpty
          ? Center(child: Text(
        "No Stories Found!", style: TextStyle(color: Colors.white),
      ))
          : ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return ExpansionTile(
            title: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(story.featureImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        story.title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            children: story.episodes.map((episode) {
              return ListTile(
                title: Text(episode.title, style: TextStyle(color: Colors.white, fontSize: 20)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(
                        audioUrl: episode.audioUrl,
                        featureImageUrl: story.featureImage,
                        title: episode.title,
                        genre: story.genre,
                        isFictionalStory: true,
                        episodeNumber: episode.episodeNumber,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
