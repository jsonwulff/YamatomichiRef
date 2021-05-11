import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/snackbar/snackbar_custom.dart';
import 'package:app/ui/views/profile/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'authentication_service_firebase.dart'; // Use localization

class DynamicLinkService {
  static ActionCodeSettings generateResetPasswordCode(String email) {
    return ActionCodeSettings(
      // url: 'https://yamatomichi.page.link.com/password-reset?email=${email}',
      url: 'https://yamatomichi.page.link.com/?email=${email}',
      dynamicLinkDomain: "yamatomichi.page.link",
      androidPackageName: "com.yamatomichi.app",
      androidMinimumVersion: "0",
      // TODO:Lukas: handle iOS
      iOSBundleId: "com.yamatomichi.app",
      handleCodeInApp: true,
    );
  }

  static void initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        var actionCode = deepLink.queryParameters['oobCode'];
        
        FirebaseAuth auth = FirebaseAuth.instance;

        try {
          var userEmail = await auth.verifyPasswordResetCode(actionCode);
          
          if (deepLink != null && userEmail != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordView(resetPasswordActionCode: actionCode)));
          }
        } on FirebaseAuthException catch (e) {
          SnackBarCustom.useSnackbarOfContext(context,
              e.toString()); //AppLocalizations.of(context).sorryErrorOccurred);
          // if (e.code == 'invalid-action-code') {
          // }
        }
      },
      onError: (OnLinkErrorException e) async {
        SnackBarCustom.useSnackbarOfContext(context,
            e.toString()); //AppLocalizations.of(context).sorryErrorOccurred);
      },
    );
  }
}
