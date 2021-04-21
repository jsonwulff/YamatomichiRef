import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
        backgroundColor:
            generateColor() //profileImageColors[_random.nextInt(profileImageColors.length)],
        );
  }

  Color generateColor() {
    int hash = _userProfile.email.hashCode.abs();
    int red = ((hash % 12) * 16) + 31;
    hash ~/= 65536;
    int green = ((hash % 12) * 16) + 31;
    hash ~/= 65536;
    int blue = ((hash % 12) * 16) + 31;
    return Color.fromARGB(255, red, green, blue);
  }
}
