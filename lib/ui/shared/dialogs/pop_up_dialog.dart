import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

Future<bool> simpleChoiceDialog(BuildContext context, String question) async {
  var texts = AppLocalizations.of(context);

  if (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text(question),
          children: <Widget>[
            new SimpleDialogOption(
              key: Key('yes'),
              child: new Text(texts.yes),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            new SimpleDialogOption(
              key: Key('no'),
              child: new Text(texts.no),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          ],
        );
      })) {
    return true;
  } else {
    return false;
  }
}
