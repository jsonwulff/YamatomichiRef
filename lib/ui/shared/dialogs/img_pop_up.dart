import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<String> imgChoiceDialog(dynamic url, {BuildContext context, bool isPacklist}) async {
  String answer = 'skip'; //addshit
  if (isPacklist == null) {
    isPacklist = false;
  }
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          //title: new Text(question),
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Container(
                    height: 300,
                    width: 300,
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: url is String ? NetworkImage(url) : FileImage(url),
                          fit: BoxFit.cover),
                      //NetworkImage(url), fit: BoxFit.cover),
                    ))),
            Column(
              children: [
                new SimpleDialogOption(
                  //key: Key('yes'),
                  child: new Text(context != null
                      ? isPacklist
                          ? AppLocalizations.of(context).removeFromPacklist
                          : AppLocalizations.of(context).removeFromEvent
                      : 'Removed from event'),
                  onPressed: () {
                    answer = 'remove';
                    Navigator.pop(context, true);
                  },
                ),
                new SimpleDialogOption(
                  //key: Key('yes'),
                  child: new Text(context != null
                      ? AppLocalizations.of(context).setImageAsMainPicture
                      : 'Set image as main picture'),
                  onPressed: () {
                    answer = 'main';
                    Navigator.pop(context, true);
                  },
                ),
              ],
            )
          ],
        );
      });
  return answer;
}

Future<String> imgDeleteChoiceDialog(BuildContext context, var url) async {
  String answer = 'skip';
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          //title: new Text(question),
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(image: FileImage(url), fit: BoxFit.cover),
                      //NetworkImage(url), fit: BoxFit.cover),
                    ))),
            Column(children: [
              new SimpleDialogOption(
                //key: Key('yes'),
                child: new Text('Remove from event'),
                onPressed: () {
                  answer = 'remove';
                  Navigator.pop(context, true);
                },
              ),
            ])
          ],
        );
      });
  return answer;
}
