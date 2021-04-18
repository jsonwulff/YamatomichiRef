import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PacklistPageView extends StatefulWidget {
  PacklistPageView(
      {Key key, this.title, this.userProfileNotifier, this.userProfileService})
      : super(key: key);

  final String title;
  final UserProfileNotifier userProfileNotifier;
  final UserProfileService userProfileService;

  @override
  _PacklistPageViewState createState() => _PacklistPageViewState();
}

class _PacklistPageViewState extends State<PacklistPageView> {
  UserProfileService userProfileService = UserProfileService();
  UserProfile userProfile;
  UserProfileNotifier userProfileNotifier;
  AppLocalizations texts;

  Widget buildPacklistPicture(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey,
            image: DecorationImage(
                image: NetworkImage(
                    "https://media-exp1.licdn.com/dms/image/C4D1BAQHTTXqGSiygtw/company-background_10000/0/1550684469280?e=2159024400&v=beta&t=MjXC23zEDVy8zUXSMWXlXwcaeLxDu6Gt-hrm8Tz1zUE"),
                fit: BoxFit.cover),
          )),
    );
  }

  Widget buildUserInfo(/*Packlist packlist*/) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              key: Key('userPicture'),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
            Padding(
                key: Key('userName'),
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'Jon Snow',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(81, 81, 81, 1)),
                )),
          ],
        ));
  }

  Widget packlistTitle() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Text(
          "Packlist title",
          //packlist.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(81, 81, 81, 1)),
        ),
      ),
    );
  }

  Widget buildInfoColumn(/*Packlist packlist*/) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.line_weight,
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        "Weight"
                        /*'${packlist.weight} '*/,
                        /*key: Key('packlistweight'),*/
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ])),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.backpack_outlined,
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        "Items in total"
                        /*'${packlist.items} '*/,
                        /*key: Key('packlistitems'),*/
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ])),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.event,
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        "Amount of days"
                        /*'${packlist.days} '*/,
                        /*key: Key('packlistdays'),*/
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ])),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.cloud_done_outlined, // TODO CHANGE ICON
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        "Season"
                        /*'${packlist.season} '*/,
                        /*key: Key('packlistseason'),*/
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ])),
              ],
            )),
        divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.headline3,
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo ",
              //key: Key('eventDescription'),
              style: TextStyle(
                  color: Color.fromRGBO(119, 119, 119, 1), height: 1.8)),
        ),
      ],
    );
  }

  Widget divider() {
    return Divider(
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Color.fromRGBO(220, 221, 223, 1),
    );
  }

  Widget overviewTab() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      packlistTitle(),
      divider(),
      buildInfoColumn(),
    ]));
  }

  Widget itemsTab() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        packlistTitle(),
        divider(),
      ],
    ));
  }

  Widget commentTab() {
    var widget;
    widget = Column(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text('Comments are turned of for this event'))
    ]);

    return Container(
      child: widget,
    );
  }

  /* ## the part between picture and tab bar ## */
  Widget buildTitleColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: buildUserInfo(),
        ),
      ],
    );
  }

  Widget sliverAppBar() {
    return Container(
      //height: 550,
      child: Column(
        children: [
          buildPacklistPicture(
              "https://media-exp1.licdn.com/dms/image/C4D1BAQHTTXqGSiygtw/company-background_10000/0/1550684469280?e=2159024400&v=beta&t=MjXC23zEDVy8zUXSMWXlXwcaeLxDu6Gt-hrm8Tz1zUE"),
          buildTitleColumn(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "PACKLIST",
          style: TextStyle(color: Colors.black),
        ),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // gives exceptiom of multiple heroes
          },
        ),
      ),
      body: Container(
        child: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    floating: true,
                    pinned: true,
                    snap: true,
                    leading: Container(), // hiding the backbutton
                    bottom: PreferredSize(
                      preferredSize: Size(double.infinity, 50.0),
                      child: TabBar(
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        labelStyle: Theme.of(context).textTheme.headline3,
                        tabs: [
                          Tab(text: 'Overview'),
                          Tab(text: 'Items'),
                          Tab(text: 'Comments'),
                        ],
                      ),
                    ),
                    expandedHeight: 360,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: sliverAppBar(),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  overviewTab(),
                  itemsTab(),
                  commentTab(),
                ],
              ),
            )),
      ),
    );
  }
}
