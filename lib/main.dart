import 'dart:io';

import 'package:flutter/material.dart';
import 'package:group6_project2/home.dart';
import 'package:group6_project2/candidates.dart';
import 'package:group6_project2/jobList.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:"AIzaSyACxo-AIzaSyC58KZJ-n4J2lDHXt0L-5evIfJaXchgsWc",
      appId:"1:962439236287:android:a5fb761d3236e57774d40a",
      messagingSenderId:"962439236287",
      projectId: "group6-project2-68a2a",
    ),
  )
      :await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Candidates(),
    JobList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        centerTitle: true,
        title: Image.asset(
          'images/group6_logo.png',
          height: 40,
        ),
      ),
      body: Container(
        color: Color(0xFFF7D9C9),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'My Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF781421),
        onTap: _onItemTapped,
      ),
    );
  }
}
