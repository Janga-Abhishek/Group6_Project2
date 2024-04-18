import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group6_project2/candidate.dart';
import 'package:group6_project2/candidateDetails.dart';
import 'package:group6_project2/animations/candidateList.dart';
import 'package:group6_project2/myConnections.dart';

class Candidates extends StatefulWidget {
  @override
  _CandidatesState createState() => _CandidatesState();
}

class _CandidatesState extends State<Candidates> {
  List<Candidate> candidatesList = [];

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  void fetchCandidates() {
    DatabaseReference candidatesRef = FirebaseDatabase.instance.ref().child('Candidates');

    candidatesRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      candidatesList.clear();

      var data = dataSnapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (value is Map) {
            Candidate candidate = Candidate(
              value['Name'],
              value['Email'],
              value['Photo'],
              value['skills'],
              value['Work_experience'],
            );
            candidatesList.add(candidate);
          }
        });

        candidatesList.sort((a, b) => a.Name.compareTo(b.Name));

        setState(() {});
      }
    }, onError: (error) {
      print('Error fetching candidates: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Candidates List',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.people,
                      color:Color(0xFF781421)),
                  title: Text('My Connections'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyConnections()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
        toolbarHeight: 40,
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: ListView.builder(
        itemCount: candidatesList.length,
        itemBuilder: (context, index) {
          return CandidateListAnimation(
            candidate: candidatesList[index],
            animationDuration: Duration(milliseconds: 500),
            index: index,
          );
        },
      ),
    );
  }
}
