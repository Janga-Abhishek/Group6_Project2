import 'package:firebase_database/firebase_database.dart';

class Candidate {
   String Name;
   String Email;
   String Photo;
   String skills;
   int Work_experience;

   Candidate(this.Name, this.Email, this.Photo, this.skills, this.Work_experience,);

   factory Candidate.fromSnapshot(DataSnapshot snapshot) {
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
         throw Exception("Failed to parse job data.");
      }
      return Candidate(
         data['Name'] ?? '',
         data['Email'] ?? '',
         data['Photo'] ?? '',
         data['skills'] ?? '',
         data['Work_experience'] ?? '',
      );
   }
}
