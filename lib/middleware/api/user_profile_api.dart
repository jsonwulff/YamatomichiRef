import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/utils/no_such_user_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

getUser(String userUid) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('userProfiles')
      .doc(userUid)
      .get();
  if (snapshot.data() == null) throw NoSuchUserException(userUid);
  UserProfile _userProfile = UserProfile.fromFirestore(snapshot);
  print('getUser called');
  return _userProfile;
}
