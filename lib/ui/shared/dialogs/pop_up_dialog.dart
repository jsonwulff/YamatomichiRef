import 'package:app/assets/theme/theme_data_custom.dart';
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
          titleTextStyle: ThemeDataCustom.getThemeData().textTheme.headline1,
          children: <Widget>[
            new SimpleDialogOption(
              key: Key('yes'),
              child: new Text(texts.yes, style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            new SimpleDialogOption(
              key: Key('no'),
              child: new Text(texts.no, style: TextStyle(fontSize: 20)),
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
