import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/packlist_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/calendar/components/event_img_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'components/packlist_controllers.dart';

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
  UserProfile createdBy;

  PacklistService packlistService = PacklistService();
  Packlist packlist;
  PacklistNotifier packlistNotifier = PacklistNotifier();

  AppLocalizations texts;

  Stream stream;

  @override
  void initState() {
    super.initState();
    //Setup user
    if (userProfile == null) {
      userProfileNotifier =
          Provider.of<UserProfileNotifier>(context, listen: false);
      if (userProfileNotifier.userProfile == null) {
        var tempUser = context.read<AuthenticationService>().user;
        if (tempUser != null) {
          String userUid = context.read<AuthenticationService>().user.uid;
          userProfileService.getUserProfileAsNotifier(
              userUid, userProfileNotifier);
        }
      }
    }
    userProfile =
        Provider.of<UserProfileNotifier>(context, listen: false).userProfile;
    userProfileService.isAdmin(userProfile.id, userProfileNotifier);
    setup();
  }

  Future<void> setup() async {
    print('setup');
    //Setup packlist
    updatePacklistInNotifier();
    //Setup createdByUser
    if (packlist.createdBy == null) {
      createdBy = userProfileService.getUnknownUser();
    } else {
      createdBy = await userProfileService.getUserProfile(packlist.createdBy);
    }

    setState(() {});
  }

  updatePacklistInNotifier() {
    packlistNotifier = Provider.of<PacklistNotifier>(context, listen: false);
    packlist = packlistNotifier.packlist;
  }

  highlightButtonAction(Packlist packlist) async {
    print('highlight button action');
    if (await packlistService.highlightPacklist(packlist, packlistNotifier)) {
      setup();
    }
  }

  highlightIcon(Packlist packlist) {
    if (packlist.endorsedHighlighted)
      return Icon(Icons.star, color: Colors.black);
    else
      return Icon(Icons.star_outline, color: Colors.black);
  }

  Widget buildHighlightButton(Packlist packlist) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: GestureDetector(
          onTap: () {
            highlightButtonAction(packlist);
          },
          child: highlightIcon(packlist),
        ));
  }

  Widget buildEditButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: GestureDetector(
          //heroTag: 'btn1',
          onTap: () {
            Navigator.pushNamed(context, '/createPacklist');
          },
          child: Icon(Icons.mode_outlined, color: Colors.black),
        ));
  }

  deleteButtonAction(Packlist packlist) async {
    print('delete button action');
    if (await simpleChoiceDialog(
        context, 'Are you sure you want to delete this packlist?')) {
      Navigator.pop(context);
      packlistNotifier.remove();
      PacklistControllers.dispose();
      await packlistService.deletePacklist(packlist);
    }
  }

  Widget buildDeleteButton(Packlist packlist) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
        child: GestureDetector(
            //heroTag: 'btn2',
            onTap: () {
              print('delete button pressed');
              deleteButtonAction(packlist);
            },
            child: Icon(Icons.delete_outline_rounded, color: Colors.black)));
  }

  Widget buildButtons(Packlist packlist) {
    if (userProfile.id == packlist.createdBy && userProfile.roles != null) {
      if (userProfile.roles['administrator']) {
        return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          buildEditButton(),
          buildHighlightButton(packlist),
          buildDeleteButton(packlist)
        ]);
      }
    }
    if (userProfile.id == packlist.createdBy) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildDeleteButton(packlist)]);
    }
    if (userProfile.roles != null) {
      if (userProfile.roles['administrator']) {
        return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          buildHighlightButton(packlist),
          buildDeleteButton(packlist)
        ]);
      }
    }

    return Container();
  }

  Widget buildPacklistPicture() {
    // TODO MAIN IMAGE MIGHT GIVE PROBLEM
    return Visibility(
      visible: packlist.imageUrl == null ? false : true,
      replacement: Container(height: 230),
      child: Container(
        child: EventCarousel(
          images: packlist.imageUrl == null ? [] : packlist.imageUrl.toList(),
          mainImage:
              'https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg',

          /*mainImage: packlist.mainImage == null ? null : packlist.mainImage,
              images:
                  packlist.imageUrl == null ? [] : packlist.imageUrl.toList(),*/
        ),
      ),
    );

    // return Container(
    //   child: EventCarousel(
    //     images: packlist.imageUrl == null ? [] : packlist.imageUrl,
    //     mainImage: "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg",
    //   ),
    // );
  }

  Widget buildUserInfo(Packlist packlist) {
    Widget image;
    if (createdBy != null && createdBy.imageUrl != null) {
      image = Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(createdBy.imageUrl), fit: BoxFit.fill),
        ),
      );
    } else {
      image = Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      );
    }
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            Padding(
                key: Key('userName'),
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Text(
                      '${createdBy.firstName} ${createdBy.lastName}',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(81, 81, 81, 1)),
                    ))),
          ],
        ));
  }
  /*
      Widget buildUserInfo(Packlist packlist) {
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
                  'Jon Snow (STATIC)',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(81, 81, 81, 1)),
                )),
          ],
        ));
  }*/

  Widget packlistTitle() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Text(
          packlist.title,
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
                        packlist.totalWeight.toString(),
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
                        packlist.totalAmount.toString(),
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
                        packlist.amountOfDays,
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
                        packlist.season,
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ])),
              ],
            )),
        divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Description', // TODO : make translation
              style: Theme.of(context).textTheme.headline3,
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
              packlist.description,
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
          child: Text('Comments are turned off for this event'))
    ]);

    return Container(
      child: widget,
    );
  }

  /* ## the part between picture and tab bar ## */
  Widget buildTitleColumn(Packlist packlist) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: buildUserInfo(packlist),
        ),
      ],
    );
  }

  Widget sliverAppBar() {
    return Container(
      //height: 550,
      child: Column(
        children: [
          buildPacklistPicture(),
          buildTitleColumn(packlist),
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
