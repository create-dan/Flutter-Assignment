// ignore_for_file: prefer_const_constructors

import 'package:blackcoffer_flutter/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkIanAzJ8Ye886ObbACRUVRXnds7ekeIS3KL7L8kRlUw&s'), // Replace with your profile image asset
          ),
          SizedBox(height: 20),

          ListTile(
            leading: Icon(Icons.important_devices, color: Colors.green),
            title: Text(
              'User Id',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user?.uid ?? '', // Replace with the user's phone number
              style: TextStyle(fontSize: 16),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                // Redirect to the sign-in or home screen
                // You can use Navigator for navigation:
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUp()));
              } catch (e) {
                print('Error signing out: $e');
              }
            },
            child: Text(
              'Sign Out',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Customize the button color
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
