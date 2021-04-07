import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// TODO : dummy implementation for now - only place in app where you can log out at the moment

class GroupsView extends StatefulWidget {
  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarCustom.basicAppBarWithContext(texts.groups, context),
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: Button(
                onPressed: () async {
                  if (await context.read<AuthenticationService>().signOut(context)) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, signInRoute, (Route<dynamic> route) => false);
                  }
                },
                label: texts.signOut),
          )),
    );
  }
}
