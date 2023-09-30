// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blackcoffer_flutter/Screens/HistoryScreen.dart';
import 'package:blackcoffer_flutter/Screens/MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class RecordVideoScreen extends StatefulWidget {
  final String videoId;
  const RecordVideoScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  State<RecordVideoScreen> createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    return _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _uploadVideoToFirebase(XFile videoFile) async {
    print("Uploading...");
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('videos/${DateTime.now()}.mp4');

    try {
      final UploadTask uploadTask = storageRef.putFile(File(videoFile.path));
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});


    } catch (e) {
      print('Error uploading video to Firebase Storage: $e');
    }
  }
  Future<void> _startStopRecording() async {
    // Wait until the camera controller is initialized before starting recording
    await _initializeControllerFuture;

    if (!_isRecording) {
      try {
        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;

        });
      } catch (e) {
        print('Error starting video recording: $e');
      }
    } else {
      try {
        final XFile videoFile = await _controller!.stopVideoRecording();
        setState(() {
          _isRecording = false;
          _isUploading = true;
        });
        print("videoUrl");
        print(videoFile.path);
        final Reference storageRef = FirebaseStorage.instance.ref().child('videos/${DateTime.now()}.mp4');

        // Convert XFile to File
        final File video = File(videoFile.path);

        // Upload the video file to Firebase Storage
        await storageRef.putFile(video);

        // Get the download URL of the uploaded video
        final String downloadURL = await storageRef.getDownloadURL();


        CollectionReference videoCollectionRef =  FirebaseFirestore.instance.collection("videos");

      // Update the document in the videos collection with the video URL
        await videoCollectionRef.doc(widget.videoId).set({
          'videoUrl': downloadURL,
        },SetOptions(merge: true));

        // Upload the recorded video to Firebase Storage
        print('Uploaded video successfully');


        setState(() {
          _isUploading = false; // Set back to false after video is uploaded
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Video uploaded successfully.'),
          ),
        );

        if(mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(idx: 2)),
          );
        }
        // await _uploadVideoToFirebase(videoFile);

      } catch (e) {
        print('Error stopping video recording: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Check if the controller is initialized before using it
            if (_initializeControllerFuture != null)
              Expanded(
                child: Stack(
                  children: <Widget>[
                    if(_controller != null && _controller!.value.isInitialized)
                    Container(
                      alignment: Alignment.center,
                      child: CameraPreview(_controller!),

                    ),
                    if (_isRecording)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 32,
                              color: Colors.red,
                            ),
                            Text(
                              'Recording has started',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_isUploading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              )
            else
              CircularProgressIndicator(), // Show loading indicator while initializing
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _startStopRecording,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    _isRecording ? Icons.stop : Icons.fiber_manual_record,
                    color: _isRecording ? Colors.red : Colors.orange,
                  ),
                  Text(

                    _isRecording ? 'Stop Recording' : 'Start Recording',
                    style: TextStyle(
                      color: _isRecording ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
