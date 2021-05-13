import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/utils/tuple.dart';
import 'package:flutter/material.dart';

Triple<bool, Color, String> getAvatarBadgeData(UserProfile userProfile, BuildContext context) {
  bool hasRole = false;
  Color roleColor = Colors.grey[400];
  String userType = 'Official Yamatomichi ';
  if (userProfile.roles == null) return Triple(hasRole, roleColor, userType);
  if (userProfile.roles['yamatomichi'] == true) {
    roleColor = Colors.grey[900];
    hasRole = true;
    userType += 'user';
  } else if (userProfile.roles['ambassador'] == true) {
    roleColor = Theme.of(context).primaryColor;
    hasRole = true;
    userType += 'Ambassador';
  }

  return Triple(hasRole, roleColor, userType);
}
