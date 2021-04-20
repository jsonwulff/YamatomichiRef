import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarCustom.basicAppBar(texts.editProfile, context),
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
