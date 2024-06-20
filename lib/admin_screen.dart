import 'package:audio_tale/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:audio_tale/utils/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content Upload'),
      ),
      body: Padding(
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
                    : Image.file(_featureImage!, width: 50, height: 50, fit: BoxFit.cover),
                label: Text(
                  _featureImage == null ? 'Select Feature Image' : 'Change Feature Image',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _featureImage = file != null ? File(file.path) : null;
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
                    child: Text('Audiobook', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Fictional Story',
                    child: Text('Fictional Story', style: TextStyle(color: Colors.white)),
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
                    child: Text(genre, style: TextStyle(color: Colors.white)),
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
                  _audioFile == null ? 'Select Audio File' : 'Change Audio File',
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
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await uploadAudio(context);
                  }
                },
                title: 'Upload Audio',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadAudio(BuildContext context) async {
    if (_audioFile == null || _title.isEmpty) {
      toastMessage('Audio file or title is missing', Colors.red); // Error message
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      // Upload the feature image first and get the URL
      String? featureImageUrl;
      if (_featureImage != null) {
        featureImageUrl = await _uploadFeatureImage(_featureImage!);
        if (featureImageUrl == null) {
          toastMessage('Failed to upload feature image', Colors.red); // Error message
          return;
        }
      }

      // Upload the audio file and get the URL
      final Reference storageRef = _storage.ref().child('audios/$_title');
      final UploadTask uploadTask = storageRef.putFile(_audioFile!);
      final TaskSnapshot snapshot = await uploadTask;
      final String audioUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _audioUrl = audioUrl;
      });

      final DatabaseReference databaseRef = _database.ref();
      final String key = _title; // Use the title as the key

      final DataSnapshot existingStorySnapshot = await databaseRef.child('fictional-stories').child(key).get();
      if (existingStorySnapshot.exists) {
        // Ask for confirmation to add new episode
        final bool addNewEpisode = await _showConfirmationDialog(context, 'A story with this title already exists. Do you want to add a new episode to it?');
        if (addNewEpisode) {
          await _addNewEpisode(databaseRef, key, audioUrl);
        } else {
          toastMessage('Upload canceled', Colors.red); // Cancel message
          return;
        }
      } else {
        // New story
        if (_category == 'Audiobook') {
          await databaseRef.child('audiobooks').child(key).set({
            'title': _title,
            'featureImage': featureImageUrl,
            'category': _category,
            'genre': _genre,
            'audioUrl': audioUrl,
          });
        } else if (_category == 'Fictional Story') {
          final Map<String, dynamic> storyData = {
            'title': _title,
            'featureImage': featureImageUrl,
            'genre': _genre,
            'episodes': [
              {
                'title': 'Episode 1',
                'audioUrl': audioUrl,
              },
            ],
          };
          await databaseRef.child('fictional-stories').child(key).set(storyData);
        }
      }

      toastMessage('Upload successful', Colors.green); // Success message
      print('Upload successful: $audioUrl');
    } catch (e) {
      toastMessage('Upload failed: $e', Colors.red); // Error message
      print('Upload failed: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String message) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(message),
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

  Future<void> _addNewEpisode(DatabaseReference databaseRef, String key, String audioUrl) async {
    final storyRef = databaseRef.child('fictional-stories').child(key);
    final DataSnapshot snapshot = await storyRef.child('episodes').get();
    List<dynamic> episodes = (snapshot.value as List<dynamic>?)?.toList() ?? [];
    final int episodeNumber = episodes.length + 1;
    episodes.add({
      'title': 'Episode $episodeNumber',
      'audioUrl': audioUrl,
    });
    await storyRef.child('episodes').set(episodes);
  }

  Future<String?> _uploadFeatureImage(File imageFile) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = _storage.ref().child('images/$fileName');
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Feature image upload failed: $e');
      return null;
    }
  }
}
