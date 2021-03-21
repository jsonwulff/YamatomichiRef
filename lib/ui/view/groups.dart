import 'package:app/ui/components/global/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

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
        title: Text('Groups'),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
