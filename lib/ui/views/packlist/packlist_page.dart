import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/firebase/packlist_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/calendar/components/comment_widget.dart';
import 'package:app/ui/views/calendar/components/event_img_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'components/packlist_controllers.dart';

class PacklistPageView extends StatefulWidget {
  PacklistPageView({Key key, this.title, this.userProfileNotifier, this.userProfileService})
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

  TextStyle style =
      TextStyle(color: Color(0xff424242), fontWeight: FontWeight.normal, fontSize: 14.0);

  Stream stream;

  List<String> expandedListTitles = [
    'Carrying',
    'Sleeping gear',
    'Food and cooking equipment',
    'Clothes packed',
    'Clothes worn',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    //Setup user
    if (userProfile == null) {
      userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
      if (userProfileNotifier.userProfile == null) {
        var tempUser = context.read<AuthenticationService>().user;
        if (tempUser != null) {
          String userUid = context.read<AuthenticationService>().user.uid;
          userProfileService.getUserProfileAsNotifier(userUid, userProfileNotifier);
        }
      }
    }
    userProfile = Provider.of<UserProfileNotifier>(context, listen: false).userProfile;
    userProfileService.checkRoles(userProfile.id, userProfileNotifier);
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
    if (packlist.endorsed)
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
    if (await simpleChoiceDialog(context, 'Are you sure you want to delete this packlist?')) {
      Navigator.pop(context);
      packlistNotifier.remove();
      PacklistControllers.dispose();
      await packlistService.deletePacklist(packlist);
    }
  }

  addToFavouritesAction(Packlist packlist) async {
    await packlistService.addTofavoritePacklist(userProfile, packlist);
  }

  Widget buildAddToFavourites(Packlist packlist) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
        child: GestureDetector(
            //heroTag: 'btn2',
            onTap: () {
              print('add to favourites pressed in packlist');
              addToFavouritesAction(packlist);
            },
            child: Icon(Icons.favorite_border_outlined, color: Colors.black)));
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
    if (userProfile.id == packlist.createdBy &&
        (userProfile.roles['ambassador'] || userProfile.roles['yamatomichi'])) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        buildEditButton(),
        buildHighlightButton(packlist),
        buildDeleteButton(packlist)
      ]);
    }
    if (userProfile.id == packlist.createdBy) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildDeleteButton(packlist)]);
    }
    if (userProfile.roles['ambassador'] || userProfile.roles['yamatomichi']) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildHighlightButton(packlist),
          buildDeleteButton(packlist),
          buildAddToFavourites(packlist)
        ],
      );
    }
    if (userProfile.id != packlist.createdBy) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end, children: [buildAddToFavourites(packlist)]);
    }

    return Container();
  }

  Widget buildPacklistPicture() {
    return Visibility(
      visible: packlist.imageUrl == null ? false : true,
      replacement: Container(height: 230),
      child: Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: EventCarousel(
          images: packlist.imageUrl == null ? [] : packlist.imageUrl.toList(),
          // mainImage:
          //     'https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg',
        ),
      ),
    );
  }

  Widget buildUserInfo(Packlist packlist) {
    Widget image;
    if (createdBy != null && createdBy.imageUrl != null) {
      image = Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(createdBy.imageUrl), fit: BoxFit.fill),
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
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Text(
                      '${createdBy.firstName} ${createdBy.lastName}',
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 20, color: Color.fromRGBO(81, 81, 81, 1)),
                    ))),
          ],
        ));
  }

  Widget packlistTitle() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Text(
          packlist.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromRGBO(81, 81, 81, 1)),
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
                    child: Icon(Icons.fitness_center, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        packlist.totalWeight.toString() + 'g in total',
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
                    child: Icon(Icons.backpack_outlined, //grass_sharp
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        packlist.totalAmount.toString() + ' items in total',
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
                    child:
                        Icon(Icons.calendar_today_rounded, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        packlist.amountOfDays + ' days',
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
                    child: Icon(Icons.eco_rounded, // TODO CHANGE ICON
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
          child: Text(packlist.description,
              style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1), height: 1.8)),
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

  List<Widget> getExpandedList() {
    return List.generate(expandedListTitles.length, (index) {
      return Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Theme(
            data: ThemeData()
                .copyWith(dividerColor: Colors.transparent, accentColor: Color(0xff424242)),
            child: ExpansionTile(
              title: Text(expandedListTitles[index],
                  style: TextStyle(
                      color: Color(0xff424242), fontWeight: FontWeight.w600, fontSize: 20.0)),
              children: [itemElement(), itemElement(), totalWeightRow(index)],
            ),
          ),
        ),
        divider()
      ]);
    });
  }

  Widget itemElement() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                children: [
                  Row(children: [
                    Text(
                      'Backpack item name',
                      style: style,
                    )
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('unknown', style: style), Text('1x650g', style: style)],
                  )
                ],
              ))),
    );
  }

  Widget totalWeightRow(int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${expandedListTitles[index]} total weight',
            style: style,
          ),
          Text('1100g')
        ],
      ),
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
      ]..addAll(getExpandedList()),
    ));
  }

  Widget commentTab() {
    var widget;
    if (packlist.allowComments)
      widget = CommentWidget(
        documentRef: packlist.id,
        collection: DBCollection.Packlist,
      );
    else
      widget = Column(children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Text('Comments are turned off for this packlist'))
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
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "PACKLIST", //TODO add and trans
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
        actions: [buildButtons(packlist)],
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
                          Tab(text: 'Overview'), //TODO add and trans
                          Tab(text: 'Items'), //TODO add and trans
                          Tab(text: 'Comments'), //TODO add and trans
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
