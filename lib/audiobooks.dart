import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'admin_screen.dart';
import 'audio_player.dart';
import 'models/models.dart';
import 'firebase_services.dart';

class AudiobookScreen extends StatefulWidget {
  @override
  _AudiobookScreenState createState() => _AudiobookScreenState();
}

class _AudiobookScreenState extends State<AudiobookScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Audiobook> _audiobooks = [];

  final auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    fetchAudiobooks();
  }

  void fetchAudiobooks() async {
    List<Audiobook> audiobooks = await _firebaseService.fetchAudiobooks();
    setState(() {
      _audiobooks = audiobooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    if (user?.email.toString() == "admin@email.com"){
      return Scaffold(
        appBar: AppBar(

          leading: TextButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> EditAudiobooks()));
            }, child: Text("Edit", style: TextStyle(
              fontSize: 16, color: Colors.red
          ),),

          ),

          title: Text('Audiobooks'),
          // actions: [
          //   TextButton(onPressed: {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context)=> EditAudiobooks()))
          //   }, child: Text("Edit"))
          // ],
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                margin: EdgeInsets.all(15),
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: audiobook.featureImage,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
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
                          audiobook.title,
                          style:
                          TextStyle(color: Colors.white, fontSize: 20),
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
    else{
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                margin: EdgeInsets.all(15),
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: audiobook.featureImage,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
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
                          audiobook.title,
                          style:
                          TextStyle(color: Colors.white, fontSize: 20),
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
}
