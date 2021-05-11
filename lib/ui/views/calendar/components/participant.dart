import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/shared/components/mini_avatar.dart';
import 'package:app/ui/views/personalProfile/personal_profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Participant extends StatelessWidget {
  final UserProfile participant;

  const Participant({
    Key key,
    this.participant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (participant == null) return Container();
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            screen: PersonalProfileView(userID: participant.id), withNavBar: false);
      },
      child: MiniAvatar(user: participant),
    );
  }
}
