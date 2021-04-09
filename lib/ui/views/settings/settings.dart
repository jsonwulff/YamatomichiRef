import 'package:android_intent/flag.dart';
import 'package:app/assets/fonts/app_icons.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    var languageList = [
      DropdownMenuItem(
        value: "ja",
        child: Row(
          children: [
            Icon(Icons.flag),
            Text(
              "Japanese",
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "en",
        child: Row(
          children: [
            Icon(Icons.flag),
            Text(
              "English",
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "da",
        child: Row(
          children: [
            Icon(Icons.flag),
            Text(
              "Danish",
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        key: Key('Settings_AppBar'),
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(texts.settings),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButton(
                hint: Text(texts.chooseLanguage),
                //value: appLanguage.appLocal.languageCode,
                onChanged: (String value) {
                  print('Set state called with' + value);
                  MyApp.of(context).setLocale(Locale(value));
                },
                items: languageList,
                underline: SizedBox(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
