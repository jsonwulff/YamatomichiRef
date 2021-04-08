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
      DropdownMenuItem(value: "ja", child: Text("Japanese")),
      DropdownMenuItem(value: "da", child: Text("Danish")),
      DropdownMenuItem(value: "en", child: Text("English"))
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
            DropdownButton(
              hint: Text("Choose language"),
              //value: appLanguage.appLocal.languageCode,
              onChanged: (String value) {
                print('Set state called with' + value);
                MyApp.of(context).setLocale(Locale(value));
              },
              items: languageList,
            )
          ],
        )));
  }
}
