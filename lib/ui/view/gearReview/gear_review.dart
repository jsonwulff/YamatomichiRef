import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class GearReviewView extends StatefulWidget {
  GearReviewView({Key key}) : super(key: key);

  @override
  _GearReviewState createState() => _GearReviewState();
}

class _GearReviewState extends State<GearReviewView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(texts.gearReview),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: null,
        ));
  }
}
