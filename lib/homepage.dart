import 'package:cached_network_image/cached_network_image.dart';

import 'audio_player.dart';
import 'audiobooks.dart';
import 'fictional_stories.dart';
import 'package:flutter/material.dart';

import 'firebase_services.dart';
import 'models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Audiobook> _audiobooks = [];
  List<FictionalStory> _fictionalStories = [];

  @override
  void initState() {
    super.initState();
    _fetchAudiobooks();
    _fetchFictionalStories();
  }

  void _fetchAudiobooks() async {
    List<Audiobook> audiobooks = await _firebaseService.fetchAudiobooks();
    setState(() {
      _audiobooks = audiobooks;
    });
  }

  void _fetchFictionalStories() async {
    List<FictionalStory> stories = await _firebaseService.fetchFictionalStories();
    setState(() {
      _fictionalStories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("Explore Our Categories", style: Theme.of(context).textTheme.displayLarge)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 45,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AudiobookScreen()),
                    );
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    height: 250,
                    width: 300,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/Classic.jpg"),
                        colorFilter: ColorFilter.mode(
                          Colors.black38,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("AudioBooks", style: Theme.of(context).textTheme.displayLarge),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 45,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FictionalStoriesScreen()),
                    );
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    height: 250,
                    width: 300,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/CommunityCreations.jpg"),
                        colorFilter: ColorFilter.mode(
                          Colors.black38,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("Community Creations", style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(child: Text("Recommended Audios", style: Theme.of(context).textTheme.displayLarge)),
          // SizedBox(height: 5),
          _buildHorizontalScroller( _audiobooks, context),
          SizedBox(height: 20),
          Center(child: Text("Audience Favourite", style: Theme.of(context).textTheme.displayLarge)),

          _buildHorizontalScroller(_fictionalStories, context),
        ],
      ),
    );
  }

  Widget _buildHorizontalScroller( List<dynamic> items, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text( style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(item, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(dynamic item, BuildContext context) {
    String imageUrl;
    String title;
    VoidCallback onTap;

    if (item is Audiobook) {
      imageUrl = item.featureImage;
      title = item.title;
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioPlayerScreen(
              audioUrl: item.audioUrl,
              featureImageUrl: item.featureImage,
              title: item.title,
              genre: item.genre,
              isFictionalStory: false,
            ),
          ),
        );
      };
    } else if (item is FictionalStory) {
      imageUrl = item.featureImage;
      title = item.title;
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FictionalStoriesScreen(),
          ),
        );
      };
    } else {
      return SizedBox.shrink(); // Return an empty widget for unsupported item types
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Theme.of(context).primaryColor,
            ),
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(imageUrl),
            colorFilter: ColorFilter.mode(
              Colors.black38,
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
