import 'package:firebase_database/firebase_database.dart';

class Job {
  final String title;
  final String company;
  final String location;
  final String logo;
  final String description;

  Job(this.title, this.company, this.location, this.logo, this.description);

  factory Job.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
    if (data == null) {
      throw Exception("Failed to parse job data.");
    }
    return Job(
      data['title'] ?? '',
      data['company'] ?? '',
      data['location'] ?? '',
      data['logo'] ?? '',
      data['description'] ?? '',
    );
  }
}
