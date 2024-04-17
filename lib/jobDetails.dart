import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'job.dart';

class JobDetails extends StatefulWidget {
  final Job job;

  JobDetails({required this.job});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool applied = false;
  DatabaseReference _jobRef = FirebaseDatabase.instance.ref().child('AppliedJobs');

  @override
  void initState() {
    super.initState();
    _checkAppliedStatus();
  }

  void _checkAppliedStatus() {
    _jobRef.orderByChild('title').equalTo(widget.job.title).onValue.listen((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null && data.isNotEmpty) {
        setState(() {
          applied = true;
        });
      } else {
        setState(() {
          applied = false;
        });
      }
    });
  }

  void applyJob() {
    setState(() {
      applied = true;
    });

    _jobRef.push().set({
      'title': widget.job.title,
      'company': widget.job.company,
      'location': widget.job.location,
      'description': widget.job.description,
      'applied': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        title: Text(
          widget.job.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.job.logo,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Company: ${widget.job.company}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Location: ${widget.job.location}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text(
              'Description: ${widget.job.description}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: applied ? null : applyJob,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Color(0xFF781421);
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.white.withOpacity(0.5);
                    }
                    return Colors.white;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: Text(
                  applied ? 'Applied' : 'Apply Now',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
