import 'package:audio_tale/firebase_services.dart';
import 'package:audio_tale/home.dart';
import 'package:audio_tale/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:audio_tale/utils/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'login_screen.dart';
import 'models/models.dart';

class AudioUploadPage extends StatefulWidget {
  @override
  _AudioUploadPageState createState() => _AudioUploadPageState();
}

class _AudioUploadPageState extends State<AudioUploadPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String _category = 'Audiobook'; // Default value
  String _genre = 'Mystery'; // Default value
  late String _audioUrl;
  File? _featureImage, _audioFile;
  bool loading = false;

  final List<String> _genres = [
    'Thriller',
    'Mystery',
    'Sci-Fi',
    'Fantasy',
    'Horror',
  ];

  final _database = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;

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
            color: Theme.of(context).primaryColor,
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                toastMessage("Logged out successfully!", Colors.green);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                ).onError((error, stackTrace) {
                  toastMessage(error.toString(), Colors.red);
                });
              });
            },
            icon: const Icon(Icons.logout, size: 30),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        loading = false;
                      });
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: _featureImage == null
                      ? Icon(Icons.image)
                      : Image.file(
                    _featureImage!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  label: Text(
                    _featureImage == null
                        ? 'Select Feature Image'
                        : 'Change Feature Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final XFile? file = await _imagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      _featureImage =
                      file != null ? File(file.path) : null;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _category,
                  dropdownColor: Colors.black,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() {
                    _category = value!;
                  }),
                  items: [
                    DropdownMenuItem(
                      value: 'Audiobook',
                      child: Text('Audiobook',
                          style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Fictional Story',
                      child: Text('Fictional Story',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _genre,
                  dropdownColor: Colors.black,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() {
                    _genre = value!;
                  }),
                  items: _genres.map((genre) {
                    return DropdownMenuItem(
                      value: genre,
                      child: Text(genre,
                          style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Genre',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: Icon(Icons.audiotrack),
                  label: Text(
                    _audioFile == null
                        ? 'Select Audio File'
                        : 'Change Audio File',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        _audioFile = File(result.files.single.path!);
                      });
                    }
                  },
                ),
                SizedBox(height: 40),
                RoundButton(
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await uploadAudio(context);
                    }
                  },
                  title: 'Upload Audio',
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text(
                      "Go to Homepage -->",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadAudio(BuildContext context) async {
    if (_audioFile == null || _title.isEmpty || _featureImage == null) {
      if (_audioFile == null) {
        toastMessage('Audio file is missing', Colors.red);
      } else if (_featureImage == null) {
        toastMessage('Feature Image is missing', Colors.red);
      } else {
        toastMessage('Feature Image is missing', Colors.red);
      }

      // Error message
      setState(() {
        loading = false;
      });
      return;
    }

    try {
      final featureImageUpload = _featureImage != null
          ? _uploadFeatureImage(_featureImage!)
          : Future.value(null);
      final audioFileUpload = _uploadAudioFile(_audioFile!);

      final results = await Future.wait([featureImageUpload, audioFileUpload]);
      final featureImageUrl = results[0] as String?;
      final audioUrl = results[1] as String;

      final DatabaseReference databaseRef = _database.ref();
      final String key = _title; // Use the title as the key

      if (_category == 'Audiobook') {
        final DataSnapshot existingAudiobookSnapshot =
        await databaseRef.child('audiobooks').child(key).get();
        if (existingAudiobookSnapshot.exists) {
          toastMessage('An audiobook with this title already exists', Colors.red);
          setState(() {
            loading = false;
          });
          return;
        } else {
          await databaseRef.child('audiobooks').child(key).set({
            'title': _title,
            'featureImage': featureImageUrl,
            'category': _category,
            'genre': _genre,
            'audioUrl': audioUrl,
          });
        }
      } else if (_category == 'Fictional Story') {
        final DataSnapshot existingStorySnapshot =
        await databaseRef.child('fictional-stories').child(key).get();
        if (existingStorySnapshot.exists) {
          final bool addNewEpisode = await _showConfirmationDialog(context,
              'A story with this title already exists. Do you want to add a new episode to it?');
          if (addNewEpisode) {
            await _addNewEpisode(databaseRef, key, audioUrl);
          } else {
            toastMessage('Upload canceled', Colors.red); // Cancel message
            setState(() {
              loading = false;
            });
            return;
          }
        } else {
          final Map<String, dynamic> storyData = {
            'title': _title,
            'featureImage': featureImageUrl,
            'category': _category,
            'genre': _genre,
            'episodes': {
              '1': {'audioUrl': audioUrl, 'episodeTitle': 'Episode 1'},
            },
          };
          await databaseRef.child('fictional-stories').child(key).set(storyData);
        }
      }

      toastMessage('Audio uploaded successfully', Colors.green);
      setState(() {
        loading = false;
        _resetForm();
      });
    } catch (e) {
      setState(() {
        loading = false;

      });
      toastMessage('Failed to upload audio: $e', Colors.red);
    }
  }


  // F
  Future<String?> _uploadFeatureImage(File file) async {
    final featureImageRef =
    _storage.ref().child('featureImages/${file.uri.pathSegments.last}');
    await featureImageRef.putFile(file);
    return await featureImageRef.getDownloadURL();
  }

  Future<String> _uploadAudioFile(File file) async {
    final audioFileRef =
    _storage.ref().child('audioFiles/${file.uri.pathSegments.last}');
    await audioFileRef.putFile(file);
    return audioFileRef.getDownloadURL();
  }

  Future<void> _addNewEpisode(DatabaseReference databaseRef, String key,
      String audioUrl) async {
    final episodesRef =
    databaseRef.child('fictional-stories').child(key).child('episodes');
    final DataSnapshot episodesSnapshot = await episodesRef.get();
    final List<dynamic> episodes = List<dynamic>.from(episodesSnapshot.value as List<dynamic>? ?? []);

    final int nextEpisodeNumber = episodes.length + 1;
    final newEpisodeTitle = 'Episode $nextEpisodeNumber';
    final newEpisode = {
      'title': newEpisodeTitle,
      'audioUrl': audioUrl,
    };

    episodes.add(newEpisode);
    await episodesRef.set(episodes);
    // toastMessage('New episode added successfully', Colors.green);
  }


  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _category = 'Audiobook';
      _genre = 'Mystery';
      _featureImage = null;
      _audioFile = null;
    });
  }
}


