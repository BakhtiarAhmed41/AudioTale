import 'package:firebase_database/firebase_database.dart';

class FictionalStory {
  String title;
  String featureImage;
  String genre;
  List<Episode> episodes;

  FictionalStory({required this.title, required this.featureImage, required this.genre, required this.episodes});

  factory FictionalStory.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    final episodesData = data['episodes'] as List<dynamic>;
    final episodes = episodesData.map((e) => Episode.fromMap(e)).toList();

    return FictionalStory(
      title: data['title'],
      featureImage: data['featureImage'],
      genre: data['genre'],
      episodes: episodes,
    );
  }
}

class Episode {
  String title;
  String audioUrl;
  int episodeNumber;

  Episode({required this.title, required this.audioUrl, required this.episodeNumber});

  factory Episode.fromMap(Map<dynamic, dynamic> data) {
    return Episode(
      title: data['title'],
      audioUrl: data['audioUrl'],
      episodeNumber: data['episodeNumber'] ?? 0, // Provide a default value if null
    );
  }
}

class Audiobook {
  String title;
  String featureImage;
  String genre;
  String audioUrl;

  Audiobook({required this.title, required this.featureImage, required this.genre, required this.audioUrl});

  factory Audiobook.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;

    return Audiobook(
      title: data['title'],
      featureImage: data['featureImage'],
      genre: data['genre'],
      audioUrl: data['audioUrl'],
    );
  }
}
