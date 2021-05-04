import 'package:app/assets/fonts/yama_icons_icons.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/utils/avatar_badge_helper.dart';
import 'package:app/ui/utils/tuple.dart';
import 'package:app/ui/utils/user_color_hash.dart';
import 'package:flutter/material.dart';

class MiniAvatar extends StatelessWidget {
  final UserProfile participant;

  const MiniAvatar({
    Key key,
    @required this.participant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Triple<bool, Color, String> avatarBagdeData = getAvatarBadgeData(participant, context);

    return Stack(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: avatarBagdeData.b,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
                  participant.imageUrl != null ? NetworkImage(participant.imageUrl) : null,
              child: participant.imageUrl != null
                  ? null
                  : Text(
                      participant.firstName[0] + participant.lastName[0],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
              backgroundColor: generateColor(participant.email),
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
