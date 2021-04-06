import 'package:app/middleware/api/user_profile_api.dart' as api;
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileService {
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
}
