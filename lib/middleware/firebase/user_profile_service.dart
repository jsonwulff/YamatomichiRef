import 'package:app/middleware/api/user_profile_api.dart' as api;
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
