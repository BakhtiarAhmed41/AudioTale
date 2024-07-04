import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'package:audio_tale/utils/toast.dart';

class FirebaseService {
  final DatabaseReference _audiobooksRef = FirebaseDatabase.instance.ref().child('audiobooks');
  final DatabaseReference _fictionalStoriesRef = FirebaseDatabase.instance.ref().child('fictional-stories');

  Future<List<Audiobook>> fetchAudiobooks() async {
    DataSnapshot snapshot = await _audiobooksRef.get();
    List<Audiobook> audiobooks = [];
    final data = snapshot.value as Map<dynamic, dynamic>?;
    data?.forEach((key, value) {
      audiobooks.add(Audiobook.fromSnapshot(snapshot.child(key)));
    });
    return audiobooks;
  }

  Future<List<FictionalStory>> fetchFictionalStories() async {
    DataSnapshot snapshot = await _fictionalStoriesRef.get();
    List<FictionalStory> stories = [];
    final data = snapshot.value as Map<dynamic, dynamic>?;
    data?.forEach((key, value) {
      stories.add(FictionalStory.fromSnapshot(snapshot.child(key)));
    });
    return stories;
  }


  Future<void> updateAudiobook(Audiobook audiobook) async {
    final DatabaseReference audioRef = FirebaseDatabase.instance.ref().child('audiobooks');
    String sanitizedTitle = audiobook.title.replaceAll('.', '_').replaceAll('#', '_').replaceAll('\$', '_').replaceAll('[', '_').replaceAll(']', '_');

    DatabaseEvent event = await audioRef.child(sanitizedTitle).once();

    if (event.snapshot.exists) {
      await audioRef.child(sanitizedTitle).update({
        'title': audiobook.title,
        'featureImage': audiobook.featureImage,
        'genre': audiobook.genre,
        'audioUrl': audiobook.audioUrl,
      }).then((onValue){
        toastMessage("Audiobook Updated", Colors.green);
      });
    }}


}
