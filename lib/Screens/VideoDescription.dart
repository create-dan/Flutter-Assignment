// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blackcoffer_flutter/screens/record_video_screen.dart';

class VideoDescription extends StatefulWidget {
  const VideoDescription({Key? key}) : super(key: key);

  @override
  State<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  late DocumentReference videoDocumentRef;


  Future<void> _saveVideoDataAndNavigate() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final String userId = user.uid;

        // Save video data to Firestore
        final DocumentReference docRef = await _firestore.collection('videos').add({
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'category': categoryController.text.trim(),
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // videoDocumentRef = docRef;
        await _firestore
            .collection("videos")
            .doc(docRef.id)
            .set({"videoId": docRef.id}, SetOptions(merge: true));

        print('Doneeee'); // This line should print when everything is successful

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecordVideoScreen(videoId: docRef.id),
          ),
        );
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error saving video data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Description'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _saveVideoDataAndNavigate,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
