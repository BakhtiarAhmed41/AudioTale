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
    return _stories.isEmpty
          ? Center(child: Text(
        "No Stories Found!", style: TextStyle(color: Colors.white),
      ))
          : ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return ExpansionTile(
            iconColor: Theme.of(context).primaryColor,
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
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
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
                        color: Color(0x801499C6),
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
      );
  }
}
