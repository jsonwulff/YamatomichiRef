import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String id;
  String firstName;
  String lastName;
  String email;
  String gender;
  String imageUrl;
  Timestamp birthday;
  Timestamp createdAt;
  Timestamp updatedAt;

  UserProfile(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.imageUrl,
      this.birthday,
      this.createdAt,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'imageUrl': imageUrl,
      'birthday': birthday,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  UserProfile.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    gender = data['gender'];
    imageUrl = data['imageUrl'];
    birthday = data['birthday'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  factory UserProfile.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return UserProfile(
      id: documentSnapshot.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      gender: data['gender'],
      imageUrl: data['imageUrl'],
      birthday: data['birthday'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}
