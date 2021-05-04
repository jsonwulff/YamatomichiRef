import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/views/packlist/components/tuple.dart';
import 'package:flutter/material.dart';

Tuple<bool, Color> getAvatarBadgeData(UserProfile userProfile, BuildContext context) {
  bool hasRole = false;
  Color roleColor = Colors.grey[400];
  if (userProfile.roles['yamatomichi'] == true) {
    roleColor = Colors.grey[900];
    hasRole = true;
  } else if (userProfile.roles['ambassador'] == true) {
    roleColor = Theme.of(context).primaryColor;
    hasRole = true;
  }

  return Tuple(hasRole, roleColor);
}
