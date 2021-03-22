import 'package:app/routes/routes.dart';
import 'package:app/ui/components/global/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          child: Center(
                              child:
                                  Icon(Icons.backpack_outlined, size: 100.0))),
                      Container(
                          color: Colors.blue,
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('GEAR REVIEWS', textScaleFactor: 2.0, textAlign: TextAlign.left,),
                            ],
                          )),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          child: Center(
                              child:
                                  Icon(Icons.backpack_outlined, size: 100.0))),
                      Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('PACKLISTS', textScaleFactor: 2.0, textAlign: TextAlign.left),
                            ],
                          )),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: Colors.blue,
                          child: Center(
                              child:
                                  Icon(Icons.backpack_outlined, size: 100.0))),
                      Container(
                        color: Colors.blue,
                          margin: EdgeInsets.all(10.0),
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
