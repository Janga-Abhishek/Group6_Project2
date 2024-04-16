import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePosts createState() => _CreatePosts();
}

class _CreatePosts extends State<CreatePost> {
  bool isJobListing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: Text('Job Listing'),
              value: isJobListing,
              onChanged: (value) {
                setState(() {
                  isJobListing = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
