import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;
  final String featureImageUrl;
  final String title;
  final String genre;
  final bool isFictionalStory;
  final int? episodeNumber; // Nullable since audiobooks won't have an episode number

  AudioPlayerScreen({
    required this.audioUrl,
    required this.featureImageUrl,
    required this.title,
    required this.genre,
    required this.isFictionalStory,
    this.episodeNumber,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setSourceUrl(widget.audioUrl);
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
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
      body: Container(
        color: Color(0xff10263C),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feature Image
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 30, right: 20, left: 20),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.featureImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Audio Details
            Column(
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // if (widget.isFictionalStory && widget.episodeNumber != null)
                //   Text(
                //     '${widget.title}',
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 16,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                SizedBox(height: 10),
                Text(
                  widget.genre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Progress Bar
                Slider(
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.white,
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    });
                  },
                ),
                // Duration Text
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Play/Pause Button
            Center(
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 64,
                ),
                onPressed: _togglePlayPause,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
