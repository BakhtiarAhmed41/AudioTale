import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Admin(),
    );
  }
}

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _category = 'Audiobook';
  String _genre = '';
  File? _featureImage;
  File? _audioFile;

  final picker = ImagePicker();

  Future<void> _pickFeatureImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _featureImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    setState(() {
      if (result != null) {
        _audioFile = File(result.files.first.path!);
      }
    });
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate() && _featureImage != null && _audioFile != null) {
      String uuid = Uuid().v4();
      try {
        // Upload feature image
        String imageFileName = 'feature_images/$uuid.jpg';
        TaskSnapshot imageSnapshot = await FirebaseStorage.instance
            .ref(imageFileName)
            .putFile(_featureImage!);
        String imageUrl = await imageSnapshot.ref.getDownloadURL();

        // Upload audio file
        String audioFileName = 'audios/$uuid.mp3';
        TaskSnapshot audioSnapshot = await FirebaseStorage.instance
            .ref(audioFileName)
            .putFile(_audioFile!);
        String audioUrl = await audioSnapshot.ref.getDownloadURL();

        // Save data to Firestore
        await FirebaseFirestore.instance.collection('stories').doc(uuid).set({
          'title': _title,
          'category': _category,
          'genre': _genre,
          'featureImage': imageUrl,
          'audioUrl': audioUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Upload Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _category,
                items: ['Audiobook', 'Fictional Story']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Genre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a genre';
                  }
                  return null;
                },
                onChanged: (value) {
                  _genre = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickFeatureImage,
                child: Text('Select Feature Image'),
              ),
              _featureImage != null
                  ? Image.file(_featureImage!, height: 100, width: 100)
                  : Container(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickAudioFile,
                child: Text('Select Audio File'),
              ),
              _audioFile != null ? Text('Audio selected') : Container(),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _uploadData,
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
