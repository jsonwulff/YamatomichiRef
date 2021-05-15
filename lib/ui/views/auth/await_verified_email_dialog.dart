import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/email_verification.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/utils/open_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'package:provider/provider.dart';

/// Opens a popup showing various opens for users of how to verify their email
///
/// If a [user] isn't provided the method will look in FirebaseAuth for the
/// current user
Future<Widget> generateNonVerifiedEmailAlert(BuildContext context, {User user}) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      FirebaseAuth _firebaseAuth = context.read<AuthenticationService>().firebaseAuth;
      final EmailVerification _emailVerification = EmailVerification(_firebaseAuth);
      if (user == null) user = _firebaseAuth.currentUser;
      var texts = AppLocalizations.of(context);

      return AlertDialog(
        key: Key('EmailNotVerifiedAlertDialog'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                texts.emailNotVerified + ': ${user.email}',
                key: Key('NotVerifiedEmail_MailHasBeenSend'),
              ),
              Text(
                texts.resendVerificationEmail,
                key: Key('NotVerifiedEmail_ResendMailText'),
              ),
              SizedBox(
                height: 20,
              ),
              Button(
                onPressed: () {
                  _emailVerification.sendVerificationEmail(user: user);
                },
                label: texts.resendEmailButton,
                key: Key('NotVerifiedEmail_ResendMailButton'),
              ),
              Button(
                onPressed: () {
                  OpenApp.openEmailAppViaPlatform(context, AppLocalizations.of(context));
                },
                label: texts.openEmailAppButton,
                key: Key('NotVerifiedEmail_OpenMailAppButton'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, signInRoute, (Route<dynamic> route) => false);
            },
            child: Text(texts.close),
            key: Key('NotVerifiedEmail_CloseButton'),
          ),
        ],
      );
    },
  );
}
