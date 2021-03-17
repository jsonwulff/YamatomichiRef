import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class AwaitVerifiedEmailView extends StatefulWidget {
  @override
  _AwaitVerifiedEmailViewState createState() => _AwaitVerifiedEmailViewState();
}

class _AwaitVerifiedEmailViewState extends State<AwaitVerifiedEmailView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(texts.emailNotVerified),
          Text('mail'),
          // ElevatedButton(onPressed: () {

          // }, child: Text('Open Email'))
        ],
      ),),
    );
  }
}