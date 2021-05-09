import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/snackbar/snackbar_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class DynamicLinkService {
  static ActionCodeSettings generateResetPasswordCode(String email) {
    return ActionCodeSettings(
      // url: 'https://yamatomichi.page.link.com/password-reset?email=${email}',
      url: 'https://yamatomichi.page.link.com/?email=${email}',
      dynamicLinkDomain: "yamatomichi.page.link",
      androidPackageName: "com.yamatomichi.app",
      // TODO:Lukas: handle iOS
      // iOS: {"bundleId": "com.example.ios"},
      handleCodeInApp: true,
    );
  }

  static void initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        FirebaseAuth auth = FirebaseAuth.instance;

        var actionCode = deepLink.queryParameters['oobCode'];
        var emailInLink = deepLink.queryParameters['email'];

        print(
          //emailInLink +
          '''
        
        
        
        
        
        
        
        HERE
        
        
        
        
        '''
        
        
        
        
        
        // + emailInLink);
        + actionCode);

        try {
          await auth.checkActionCode(actionCode);
          await auth.applyActionCode(actionCode);

          auth.currentUser.reload();

          if (deepLink != null) {
            Navigator.pushNamed(context, changePasswordRoute);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-action-code') {
            SnackBarCustom.useSnackbarOfContext(context,
                e.toString()); //AppLocalizations.of(context).sorryErrorOccurred);
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        SnackBarCustom.useSnackbarOfContext(context,
            e.toString()); //AppLocalizations.of(context).sorryErrorOccurred);
      },
    );
  }
}
