import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group6_project2/job.dart';

class AppliedJobs extends StatefulWidget {
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  late List<Job> appliedJobsList = [];

  @override
  void initState() {
    super.initState();
    fetchAppliedJobs();
  }

  void fetchAppliedJobs() {
    DatabaseReference appliedJobsRef =
    FirebaseDatabase.instance.ref().child('AppliedJobs');

    appliedJobsRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      List<Job> tempAppliedJobsList = [];

      var data = dataSnapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (value is Map) {
            try {
              Job appliedJob = Job(
                value['title'] ?? '',
                value['company'] ?? '',
                value['location'] ?? '',
                value['logo'] ?? '',
                value['description'] ?? '',
              );
              tempAppliedJobsList.add(appliedJob);
            } catch (e) {
              print('Error parsing job data: $e');
            }
          }
        });
        setState(() {
          appliedJobsList = tempAppliedJobsList;
        });
      }
    }, onError: (error) {
      print('Error fetching applied jobs: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        title: Text('Applied Jobs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: appliedJobsList.isNotEmpty
          ? ListView.builder(
        itemCount: appliedJobsList.length,
        itemBuilder: (context, index) {
          final appliedJob = appliedJobsList[index];
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                appliedJob.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                '${appliedJob.company}, ${appliedJob.location}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(appliedJob.logo),
              ),
              onTap: () {
              },
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