class EditAudiobooks extends StatefulWidget {
  const EditAudiobooks({super.key});

  @override
  State<EditAudiobooks> createState() => _EditAudiobooksState();
}

class _EditAudiobooksState extends State<EditAudiobooks> {

  // final _database = FirebaseDatabase.instance;
  final  _firebaseDatabaseRef = FirebaseDatabase.instance.ref();
  final FirebaseService _firebaseService = FirebaseService();
  List<Audiobook> _audiobooks = [];


  @override
  void initState() {
    super.initState();
    _fetchAudiobooks();
  }

  void _fetchAudiobooks() async {
    List<Audiobook> audiobooks = await _firebaseService.fetchAudiobooks();
    setState(() {
      _audiobooks = audiobooks;
    });
  }

  Future<void> _deleteAudiobook(String audiobookId) async {
    if (await _showConfirmationDialog(
        context, "Do you want to delete this Audiobook?")) {
      await _firebaseDatabaseRef.child('audiobooks')
          .child(audiobookId)
          .remove();
      toastMessage("Audiobook deleted successfully", Colors.red);
      setState(() {
        _audiobooks.removeWhere((audiobook) => audiobook.title == audiobookId);
      });
    }
  }
  Widget build(BuildContext context) {

    return ListView.separated(
      itemCount: _audiobooks.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(_audiobooks[index].title.toString(), style: Theme.of(context).textTheme.bodyLarge,),
                      // Text(_audiobooks[index].genre.toString(), style: Theme.of(context).textTheme.bodyMedium,),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 50),
                IconButton(onPressed: (){

                }, icon: Icon(Icons.update), color: Colors.blue),
                // SizedBox(width: 10),
                IconButton(onPressed: (){
                  _deleteAudiobook(_audiobooks[index].title.toString());
                }, icon: Icon(Icons.delete), color: Colors.red)
              ],
            ),
          ],
        );
      } ,
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 3,
          color: Theme.of(context).primaryColor,
        );
      },
    );
  }
}



class EditStories extends StatefulWidget {
  const EditStories({super.key});

  @override
  State<EditStories> createState() => _EditStoriesState();
}

class _EditStoriesState extends State<EditStories> {
  final  _firebaseDatabaseRef = FirebaseDatabase.instance.ref();
  final FirebaseService _firebaseService = FirebaseService();
  List<FictionalStory> _fictionalStories = [];

  @override
  void initState() {
    super.initState();
    _fetchFictionalStories();
  }


  void _fetchFictionalStories() async {
    List<FictionalStory> stories = await _firebaseService.fetchFictionalStories();
    setState(() {
      _fictionalStories = stories;
    });
  }

  Future<void> _deleteStory(String storyTitle) async {
    if (await _showConfirmationDialog(
        context, "Do you want to delete this Story?")) {
      await _firebaseDatabaseRef.child('fictional-stories')
          .child(storyTitle)
          .remove();
      toastMessage("Fictional Story deleted successfully", Colors.red);
      setState(() {
        _fictionalStories.removeWhere((story) => story.title == storyTitle);
      });
    }
  }



  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Update and Delete Content"
          ),
        ),
        body: ListView.separated(
          itemCount: _fictionalStories.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Column(
                  children: [

                    Text(_fictionalStories[index].title.toString(), style: Theme.of(context).textTheme.bodyLarge,),
                  ],
                ),
                SizedBox(width: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){

                    }, icon: Icon(Icons.edit), color: Colors.blue),
                    SizedBox(width: 10),
                    IconButton(onPressed: (){
                      _deleteStory(_fictionalStories[index].title.toString());
                    }, icon: Icon(Icons.delete), color: Colors.red),
                  ],
                ),
              ],
            );
          } ,
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 3,
            );
          },
        )
    );
  }
}




Future<bool> _showConfirmationDialog(BuildContext context, String message) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message, style: TextStyle(fontSize: 15),),
      // content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    ),
  ) ?? false;
}
