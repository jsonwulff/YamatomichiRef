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

  Future<UserProfile> getUserProfile(String userID) async {
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

  checkRoles(String userUid, UserProfileNotifier userProfileNotifier) async {
    UserProfile userProfile = userProfileNotifier.userProfile;

    UserProfile userProfileFromFirestore = await getUserProfile(userUid);
    //DocumentSnapshot snapshot = await _store.collection('userProfiles').doc(userUid).get();

    if (userProfileFromFirestore.roles['ambassador']) {
      userProfile.roles['ambassador'] = true;
      print('ambassador set to true');
    } else {
      userProfile.roles['ambassador'] = false;
      print('ambassador set to false');
    }

    if (userProfileFromFirestore.roles['yamatomichi']) {
      userProfile.roles['yamatomichi'] = true;
      print('yamatomichi set to true');
    } else {
      userProfile.roles['yamatomichi'] = false;
      print('yamatomichi set to false');
    }

    getUserProfileAsNotifier(userUid, userProfileNotifier);
  }

  UserProfile getUnknownUser() {
    UserProfile userProfile = UserProfile();
    userProfile.id = "???????";
    userProfile.email = "UnknownUser@Unknown.Unknown";
    userProfile.firstName = "Unknown";
    userProfile.lastName = "User";
    userProfile.createdAt = Timestamp.now();
    userProfile.updatedAt = Timestamp.now();
    userProfile.roles = {'ambassador': false};
    userProfile.roles = {'yamatomichi': false};
    userProfile.description =
        "Hello! Im an Unknown User, which means that I was either deleted or something went wrong retrieving my data.";
    return userProfile;
  }

  Stream<UserProfile> getUserProfileStream(String userUid) {
    return api.getUserProfileStream(userUid);
  }
}
