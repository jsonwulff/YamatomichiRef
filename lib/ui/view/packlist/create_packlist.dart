import 'package:app/models/event.dart';
import 'package:app/ui/components/calendar/create_event_stepper.dart';
import 'package:app/ui/components/calendar/event_controllers.dart';
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
          title: Text(texts.createdBy), // TODO SHOULD BE CREATE NEW PACKLIST
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              EventControllers.updated =
                  false; // TODO SHOULD BE PACKLISTCONTROLLER
            },
          )),
      body: StepperWidget(),
    );
  }
}
