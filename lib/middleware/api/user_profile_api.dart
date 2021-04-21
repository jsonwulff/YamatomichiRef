import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/utils/no_such_user_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

FirebaseFirestore _store = FirebaseFirestore.instance;

changeSource(FirebaseFirestore store) {
  _store = store;
}

getUserProfile(String userUid, UserProfileNotifier userProfileNotifier) async {
  DocumentSnapshot snapshot = await _store.collection('userProfiles').doc(userUid).get();
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
  UserProfile userProfile = userProfileNotifier.userProfile;

  DocumentSnapshot snapshot = await _store.collection('userProfiles').doc(userUid).get();

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

getUser(String userUid) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('userProfiles').doc(userUid).get();
  if (snapshot.data() == null) throw NoSuchUserException(userUid);
  UserProfile _userProfile = UserProfile.fromFirestore(snapshot);
  print('getUser called');
  return _userProfile;
}

getUserProfileStream(String userUid) {
  print('getUserProfileStream called');
  DocumentReference doc = FirebaseFirestore.instance.collection('userProfiles').doc(userUid);
  StreamController<UserProfile> controller = StreamController<UserProfile>();
  doc.snapshots().listen((event) {
    controller.add(UserProfile.fromFirestore(event));
  }, onDone: () {
    controller.close();
  });
  return controller.stream;
}
