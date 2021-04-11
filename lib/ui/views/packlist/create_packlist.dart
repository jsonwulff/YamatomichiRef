import 'package:app/middleware/models/event.dart';
import 'package:app/ui/views/packlist/components/create_packlist_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class CreatePacklistView extends StatefulWidget {
  CreatePacklistView({Key key}) : super(key: key);

  @override
  _CreatePacklistViewState createState() => _CreatePacklistViewState();
}

class _CreatePacklistViewState extends State<CreatePacklistView> {
  Event event; // TODO SHOULD BE PACKLIST
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Create packlist', style: TextStyle(color: Colors.black),), // TODO SHOULD BE CREATE NEW PACKLIST
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: StepperDemo(),
    );
  }
}
