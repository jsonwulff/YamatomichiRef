import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

/// A utility class to open various OS apps like mail, files etc.
class OpenApp {
  /// A utility method that open the default mail app
  /// 
  /// # Summary
  /// Opens the default mail app and if an error is encountered a message is
  /// shown in the snackbar telling that the operation was unsuccessful
  static void openEmailAppViaPlatform(
      BuildContext context, AppLocalizations texts) {
    try {
      if (Platform.isAndroid) {
        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
        );
        intent.launch();
      } else if (Platform.isIOS) {
        launch("message://");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(texts.couldNotOpenApp),
      ));
    }
  }
}
