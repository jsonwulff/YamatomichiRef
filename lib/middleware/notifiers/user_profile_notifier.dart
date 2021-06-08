import 'dart:io';

import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserProfileNotifier with ChangeNotifier {
  UserProfile _userProfile;
  UserProfile get userProfile => _userProfile;
  set userProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  File _imageToBeUploaded;
  File get imageToBeUploaded => _imageToBeUploaded;
  set imageToBeUploaded(File imageToBeUploaded) {
    _imageToBeUploaded = imageToBeUploaded;
    notifyListeners();
  }
}
