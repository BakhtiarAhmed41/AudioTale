import 'package:firebase_database/firebase_database.dart';
import 'models/models.dart';

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
}
