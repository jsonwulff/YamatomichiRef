import 'package:app/ui/components/global/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class GearView extends StatefulWidget {
  @override
  _GearViewState createState() => _GearViewState();
}

class _GearViewState extends State<GearView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.gear),
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
