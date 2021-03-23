import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getUserProfile(String userUid, UserProfileNotifier userProfileNotifier) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('userProfiles')
      .doc(userUid)
      .get();
  UserProfile _userProfile = UserProfile.fromFirestore(snapshot);
  userProfileNotifier.userProfile = _userProfile;
  print('getUserProfile called');
}

updateUserProfile(UserProfile userProfile, Function userProfileUpdated) async {
  CollectionReference userProfileRef =
      FirebaseFirestore.instance.collection('userProfiles');
  userProfile.updatedAt = Timestamp.now();
  await userProfileRef.doc(userProfile.id).update(userProfile.toMap());

  userProfileUpdated(userProfile);
  print('updateUserProfile called');
}

isAdmin(BuildContext context) async {
  String userUid;
  UserProfileNotifier userProfileNotifier =
      Provider.of<UserProfileNotifier>(context, listen: false);
  if (userProfileNotifier.userProfile == null) {
    userUid = context.read<AuthenticationService>().user.uid;
    await getUserProfile(userUid, userProfileNotifier);
  } else {
    userUid = context.read<AuthenticationService>().user.uid;
  }
  UserProfile userProfile = userProfileNotifier.userProfile;
  print(userProfileNotifier);
  print(userProfile);

  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('userProfiles')
      .doc(userUid)
      .get();

  print(snapshot.data()['roles']);

  if (snapshot.data().containsKey('roles') &&
      snapshot.data()['roles'].containsKey('administrator') &&
      snapshot.data()['roles']['administrator']) {
    userProfile.roles['administrator'] = true;
    print('admin set to true');
  } else {
    userProfile.roles['administrator'] = false;
    print('admin set to false');
  }

  /*snapshot.data().containsKey('roles') &&
      snapshot.data()['roles'].containsKey('administrator') &&
      snapshot.data()['roles']['administrator'])*/

  print('userprofile roles ' + userProfile.roles.toString());
  getUserProfile(userUid, userProfileNotifier);

  /*print(snapshot.data().containsKey('roles'));
  print(snapshot.data()['roles']);

  if (snapshot.data().containsKey('roles') &&
      snapshot.data()['roles'] == 'administrator: true') {
    answer = true;
    return answer;
  } else {
    answer = false;
    return answer;
  }*/
}
