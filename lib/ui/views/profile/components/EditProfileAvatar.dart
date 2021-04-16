import 'dart:io';
import 'dart:math';
import 'package:app/constants/constants.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';

class EditProfileAvatar extends StatelessWidget {
  final UserProfile userProfile;
  final File croppedImageFile;
  final random = new Random();

  EditProfileAvatar({Key key, this.userProfile, this.croppedImageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 45,
      backgroundImage: croppedImageFile == null
          ? userProfile != null
              ? NetworkImage(userProfile.imageUrl)
              : null
          : FileImage(croppedImageFile),
      child: croppedImageFile == null
          ? userProfile.imageUrl != null
              ? null
              : Text(
                  userProfile.firstName[0] + userProfile.lastName[0],
                  style: TextStyle(fontSize: 40, color: Colors.white),
                )
          : Icon(Icons.edit, size: 32, color: Colors.white),
      backgroundColor: profileImageColors[random.nextInt(profileImageColors.length)],
    );
  }
}
