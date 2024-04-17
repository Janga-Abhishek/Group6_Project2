import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group6_project2/candidate.dart';
import 'package:group6_project2/candidateDetails.dart';
import 'package:group6_project2/animations/candidateList.dart';

class MyConnections extends StatefulWidget {
  @override
  _MyConnectionsState createState() => _MyConnectionsState();
}

class _MyConnectionsState extends State<MyConnections> {
  List<Candidate> connectionsList = [];

  @override
  void initState() {
    super.initState();
    fetchConnections();
  }

  void fetchConnections() {
    DatabaseReference connectionsRef = FirebaseDatabase.instance.ref().child('connections');

    connectionsRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      connectionsList.clear();

      var data = dataSnapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (value is Map) {
            Candidate candidate = Candidate(
              value['name'],
              value['email'],
              value['photo'],
              value['skills'],
              value['work_experience'],
            );
            connectionsList.add(candidate);
          }
        });

        connectionsList.sort((a, b) => a.Name.compareTo(b.Name));

        setState(() {});
      }
    }, onError: (error) {
      print('Error fetching connections: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        title: Text(
          'My Connections',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,),
        ),
        toolbarHeight: 60,
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: ListView.builder(
        itemCount: connectionsList.length,
        itemBuilder: (context, index) {
          return CandidateListAnimation(
            candidate: connectionsList[index],
            animationDuration: Duration(milliseconds: 500),
            index: index,
          );
        },
      ),
    );
  }
}
