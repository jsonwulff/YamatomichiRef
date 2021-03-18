import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/email_verification.dart';
import 'package:app/ui/util/open_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'package:provider/provider.dart';


/// TODO
Future<Widget> generateNonVerifiedEmailAlert(BuildContext context, {User user}) async {
  return showDialog(
    // FirebaseAuth firebaseAuth = context.read<AuthenticationService>().firebaseAuth;
      context: context,
      builder: (BuildContext context) {
        FirebaseAuth _firebaseAuth = context.read<AuthenticationService>().firebaseAuth;
        final EmailVerification _emailVerification =
            EmailVerification(_firebaseAuth);
        if (user == null) user = _firebaseAuth.currentUser;
        var texts = AppLocalizations.of(context);

        return AlertDialog(
          key: Key('EmailNotVerifiedAlertDialog'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(texts.emailNotVerified + ': ${user.email}', key: Key('NotVerifiedEmail_MailHasBeenSend'),),
                Text(texts.resendVerificationEmail, key: Key('NotVerifiedEmail_ResendMailText'),),
                ElevatedButton(
                  onPressed: () {
                    _emailVerification.sendVerificationEmail(user: user);
                  },
                  child: Text(texts.resendEmailButton),
                  key: Key('NotVerifiedEmail_ResendMailButton'),
                ),
                Text(texts.openEmailApp, key: Key('NotVerifiedEmail_OpenMailAppText'),),
                ElevatedButton(
                  onPressed: () {
                    OpenApp.openEmailAppViaPlatform(
                        context, AppLocalizations.of(context));
                  },
                  child: Text(texts.openEmailAppButton),
                  key: Key('NotVerifiedEmail_OpenMailAppButton'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(texts.close),
              key: Key('NotVerifiedEmail_CloseButton'),
            ),
          ],
        );
      });
}
