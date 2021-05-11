import 'package:app/ui/shared/snackbar/snackbar_custom.dart';
import 'package:app/ui/views/profile/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'authentication_validation.dart';

class DynamicLinkService {
  /// Given an invalid [email] will cause an FormatException
  static ActionCodeSettings generateResetPasswordCode(String email) {
    if (AuthenticationValidation.validateEmail(email) != null) {
      throw FormatException('Email invaled');
    } else {
      return ActionCodeSettings(
        // NOTE: Email might not be used, but it is left there to confuse hackers
        url: 'https://yamatomichi.page.link.com/?email=$email',
        dynamicLinkDomain: "yamatomichi.page.link",
        androidPackageName: "com.yamatomichi.app",
        // androidMinimumVersion: "5",
        iOSBundleId: "com.yamatomichi.app",
        handleCodeInApp: true,
      );
    }
  }

  static void initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        var actionCode = deepLink.queryParameters['oobCode'];

        // NOTE: the line below will not work, as it doesn't seem like the AuthenticationService
        // have been instanciated hence FireabseAuth has to be called directly which isn't 
        // optimal
        // var auth = Provider.of<AuthenticationService>(context).firebaseAuth;
        FirebaseAuth auth = FirebaseAuth.instance;

        try {
          var userEmail = await auth.verifyPasswordResetCode(actionCode);

          if (deepLink != null && userEmail != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordView(resetPasswordActionCode: actionCode)));
          } else {
            SnackBarCustom.useSnackbarOfContext(
                context, AppLocalizations.of(context).sorryErrorOccurred);
          }
        } on FirebaseAuthException catch (_) {
          SnackBarCustom.useSnackbarOfContext(
              context, AppLocalizations.of(context).sorryErrorOccurred);
        }
      },
      onError: (OnLinkErrorException e) async {
        SnackBarCustom.useSnackbarOfContext(
            context, AppLocalizations.of(context).sorryErrorOccurred);
      },
    );
  }
}
