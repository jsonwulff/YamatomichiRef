import 'package:app/middleware/api/user_profile_api.dart' as api;
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/utils/no_such_user_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  UserProfileService();

  Future<UserProfile> getUserProfile(String userID) async {
    try {
      UserProfile userprofile = await api.getUser(userID);
      return userprofile;
    } on NoSuchUserException {
      return getUnknownUser();
    }
  }

  getUserProfileAsNotifier(
      String userID, UserProfileNotifier userProfileNotifier) async {
    if (userID.isEmpty) return 'missing ID';
    await api.getUserProfile(userID, userProfileNotifier);
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
    userProfile.id = "??";
    userProfile.email = "??@??.??";
    userProfile.firstName = "????";
    userProfile.lastName = "????????";
    userProfile.createdAt = Timestamp.now();
    userProfile.updatedAt = Timestamp.now();
    return userProfile;
  }
}
