import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart' as api;
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  UserProfileService();

  getUserProfile(String userID) async {
    UserProfile userprofile = await api.getUser(userID);
    if (userprofile == null)
      return getUnknownUser();
    else
      return userprofile;
  }

  getUserProfileAsNotifier(String userID, UserProfileNotifier userProfileNotifier) async {
    if (userID.isEmpty) return 'missing ID';
    await api.getUserProfile(userID, userProfileNotifier);
  }

  updateUserProfile(UserProfile userProfile, Function userProfileUpdated) async {
    await api.updateUserProfile(userProfile, userProfileUpdated);
  }

  uploadUserProfileImage(UserProfile userProfile, File image) async {
    String filePath = 'profileImages/${userProfile.id}.jpg';
    Reference reference = storage.ref().child(filePath);
    await reference.putFile(image).whenComplete(() async {
      String imgUrl = await reference.getDownloadURL();
      userProfile.imageUrl = imgUrl;
      print(imgUrl);
    });
  }

  deleteUserProfileImage(UserProfile userProfile, Function userProfileUpdated) {
    Reference reference = storage.refFromURL(userProfile.imageUrl);
    reference.delete().whenComplete(() {
      userProfile.imageUrl = null;
      this.updateUserProfile(userProfile, userProfileUpdated);
    });
  }

  UserProfile getUnknownUser() {
    UserProfile userProfile = UserProfile();
    userProfile.id = "??";
    userProfile.email = "??@??.??";
    userProfile.firstName = "????";
    userProfile.lastName = "????????";
    userProfile.createdAt = Timestamp.now();
    userProfile.updatedAt = Timestamp.now();
    return userProfile;
  }

  Stream<UserProfile> getUserProfileStream(String userUid) {
    return api.getUserProfileStream(userUid);
  }
}
