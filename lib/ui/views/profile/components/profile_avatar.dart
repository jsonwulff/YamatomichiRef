import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/utils/user_color_hash.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// TODO: fix the ignore
// ignore: must_be_immutable
class ProfileAvatar extends StatelessWidget {
  UserProfile _userProfile;
  File _croppedImageFile;
  double _radius;

  ProfileAvatar(UserProfile profile, double radius, [File croppedImage]) {
    this._userProfile = profile;
    this._croppedImageFile = croppedImage;
    this._radius = radius;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: _radius,
        backgroundImage: _croppedImageFile == null
            ? _userProfile.imageUrl == null
                ? null
                : NetworkImage(_userProfile.imageUrl)
            : FileImage(_croppedImageFile),
        child: _croppedImageFile == null
            ? _userProfile.imageUrl != null
                ? null
                : Text(
                    _userProfile.firstName[0] + _userProfile.lastName[0],
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  )
            : Icon(
                Icons.edit,
                size: 32,
                color: Colors.white,
              ),
        backgroundColor: generateColor(
            _userProfile.email) //profileImageColors[_random.nextInt(profileImageColors.length)],
        );
  }
}
