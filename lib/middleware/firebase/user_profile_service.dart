import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart' as api;
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/utils/no_such_user_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  UserProfileService();

  getUserProfile(String userID) async {
    try {
      UserProfile userprofile = await api.getUser(userID);
      return userprofile;
    } on NoSuchUserException {
      return getUnknownUser();
    }
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

  isAdmin(String userUid, UserProfileNotifier userProfileNotifier) async {
    UserProfile userProfile = userProfileNotifier.userProfile;

    UserProfile userProfileFromFirestore = await getUserProfile(userUid);
    //DocumentSnapshot snapshot = await _store.collection('userProfiles').doc(userUid).get();

    if (userProfileFromFirestore.roles != null) {
      if (userProfileFromFirestore.roles.containsKey('administrator')) {
        if (userProfileFromFirestore.roles['administrator']) {
          userProfile.roles['administrator'] = true;
          print('admin set to true');
        } else {
          userProfile.roles['administrator'] = false;
          print('admin set to false');
        }
      } else {
        userProfile.roles['administrator'] = false;
        print('admin set to false');
      }
    }

    getUserProfileAsNotifier(userUid, userProfileNotifier);
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
