import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<void> addEpisode(String storyId, String episodeTitle, File episodeAudio) async {
  String episodeId = Uuid().v4();

  // Upload episode audio file
  Reference episodeAudioRef = FirebaseStorage.instance.ref().child('audios/$episodeId.mp3');
  await episodeAudioRef.putFile(episodeAudio);
  String episodeAudioUrl = await episodeAudioRef.getDownloadURL();

  // Add episode details to the story document
  await FirebaseFirestore.instance.collection('stories').doc(storyId).update({
    'episodes': FieldValue.arrayUnion([
      {
        'episode_title': episodeTitle,
        'audio_url': episodeAudioUrl,
        'timestamp': FieldValue.serverTimestamp(),
      }
    ])
  });
}




class AddEpisodeScreen extends StatefulWidget {
  final String storyId;
  AddEpisodeScreen({required this.storyId});

  @override
  _AddEpisodeScreenState createState() => _AddEpisodeScreenState();
}

class _AddEpisodeScreenState extends State<AddEpisodeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _episodeTitle = '';
  File? _episodeAudio;

  Future<void> _pickEpisodeAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    setState(() {
      if (result != null) {
        _episodeAudio = File(result.files.first.path!);
      }
    });
  }

  Future<void> _saveEpisode() async {
    if (_formKey.currentState!.validate() && _episodeAudio != null) {
      _formKey.currentState!.save();
      await addEpisode(widget.storyId, _episodeTitle, _episodeAudio!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Episode'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Episode Title'),
                onSaved: (value) {
                  _episodeTitle = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an episode title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickEpisodeAudio,
                child: Text('Pick Episode Audio'),
              ),
              _episodeAudio == null
                  ? Text('No audio file selected.')
                  : Text('Audio file selected.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEpisode,
                child: Text('Save Episode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
