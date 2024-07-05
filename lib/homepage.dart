import 'package:audio_tale/utils/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'audio_player.dart';
import 'audiobooks.dart';
import 'fictional_stories.dart';
import 'firebase_services.dart';
import 'models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  final Function(int) onNavigate;

  const HomePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final FirebaseService _firebaseService = FirebaseService();
    List<Audiobook> _audiobooks = [];
    List<FictionalStory> _fictionalStories = [];

    Future<void> _fetchData() async {
      _audiobooks = await _firebaseService.fetchAudiobooks();
      _fictionalStories = await _firebaseService.fetchFictionalStories();
    }

    return FutureBuilder(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LoadingHome());
        } else {
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
                          onNavigate(1); // AudioBooks Screen
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
                          onNavigate(2); // Fictional Stories Screen
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
                Center(child: Text("Classic Mysteries", style: Theme.of(context).textTheme.displayLarge)),
                _buildHorizontalScroller(_audiobooks, context),

                SizedBox(height: 20),
                Center(child: Text("Horror Tales", style: Theme.of(context).textTheme.displayLarge)),
                _buildHorizontalScroller(_fictionalStories, context),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildHorizontalScroller(List<dynamic> items, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

    if (item is Audiobook && item.genre == "Mystery") {
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
    } else if (item is FictionalStory && item.genre == "Horror") {
      imageUrl = item.featureImage;
      title = item.title;
      onTap = () {
        onNavigate(2); // Fictional Stories Screen
      };
    } else {
      return SizedBox.shrink();
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
        ),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
