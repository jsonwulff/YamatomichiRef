import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/utils/user_color_hash.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileAvatar extends StatelessWidget {
  final UserProfile userProfile;
  final File imageFile;
  final double radius;

  const ProfileAvatar(
    this.userProfile,
    this.radius, {
    Key key,
    this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).primaryColor,
      child: CircleAvatar(
        radius: radius - 3,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: CircleAvatar(
            radius: radius - 6,
            backgroundImage: imageFile == null
                ? userProfile.imageUrl == null
                    ? null
                    : NetworkImage(userProfile.imageUrl)
                : FileImage(imageFile),
            child: imageFile == null
                ? userProfile.imageUrl != null
                    ? null
                    : Text(
                        userProfile.firstName[0] + userProfile.lastName[0],
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )
                : Icon(
                    Icons.edit,
                    size: 32,
                    color: Colors.white,
                  ),
            backgroundColor: generateColor(userProfile.email)),
      ),
    );
  }
}
