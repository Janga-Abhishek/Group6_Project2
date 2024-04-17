import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class CreateJob extends StatefulWidget {
  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _logoImage;
  String _logoUrl = '';

  Future<void> _submitJob() async {
    String title = _titleController.text.trim();
    String company = _companyController.text.trim();
    String location = _locationController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isEmpty || company.isEmpty || location.isEmpty || description.isEmpty) {
      return;
    }

    DatabaseReference jobRef = FirebaseDatabase.instance.ref().child('jobs');
    String jobId = jobRef.push().key ?? '';

    Map<String, dynamic> jobData = {
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'logo': _logoUrl,
    };

    jobRef.child(jobId).set(jobData).then((_) {
      print('Job data saved to Firebase.');
      Navigator.pop(context);
    }).catchError((error) {
      print('Error saving job data: $error');
    });
  }

  Future<void> _pickLogoImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _logoImage = File(pickedImage.path);
        });

        if (_logoImage != null) {
          print('Image Path: ${_logoImage!.path}');
          print('Image Size: ${_logoImage!.lengthSync()} bytes');
          await _uploadLogoImage();
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadLogoImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('jobs/$fileName');
    UploadTask uploadTask = storageReference.putFile(_logoImage!);

    await uploadTask.whenComplete(() async {
      _logoUrl = await storageReference.getDownloadURL();
      print('Logo uploaded: $_logoUrl');
    }).catchError((onError) {
      print('Error uploading logo: $onError');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7D9C9),
      appBar: AppBar(
        backgroundColor: Color(0xFF781421),
        title: Text(
          'Create a Job',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Job Title',
                  hintText: 'Enter job title',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Company',
                  hintText: 'Enter company name',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter job location',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _pickLogoImage,
                    child: Text(
                      'Pick Logo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      backgroundColor: Color(0xFF781421),
                      minimumSize: Size(120, 40),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      width: 200,
                      child: _logoImage != null
                          ? Image.file(_logoImage!)
                          : Container(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Job Description',
                  hintText: 'Enter job description',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitJob,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 160.0, vertical: 12.0),
                  backgroundColor: Color(0xFF781421),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
