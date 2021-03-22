import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 



// TODO : Localizations for gear reviews, packlists, hacks
// TODO : extract a method that returns an Expanded widget instead of this redundant piece of garbage
// TODO : set the overflow of the Textwidgets, to make sure it fits when translating  


class GroupsView extends StatefulWidget {
  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.groups),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, supportRoute);
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 25.0),
                        child: Icon(Icons.backpack_outlined, size: 100.0)),
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text('GEAR REVIEWS', textScaleFactor: 2.0, textAlign: TextAlign.left)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, supportRoute);
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 25.0),
                        child: Icon(Icons.backpack_outlined, size: 100.0)),
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text('PACKLISTS', textScaleFactor: 2.0, textAlign: TextAlign.left)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, supportRoute);
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 25.0),
                        child: Icon(Icons.backpack_outlined, size: 100.0)),
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text('HACKS', textScaleFactor: 2.0, textAlign: TextAlign.left)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
