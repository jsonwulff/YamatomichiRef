import 'package:app/assets/fonts/yama_icons_icons.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/utils/avatar_badge_helper.dart';
import 'package:app/ui/utils/tuple.dart';
import 'package:app/ui/utils/user_color_hash.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileAvatar extends StatelessWidget {
  final UserProfile userProfile;
  final File imageFile;
  final double radius;
  final bool showBadge;

  const ProfileAvatar(
    this.userProfile,
    this.radius, {
    Key key,
    this.imageFile,
    this.showBadge = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Triple<bool, Color, String> avatarBagdeData = getAvatarBadgeData(userProfile, context);

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: avatarBagdeData.b,
          child: CircleAvatar(
            radius: radius - 3,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: radius - 8,
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
              backgroundColor: generateColor(userProfile.email),
            ),
          ),
        ),
        if (avatarBagdeData.a && showBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: -3, offset: Offset(1, 1))]),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: avatarBagdeData.b,
                child: Icon(
                  YamaIcons.yama_y,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          )
      ],
    );
  }
}
