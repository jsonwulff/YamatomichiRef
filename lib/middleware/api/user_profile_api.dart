import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseFirestore _store = FirebaseFirestore.instance;

changeSource(FirebaseFirestore store) {
  _store = store;
}

getUserProfile(String userUid, UserProfileNotifier userProfileNotifier) async {
  DocumentSnapshot snapshot =
      await _store.collection('userProfiles').doc(userUid).get();
  UserProfile _userProfile = UserProfile.fromFirestore(snapshot);
  userProfileNotifier.userProfile = _userProfile;
  print('getUserProfile called');
}

updateUserProfile(UserProfile userProfile, Function userProfileUpdated) async {
  CollectionReference userProfileRef = _store.collection('userProfiles');
  userProfile.updatedAt = Timestamp.now();
  await userProfileRef.doc(userProfile.id).update(userProfile.toMap());

  userProfileUpdated(userProfile);
  print('updateUserProfile called');
}

isAdmin(String userUid, UserProfileNotifier userProfileNotifier) async {
  /*String userUid;
  UserProfileNotifier userProfileNotifier =
      Provider.of<UserProfileNotifier>(context, listen: false);
  if (userProfileNotifier.userProfile == null) {
    userUid = context.read<AuthenticationService>().user.uid;
    await getUserProfile(userUid, userProfileNotifier);
  } else {
    userUid = context.read<AuthenticationService>().user.uid;
  }*/

  UserProfile userProfile = userProfileNotifier.userProfile;

  DocumentSnapshot snapshot =
      await _store.collection('userProfiles').doc(userUid).get();

  if (snapshot.data().containsKey('roles')) {
    if (snapshot.data()['roles'] != null) {
      if (snapshot.data()['roles'].containsKey('administrator')) {
        if (snapshot.data()['roles']['administrator']) {
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
  }
  getUserProfile(userUid, userProfileNotifier);
}
