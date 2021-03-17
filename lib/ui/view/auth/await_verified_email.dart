import 'package:app/middleware/firebase/email_verification.dart';
import 'package:app/ui/helpers/open_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class AwaitVerifiedEmailView extends StatefulWidget {
  @override
  _AwaitVerifiedEmailViewState createState() => _AwaitVerifiedEmailViewState();
}

class _AwaitVerifiedEmailViewState extends State<AwaitVerifiedEmailView> {
  @override
  Widget build(BuildContext context) {
    final EmailVerification _emailVerification =
        EmailVerification(FirebaseAuth.instance);
    var user = FirebaseAuth.instance.currentUser;
    var texts = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(texts.emailNotVerified + ': ${user.email}'),
            Text(texts.resendVerificationEmail),
            ElevatedButton(
              onPressed: () {
                _emailVerification.sendVerificationEmail(user: user);
              },
              child: Text(texts.resendEmailButton),
            ),
            Text(texts.openEmailApp),
            ElevatedButton(
              onPressed: () {
                OpenApp.openEmailAppViaPlatform(context, AppLocalizations.of(context));
              },
              child: Text(texts.openEmailAppButton),
            ),
          ],
        ),
      ),
    );
  }
}
