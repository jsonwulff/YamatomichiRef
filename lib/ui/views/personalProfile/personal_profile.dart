import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/utils/user_color_hash.dart';
import 'package:app/ui/views/calendar/components/event_widget.dart';
import 'package:app/ui/views/packlist/packlist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PersonalProfileView extends StatefulWidget {
  final String userID;

  const PersonalProfileView({
    Key key,
    this.userID,
  }) : super(key: key);

  @override
  _PersonalProfileViewState createState() => _PersonalProfileViewState();
}

class _PersonalProfileViewState extends State<PersonalProfileView> {
  UserProfileService userProfileService = UserProfileService();
  AppLocalizations texts;
  String _userID;
  bool _belongsToUserInSession;
  UserProfile _userProfile;

  @override
  void initState() {
    String userInSessionID = context.read<AuthenticationService>().user.uid;
    if (widget.userID == null) {
      _userID = userInSessionID;
    } else {
      _userID = widget.userID;
    }
    _belongsToUserInSession = userInSessionID == _userID;
    super.initState();
  }

  Widget _buildMainContainer() {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                _profile(context),
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              labelStyle: Theme.of(context).textTheme.headline3,
              tabs: [
                Tab(text: texts.packListsLC),
                Tab(text: texts.events),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _packListsItems(),
                  _eventsListItems(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_userID);
    texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarCustom.basicAppBar(texts.profile, context),
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: FutureBuilder(
            future: userProfileService.getUserProfile(_userID),
            builder: (context, AsyncSnapshot<UserProfile> snapshot) {
              if (snapshot.hasData) {
                _userProfile = snapshot.data;
                return _buildMainContainer();
              } else if (snapshot.hasError) {
                return SafeArea(
                  child: Center(
                    child: Text('Something went wrong'),
                  ),
                );
              } else {
                return SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _settingsIconButton(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return _belongsToUserInSession
        ? IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      // height: 330,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            texts.editProfile,
                            textAlign: TextAlign.center,
                          ),
                          // dense: true,
                          onTap: () {
                            UserProfileNotifier userProfileNotifier =
                                Provider.of<UserProfileNotifier>(context,
                                    listen: false);
                            userProfileNotifier.userProfile = null;
                            Navigator.of(context).pushNamed(profileRoute);
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 5,
                        ),
                        ListTile(
                          title: Text(
                            texts.support,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, supportRoute);
                          },
                        ),
                        Divider(
                          thickness: 1,
                          height: 5,
                        ),
                        ListTile(
                          title: Text(
                            texts.settings,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, settingsRoute);
                          },
                        ),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text(
                            texts.signOut,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            if (await context
                                .read<AuthenticationService>()
                                .signOut(context: context)) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  signInRoute, (Route<dynamic> route) => false);
                            }
                          },
                        ),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text(
                            texts.close,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          )
        : Container(width: 24);
  }

  _iconButtonBack() {
    return Navigator.canPop(context)
        ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          )
        : Container(width: 24);
  }

  _profilePicture() {
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: CircleAvatar(
        child: _userProfile.imageUrl == null
            ? Text(
                _userProfile.firstName[0] + _userProfile.lastName[0],
                style: TextStyle(fontSize: 40, color: Colors.white),
              )
            : null,
        backgroundColor: generateColor(_userProfile.email),
        backgroundImage: _userProfile.imageUrl != null
            ? NetworkImage(_userProfile.imageUrl)
            : null,
        radius: 60.0,
      ),
    );
  }

  _aboutMeHeadLine() {
    var texts = AppLocalizations.of(context);
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: texts.aboutMe,
        style: (Theme.of(context).textTheme.headline3),
      ),
    );
  }

  _textForAboutMe() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          text: _userProfile.description,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  _nameOfProfile() {
    return Text(_userProfile.firstName + " " + _userProfile.lastName,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1);
    // return Text(widget.userID,
    //     textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1);
  }

  _regionAndCountry() {
    if (_userProfile.country == null && _userProfile.hikingRegion == null) {
      return Container();
    } else if (_userProfile.country != null &&
        _userProfile.hikingRegion == null) {
      return Text(_userProfile.country,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3);
    } else {
      return Text(_userProfile.country + ', ' + _userProfile.hikingRegion,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3);
    }
  }

  _packListsItems() {
    return Container(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return PacklistItemView();
        },
      ),
    );
  }

  EventWidget _createEventWidget(Map<String, dynamic> data) {
    var eventWidget = EventWidget(
      id: data["id"],
      title: data["title"],
      description: data["description"],
      startDate: data["startDate"].toDate(),
      endDate: data["endDate"].toDate(),
      mainImage: data["mainImage"],
    );
    return eventWidget;
  }

  _eventsListItems() {
    var db = Provider.of<CalendarService>(context);

    return Container(
      child: FutureBuilder(
        future: db.getEventsByUser(_userProfile),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _createEventWidget(snapshot.data[index]);
                },
              );
            }
          }
        },
      ),
    );
  }

  _profile(BuildContext context) {
    return <Widget>[
      SizedBox(
        height: 30,
      ),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconButtonBack(),
            _profilePicture(),
            _settingsIconButton(context),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
      _nameOfProfile(),
      SizedBox(
        height: 7,
      ),
      _regionAndCountry(),
      SizedBox(
        height: 25,
      ),
      Row(
        children: [
          _aboutMeHeadLine(),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _textForAboutMe(),
        ],
      ),
    ];
  }
}
