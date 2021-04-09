import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserProfileNotifier with ChangeNotifier {
  UserProfile _userProfile;

  UserProfile get userProfile => _userProfile;

  set userProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    print('userProfile set in notifier');
    notifyListeners();
  }
}
