import 'package:app/ui/components/global/bottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'package:app/routes/routes.dart';
import 'package:provider/provider.dart';

class GearView extends StatefulWidget {
  @override
  _GearViewState createState() => _GearViewState();
}

class _GearViewState extends State<GearView> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.gear),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
