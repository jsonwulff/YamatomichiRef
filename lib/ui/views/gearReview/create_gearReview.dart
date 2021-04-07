import 'package:app/models/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gearReview_controllers.dart'; // Use localization

class CreateGearReviewView extends StatefulWidget {
  CreateGearReviewView({Key key}) : super(key: key);

  @override
  _GearReviewViewState createState() => _GearReviewViewState();
}

class _GearReviewViewState extends State<CreateGearReviewView> {
  Review review;
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(texts.createdBy), // TODO SHOULD BE CREATE NEW GEARREVIEW
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              GearReviewControllers.updated = false;
            },
          )),
      body: CreateGearReviewView(), // NEEDS TO BE A GEAR REVIEW STEPPER
    );
  }
}
