import 'package:app/ui/views/packlist/components/create_packlist_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class CreatePacklistView extends StatefulWidget {
  CreatePacklistView({Key key}) : super(key: key);

  @override
  _CreatePacklistViewState createState() => _CreatePacklistViewState();
}

// TODO This seems to never get used. Should be deleted
class _CreatePacklistViewState extends State<CreatePacklistView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0,
          title: Text(
            texts.createPacklist,
            style: TextStyle(color: Colors.black),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: CreatePacklistStepperView(),
    );
  }
}
