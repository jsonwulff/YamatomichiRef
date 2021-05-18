import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/firebase/packlist_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';

import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/shared/comment/comment_widget.dart';
import 'package:app/ui/views/calendar/components/event_img_carousel.dart';
import 'package:app/ui/shared/components/mini_avatar.dart';

import 'package:app/ui/views/personalProfile/personal_profile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/create_packlist_stepper.dart';
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

  bool isFavorite = false;

  TextStyle style =
      TextStyle(color: Color(0xff545871), fontWeight: FontWeight.normal, fontSize: 14.0);

  TextStyle urlStyle =
      TextStyle(color: Color(0xFF0085EE), fontWeight: FontWeight.normal, fontSize: 14.0);

  Stream stream;

  List<Tuple2<String, String>> itemCategories = [];

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

    updatePacklistInNotifier();

    if (userProfile.favoritePacklists != null &&
        userProfile.favoritePacklists.contains(packlist.id)) {
      isFavorite = true;
    }

    setState(() {});
  }

  Future<UserProfile> setup() async {
    //Setup createdByUser
    if (packlist.createdBy == null) {
      createdBy = userProfileService.getUnknownUser();
    } else {
      createdBy = await userProfileService.getUserProfile(packlist.createdBy);
    }

    // setState(() {});
    return createdBy;
  }

  updatePacklistInNotifier() {
    packlistNotifier = Provider.of<PacklistNotifier>(context, listen: false);
    packlist = packlistNotifier.packlist;
  }

  Widget buildEditButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: GestureDetector(
          //heroTag: 'btn1',
          onTap: () {
            pushNewScreen(context, screen: CreatePacklistStepperView(), withNavBar: false);
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
    await packlistService.addTofavoritePacklist(userProfile, packlist).whenComplete(() {
      isFavorite = true;
      setState(() {});
    });
  }

  removeFromFavoritesAction(Packlist packlist) async {
    await packlistService.removeFromFavoritePacklist(userProfile, packlist).whenComplete(() {
      isFavorite = false;
      setState(() {});
    });
  }

  Widget buildAddToFavourites(Packlist packlist) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
      child: GestureDetector(
        onTap: isFavorite
            ? () => removeFromFavoritesAction(packlist)
            : () => addToFavouritesAction(packlist),
        child: isFavorite
            ? Icon(Icons.favorite, color: Colors.black)
            : Icon(Icons.favorite_border_outlined, color: Colors.black),
      ),
    );
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
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildDeleteButton(packlist)]);
    }
    if (userProfile.id == packlist.createdBy) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildDeleteButton(packlist)]);
    }
    if (userProfile.roles['ambassador'] || userProfile.roles['yamatomichi']) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [buildDeleteButton(packlist), buildAddToFavourites(packlist)],
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
      visible: packlist.imageUrl.isEmpty && packlist.mainImage == null ? false : true,
      replacement: Container(
        margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('lib/assets/images/logo_eventwidget.png')),
        ),
        height: 230.0,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: EventCarousel(
          images: packlist.imageUrl.isEmpty ? [] : packlist.imageUrl.toList(),
          mainImage: packlist.mainImage,
        ),
      ),
    );
  }

  Widget getUserAvatar() {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: PersonalProfileView(userID: createdBy.id),
          withNavBar: false,
        );
      },
      child: MiniAvatar(user: createdBy),
    );
  }

  Widget buildUserInfo(Packlist packlist) {
    return FutureBuilder(
      future: setup(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getUserAvatar(),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '${snapshot.data.firstName} ${snapshot.data.lastName}',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(fontSize: 20, color: Color.fromRGBO(81, 81, 81, 1)),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
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

  Widget buildInfoColumn() {
    var texts = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        packlist.private
            ? Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.remove_red_eye_outlined,
                            color: Color.fromRGBO(81, 81, 81, 1))),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Text(
                            texts.privatePacklist,
                            style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                          ),
                        ])),
                  ],
                ))
            : Container(),
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
                        packlist.totalWeight.toString() + 'g ' + texts.inTotal,
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
                        packlist.totalAmount.toString() + ' ' + texts.items + ' ' + texts.inTotal,
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
                        packlist.amountOfDays + ' ' + texts.days,
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
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.label_outline, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        packlist.tag,
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ])),
              ],
            )),
        divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              texts.description, //'Description', // TODO : make translation
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

  buildGearItems() {
    return FutureBuilder(
      future: packlistService.getAllGearItems(packlist, itemCategories),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Theme(
                      data: ThemeData().copyWith(
                          dividerColor: Colors.transparent, accentColor: Color(0xff545871)),
                      child: ExpansionTile(
                        title: Text(snapshot.data[index].item1,
                            style: TextStyle(
                                color: Color(0xff545871),
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0)),
                        children: [
                          ...buildItemsForCategory(snapshot.data[index].item3),
                          totalWeightRow(snapshot.data[index].item2, snapshot.data[index].item1)
                        ],
                      ),
                    ),
                  ),
                  divider()
                ]);
              });
        }
      },
    );
  }

  List<Widget> buildItemsForCategory(List<GearItem> items) {
    List<Widget> list = [];
    items.forEach((element) => list.add(itemElement(element)));

    return list;
  }

  Widget itemElement(GearItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            children: [
              Row(
                children: [
                  item.url == ''
                      ? Text(
                          item.title,
                          style: style,
                        )
                      : RichText(
                          text: TextSpan(
                              text: item.title,
                              style: urlStyle,
                              recognizer: TapGestureRecognizer()..onTap = () => launch(item.url)))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  item.brand == ''
                      ? Text('Unknown brand', style: style)
                      : Text(item.brand, style: style),
                  Text(item.amount.toString() + ' x ' + item.weight.toString() + 'g', style: style)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget totalWeightRow(int weight, String category) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$category ' + texts.totalWeight,
            style: style,
          ),
          Text(weight.toString() + 'g')
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
      children: [packlistTitle(), divider(), buildGearItems()],
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
            child: Text(texts.commentsAreTurnedOffForThisPacklist))
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
    // if (userProfileNotifier == null ||
    //     userProfile == null ||
    //     packlist == null ||
    //     packlistNotifier == null ||
    //     createdBy == null) return load();
    var texts = AppLocalizations.of(context);

    itemCategories = [
      Tuple2(texts.carrying, 'carrying'),
      Tuple2(texts.sleepingGear, 'sleepingGear'),
      Tuple2(texts.foodAndCookingEquipment, 'foodAndCookingEquipment'),
      Tuple2(texts.clothesPacked, 'clothesPacked'),
      Tuple2(texts.clothesWorn, 'clothesWorn'),
      Tuple2(texts.other, 'other'),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          texts.packList, //"PACKLIST", //TODO add and trans
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
                    snap: false,
                    leading: Container(), // hiding the backbutton
                    bottom: PreferredSize(
                      preferredSize: Size(double.infinity, 50.0),
                      child: TabBar(
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        labelStyle: Theme.of(context).textTheme.headline3,
                        tabs: [
                          Tab(text: texts.overview), //'Overview'), //TODO add and trans
                          Tab(text: texts.items), //'Items'), //TODO add and trans
                          Tab(text: texts.comments), //'Comments'), //TODO add and trans
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
