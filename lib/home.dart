import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group6_project2/post.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Post> posts = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('connections');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _fetchPostsFromFirebase();
  }

  void _fetchPostsFromFirebase() {
    _database.onValue.listen((event) {
      var dataSnapshot = event.snapshot.value;
      if (dataSnapshot != null && dataSnapshot is Map) {
        List<Post> fetchedPosts = [];
        dataSnapshot.forEach((key, value) {
          if (value['posts'] != null) {
            value['posts'].forEach((post) {
              fetchedPosts.add(Post(
                post['username'] ?? '',
                post['userImage'] ?? '',
                post['postImage'] ?? '',
                post['postContent'] ?? '',
                post['isLiked'] ?? false,
              ));
            });
          }
        });

        setState(() {
          posts = fetchedPosts;
        });
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts', style: TextStyle(fontSize: 16)),
        toolbarHeight: 40,
      ),
      backgroundColor: Color(0xFFF7D9C9),
      body: posts.isEmpty
          ? Center(
        child: Text(
          'No Connections',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Center(
            child: FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
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
                          post.showFullText ? post.postContent : '${post.postContent.substring(0, 100)}...',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        if (post.postContent.length > 100) ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                post.showFullText = !post.showFullText;
                              });
                            },
                            child: Text(
                              post.showFullText ? 'Read Less' : 'Read More',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                        Divider(),
                        SizedBox(height: 3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: post.isLiked ? Colors.blue : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  post.isLiked = !post.isLiked;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
