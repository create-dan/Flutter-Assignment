// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blackcoffer_flutter/Auth/signup.dart';
import 'package:blackcoffer_flutter/Screens/MainScreen.dart';
import 'package:blackcoffer_flutter/Screens/record_video_screen.dart';
import 'package:blackcoffer_flutter/Screens/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Replace the home property with your record_video_screen widget.
      // home: MainScreen(),
      home: user != null ? MainScreen() : SignUp(),
     // home:VideoApp(),
    );
  }
}


