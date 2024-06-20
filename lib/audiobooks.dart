import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'audio_player.dart';
import 'models/models.dart';

class AudiobookScreen extends StatefulWidget {
  @override
  _AudiobookScreenState createState() => _AudiobookScreenState();
}

class _AudiobookScreenState extends State<AudiobookScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('audiobooks');
  List<Audiobook> _audiobooks = [];

  @override
  void initState() {
    super.initState();
    _fetchAudiobooks();
  }

  void _fetchAudiobooks() {
    _databaseRef.onValue.listen((event) {
      final List<Audiobook> audiobooks = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      data?.forEach((key, value) {
        audiobooks.add(Audiobook.fromSnapshot(event.snapshot.child(key)));
      });
      setState(() {
        _audiobooks = audiobooks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audiobooks'),
      ),
      body: _audiobooks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _audiobooks.length,
        itemBuilder: (context, index) {
          final audiobook = _audiobooks[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerScreen(
                    audioUrl: audiobook.audioUrl,
                    featureImageUrl: audiobook.featureImage,
                    title: audiobook.title,
                    genre: audiobook.genre,
                    isFictionalStory: false,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(audiobook.featureImage),
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
                        audiobook.title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
