import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/user_profile.dart';

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

/*isAdmin(String userUid) async {
  bool answer;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('userProfiles')
      .doc(userUid)
      .get();

  print(snapshot.data().containsKey('Roles'));
  print(snapshot.data()['Roles']);

  if (snapshot.data().containsKey('Roles') &&
      snapshot.data()['Roles'] == 'Administrator: true') {
    answer = true;
    return answer;
  } else {
    answer = false;
    return answer;
  }
}*/
