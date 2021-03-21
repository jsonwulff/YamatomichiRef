import 'package:app/constants.dart';
import 'package:app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({
    Key key,
    @required Random random,
    @required UserProfile userProfile,
  })  : _random = random,
        _userProfile = userProfile,
        super(key: key);

  final Random _random;
  final UserProfile _userProfile;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50.0,
      backgroundColor: profileImageColors[_random.nextInt(profileImageColors.length)],
      child: Text(
        _userProfile.firstName[0] + _userProfile.lastName[0],
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }
}
