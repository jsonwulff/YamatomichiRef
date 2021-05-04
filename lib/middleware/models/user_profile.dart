import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String id;
  String firstName;
  String lastName;
  String email;
  String country;
  String hikingRegion;
  String gender;
  String imageUrl;
  Timestamp birthday;
  Timestamp createdAt;
  Timestamp updatedAt;
  Map<String, dynamic> roles;
  bool isBanned;
  String bannedMessage;
  String description;


  UserProfile(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.country,
      this.hikingRegion,
      this.gender,
      this.imageUrl,
      this.birthday,
      this.createdAt,
      this.updatedAt,
      this.roles,
      this.isBanned = false,
      this.bannedMessage,
      this.description
      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'country': country,
      'hikingRegion': hikingRegion,
      'gender': gender,
      'imageUrl': imageUrl,
      'birthday': birthday,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'roles': roles,
      'isBanned': isBanned,
      'bannedMessage': bannedMessage,
      'description': description
    };
  }

  UserProfile.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    country = data['country'];
    hikingRegion = data['hikingRegion'];
    gender = data['gender'];
    imageUrl = data['imageUrl'];
    birthday = data['birthday'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    roles = data['roles'];
    isBanned = data['isBanned'];
    bannedMessage = data['bannedMessage'];
    description = data['description'];
  }

  factory UserProfile.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return UserProfile(
      id: documentSnapshot.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      country: data['country'],
      hikingRegion: data['hikingRegion'],
      gender: data['gender'],
      imageUrl: data['imageUrl'],
      birthday: data['birthday'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      roles: data['roles'],
      isBanned: data['isBanned'],
      bannedMessage: data['bannedMessage'],
      description: data['description']
    );
  }
}
