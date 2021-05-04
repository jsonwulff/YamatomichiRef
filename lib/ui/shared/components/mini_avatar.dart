import 'package:app/assets/fonts/yama_icons_icons.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/utils/avatar_badge_helper.dart';
import 'package:app/ui/utils/tuple.dart';
import 'package:app/ui/utils/user_color_hash.dart';
import 'package:flutter/material.dart';

class MiniAvatar extends StatelessWidget {
  final UserProfile user;

  const MiniAvatar({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Triple<bool, Color, String> avatarBagdeData = getAvatarBadgeData(user, context);

    return Stack(
      children: [
        CircleAvatar(
          radius: 22.5,
          backgroundColor: avatarBagdeData.b,
          child: CircleAvatar(
            radius: 20.5,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 18.5,
              backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl) : null,
              child: user.imageUrl != null
                  ? null
                  : Text(
                      user.firstName[0] + user.lastName[0],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
              backgroundColor: generateColor(user.email),
            ),
          ),
        ),
        if (avatarBagdeData.a)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: -3, offset: Offset(1, 1))]),
              child: CircleAvatar(
                radius: 8,
                backgroundColor: avatarBagdeData.b,
                child: Icon(
                  YamaIcons.yama_y,
                  color: Colors.white,
                  size: 7,
                ),
              ),
            ),
          )
      ],
    );
  }
}
