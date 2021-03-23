import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'package:app/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

// TODO : Localizations for gear reviews, packlists, hacks
// TODO : set the overflow of the Textwidgets, to make sure it fits when translating
// TODO : widget test

class GearView extends StatefulWidget {
  @override
  _GearViewState createState() => _GearViewState();
}

class _GearViewState extends State<GearView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.gear),
      ),
      body: SafeArea(
        // minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildExpanded(
                context,
                texts.gearReview,
                Icon(
                  Icons.backpack_outlined,
                  size: 100.0,
                )),
            buildExpanded(context, texts.packLists,
                Icon(Icons.account_tree_outlined, size: 100.0)),
            buildExpanded(context, texts.hacks,
                Icon(Icons.architecture_outlined, size: 100.0)),
          ],
        ),
      ),
    );
  }

  Expanded buildExpanded(BuildContext context, String category, Icon icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, supportRoute);
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          color: Color.fromARGB(100, 179, 212, 252),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(margin: EdgeInsets.only(left: 25.0), child: icon),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(category,
                      textScaleFactor: 2.0, textAlign: TextAlign.left)),
            ],
          ),
        ),
      ),
    );
  }
}
