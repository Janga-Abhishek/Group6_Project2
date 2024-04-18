import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group6_project2/job.dart';
import 'package:group6_project2/jobDetails.dart';
import 'package:group6_project2/appliedJobs.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  List<Job> jobsList = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    fetchJobs();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void fetchJobs() {
    DatabaseReference jobsRef = FirebaseDatabase.instance.ref().child('jobs');

    jobsRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      jobsList.clear();

      var data = dataSnapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (value is Map) {
            Job job = Job(
              value['title'],
              value['company'],
              value['location'],
              value['logo'],
              value['description'],
            );
            jobsList.add(job);
          }
        });
        setState(() {});
      }
    }, onError: (error) {
      print('Error fetching jobs: $error');
    });
  }

  void _handleMenuClick(String value) {
    if (value == 'applied_jobs') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppliedJobs()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Listings',
          style: TextStyle(fontSize: 16),
        ),
        toolbarHeight: 40,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: _handleMenuClick,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'applied_jobs',
                  child: Row(
                    children: [
                      Icon(Icons.work,
                          color:Color(0xFF781421)),
                      SizedBox(width: 10),
                      Text('Applied Jobs'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: jobsList.length,
        itemBuilder: (context, index) {
          final job = jobsList[index];
          return SlideTransition(
            position: _offsetAnimation,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetails(job: job),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFF781421)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(job.logo),
                      ),
                      SizedBox(height: 8.0),
                      Text(job.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(job.company),
                      Text(job.location),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
