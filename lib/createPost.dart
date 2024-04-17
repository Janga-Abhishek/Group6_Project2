import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController _postContentController = TextEditingController();
  bool _isUploading = false;
  File? _imageFile;

  void _uploadPost() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isUploading = true;
    });

    String defaultUsername = "Professor Nicolas";
    String defaultUserImage =
        "https://firebasestorage.googleapis.com/v0/b/group6-project2-68a2a.appspot.com/o/profile%20photos%2Fprofessor.jpeg?alt=media&token=efcc0145-911e-4ef9-bdc9-919ec86502f8";

    DatabaseReference postRef = FirebaseDatabase.instance
        .ref()
        .child('Candidates')
        .child('Professor Nicolas')
        .child('Posts')
        .push();

    if (_imageFile != null) {
      FirebaseStorage.instance
          .ref()
          .child('posts/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(_imageFile!)
          .then((uploadTask) {
        uploadTask.ref.getDownloadURL().then((downloadUrl) {
          postRef.set({
            'username': defaultUsername,
            'userImage': defaultUserImage,
            'postContent': _postContentController.text,
            'postImage': downloadUrl,
          }).then((_) {
            if (mounted) {
              setState(() {
                _isUploading = false;
                _postContentController.clear();
                _imageFile = null;
                Navigator.pop(context);
              });
            }
          }).catchError((error) {
            if (mounted) {
              setState(() {
                _isUploading = false;
              });
            }
            print('Error uploading post: $error');
          });
        });
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
        print('Error uploading image: $error');
      });
    } else {
      postRef.set({
        'username': defaultUsername,
        'userImage': defaultUserImage,
        'postContent': _postContentController.text,
      }).then((_) {
        if (mounted) {
          setState(() {
            _isUploading = false;
            _postContentController.clear();
            Navigator.pop(context);
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
        print('Error uploading post: $error');
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7D9C9),
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        title: Text(
          'Write a Post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _postContentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write your post...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10.0),
            _imageFile != null ? Image.file(_imageFile!) : Container(),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadPost,
              child: _isUploading ? CircularProgressIndicator() : Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postContentController.dispose();
    super.dispose();
  }
}
