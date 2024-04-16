import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group6_project2/candidate.dart';
import 'package:group6_project2/post.dart';

class CandidateDetail extends StatefulWidget {
  final Candidate candidate;

  CandidateDetail({required this.candidate});

  @override
  _CandidateDetailState createState() => _CandidateDetailState();
}

class _CandidateDetailState extends State<CandidateDetail> {
  late DatabaseReference _database;
  List<Post> candidatePosts = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref().child('Candidates/${widget.candidate.Name}/Posts');
    _fetchCandidatePosts();
    _checkConnectionStatus();
  }

  void _fetchCandidatePosts() {
    _database.onValue.listen((event) {
      var dataSnapshot = event.snapshot.value;
      if (dataSnapshot != null && dataSnapshot is Map) {
        List<Post> fetchedPosts = [];
        dataSnapshot.forEach((key, value) {
          fetchedPosts.add(Post(
            value['username'] ?? '',
            value['userImage'] ?? '',
            value['postImage'] ?? '',
            value['postContent'] ?? '',
            value['isLiked'] ?? false,
          ));
        });

        setState(() {
          candidatePosts = fetchedPosts;
        });
      }
    });
  }

  void _checkConnectionStatus() {
    DatabaseReference connectionRef = FirebaseDatabase.instance
        .ref()
        .child('connections/${widget.candidate.Name}/status');

    connectionRef.onValue.listen((event) {
      var status = event.snapshot.value;
      setState(() {
        isConnected = (status != null && status == 'connected');
      });
    }, onError: (Object error) {
      print('Error checking connection status: $error');
    });
  }

  void _updateConnectionStatus(bool status) {
    String statusText = status ? 'connected' : 'remove';
    DatabaseReference connectionRef =
    FirebaseDatabase.instance.ref().child('connections/${widget.candidate.Name}');

    if (status) {
      List<Map<String, dynamic>> postsData = candidatePosts.map((post) {
        return {
          'username': post.username,
          'userImage': post.userImage,
          'postImage': post.postImage,
          'postContent': post.postContent,
          'isLiked': post.isLiked,
        };
      }).toList();

      connectionRef.set({
        'name': widget.candidate.Name,
        'email': widget.candidate.Email,
        'skills': widget.candidate.skills,
        'work_experience': widget.candidate.Work_experience,
        'photo': widget.candidate.Photo,
        'status': 'connected',
        'posts': postsData,
      }).then((_) {
        setState(() {
          isConnected = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected with ${widget.candidate.Name}'),
            backgroundColor: Color(0xFF781421),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    } else {
      connectionRef.remove().then((_) {
        setState(() {
          isConnected = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed ${widget.candidate.Name}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        title: Text(
          widget.candidate.Name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _showFullPhoto(context, widget.candidate.Photo);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.candidate.Photo),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' ${widget.candidate.Name}',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        ' ${widget.candidate.Email}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Job Role: ${widget.candidate.skills}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Experience: ${widget.candidate.Work_experience} years',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _updateConnectionStatus(!isConnected);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isConnected ? Colors.red : Color(0xFF781421),
                  ),
                ),
                child: Text(
                  isConnected ? 'Remove Connection' : 'Connect',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Posts:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: candidatePosts.length,
                itemBuilder: (context, index) {
                  final post = candidatePosts[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(post.userImage),
                            ),
                            title: Text(post.username),
                          ),
                          SizedBox(height: 8.0),
                          Image.network(
                            post.postImage,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            post.postContent,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullPhoto(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
