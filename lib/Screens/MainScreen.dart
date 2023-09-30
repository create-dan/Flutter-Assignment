// ignore_for_file: prefer_const_constructors

import 'package:blackcoffer_flutter/Screens/HistoryScreen.dart';
import 'package:blackcoffer_flutter/Screens/ProfileScreen.dart';
import 'package:blackcoffer_flutter/Screens/VideoDescription.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int idx;
  const MainScreen({Key? key,  this.idx=0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Index of the currently selected tab

  // Create a list of screens for each tab
  final List<Widget> _screens = [
    ProfileScreen(),
    VideoDescription(),
    HistoryScreen(),
    // RecordVideoScreen(),
  ];

  @override
  void initState() {
    _currentIndex = widget.idx;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My App'),
      // ),
      body: _screens[_currentIndex], // Display the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change the selected tab
          });
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
