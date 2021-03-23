import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO : Localizations for gear reviews, packlists, hacks
// TODO : set the overflow of the Textwidgets, to make sure it fits when translating
// TODO : use the correct grey color (the one from yamatomichi.com)
// TODO : widget test

class GroupsView extends StatefulWidget {
  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.groups),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: Text('dummy'),
          )),
    );
  }
}
