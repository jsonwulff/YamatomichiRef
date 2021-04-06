import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class PacklistView extends StatefulWidget {
  PacklistView({Key key}) : super(key: key);

  @override
  _PacklistState createState() => _PacklistState();
}

class _PacklistState extends State<PacklistView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(texts.packLists),
        backgroundColor: Colors.black,
        /*bottom: TabBar( TODO Implement tabbar

        )*/
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: [
              buildPacklistItem(context),
              buildPacklistItem(context),
              buildPacklistItem(context),
              buildPacklistItem(context),
            ],
          ),
        ),

        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createPacklist');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Colorway for the tag should be defined by the tag name
  Chip buildHikeTypeTag(BuildContext context) {
    return Chip(
      backgroundColor: Colors.blue,
      label: Text('Snow hike'),
    );
  }

  Expanded buildPacklistItem(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        height: 220.0,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, supportRoute); // Navigate to packlist
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                width: 175.0,
                height: 175.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://images.squarespace-cdn.com/content/v1/5447ce79e4b04184cfa2c66b/1510510844786-D30FRFBSALN1QE3SWIV6/ke17ZwdGBToddI8pDm48kJUlZr2Ql5GtSKWrQpjur5t7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z5QPOohDIaIeljMHgDF5CVlOqpeNLcJ80NK65_fV7S1UfNdxJhjhuaNor070w_QAc94zjGLGXCa1tSmDVMXf8RUVhMJRmnnhuU1v2M8fLFyJw/BIKEPACKING-GEAR-LIST-PACK-LIST-SCANDINAVIA-GUSTAV-THUESEN-1.jpg"))),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title by user given here",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25.0)),
                      Chip(
                        backgroundColor: Colors.transparent,
                        avatar: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
                        ),
                        label:
                            Text('Jon Snow', overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        'Weight: 12 kg',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '3 Days',
                        textAlign: TextAlign.left,
                      ),
                      buildHikeTypeTag(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
