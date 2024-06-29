import 'package:audio_tale/admin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'audio_player.dart';
import 'models/models.dart';
import 'firebase_services.dart';

class FictionalStoriesScreen extends StatefulWidget {
  @override
  _FictionalStoriesScreenState createState() => _FictionalStoriesScreenState();
}

class _FictionalStoriesScreenState extends State<FictionalStoriesScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<FictionalStory> _stories = [];
  List<FictionalStory> _searchedStories = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchFictionalStories();
  }

  void fetchFictionalStories() async {
    List<FictionalStory> stories = await _firebaseService.fetchFictionalStories();
    setState(() {
      _stories = stories;
    });
  }

  void searchStories(String query) {
    _searchedStories.clear();
    _stories.forEach((story) {
      if (story.title.toLowerCase().contains(query.toLowerCase())) {
        _searchedStories.add(story);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    if (user?.email.toString() == "admin@email.com"){
    return Scaffold(
      appBar: AppBar(
        title: Text("Fictional Stories"),
        leading: TextButton(
          onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=> EditStories()));
          }, child: Text("Edit", style: TextStyle(
    fontSize: 16, color: Colors.red
    ),),
      ),
      ),
      body: _stories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return _buildStoryCard(context, story);
        },
      ),
    );} else {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Stories...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (query) {
                  searchStories(query);
                },
              )
            : Text("Fictional Stories"),
        leading: _isSearching
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _searchedStories.clear();
                  });
                },
              )
            : (user?.email.toString() == "admin@email.com"
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditStories()));
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  )
                : SizedBox()),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: _isSearching
          ? _buildSearchResults()
          : (_stories.isEmpty
              ? Center(child: CircularProgressIndicator())
              : _buildStoriesList(_stories)),
    );}
  }

  Widget _buildStoriesList(List<FictionalStory> stories) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(context, story);
      },
    );
  }

  Widget _buildStoryCard(BuildContext context, FictionalStory story) {
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
              ),
              child: CachedNetworkImage(
                imageUrl: story.featureImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
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
  }

  Widget _buildSearchResults() {
    return _searchedStories.isEmpty
        ? Center(child: Text("No results found"))
        : _buildStoriesList(_searchedStories);
  }
}
