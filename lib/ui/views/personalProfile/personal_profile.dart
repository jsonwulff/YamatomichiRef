import 'dart:math';

import 'package:app/constants/constants.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/views/packlist/packlist_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PersonalProfileView extends StatefulWidget {
  @override
  _PersonalProfileViewState createState() => _PersonalProfileViewState();
}

/*Source: https://stackoverflow.com/questions/59904719/instagram-profile-header-layout-in-flutter  */
class _PersonalProfileViewState extends State<PersonalProfileView> {
  bool _belongsToUserInSession;

  final _random = new Random();

  UserProfile _userProfile;
  User _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthenticationService>().user;
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      getUserProfile(_user.uid, userProfileNotifier);
      _belongsToUserInSession = true;
    }
    if (userProfileNotifier.userProfile != null &&
        userProfileNotifier.userProfile.id == _user.uid) {
      // _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;
      _belongsToUserInSession = true;
    }
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
                                .signOut(context)) {
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
        backgroundColor:
            profileImageColors[_random.nextInt(profileImageColors.length)],
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
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  _textForAboutMe() {
    return Expanded(
      child: RichText(
        text: TextSpan(
            text:
                "Hello my name is Jens I love hiking in the mountains and i love to pack my back with crazy stuff",
            style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }

  _nameOfProfile() {
    return Text(_userProfile.firstName + " " + _userProfile.lastName,
        style: Theme.of(context).textTheme.headline1);
  }

  _regionAndCountry() {
    // String textToBeDisplayed;
    // if (_userProfile.country == null) {
    //   textToBeDisplayed =
    // }
    return Text('Country' + ', ' + 'Region',
        style: Theme.of(context).textTheme.headline3);
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

  _eventsListItems() {
    return Container(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Container(
            height: 40,
            alignment: Alignment.center,
            color: Colors.lightBlue[100 * (index % 9)],
            child: Text('List Item $index'),
          );
        },
      ),
    );
  }

  _profile(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            // margin: EdgeInsets.only(top: 20.0),
            // width: double.infinity,
            // height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _iconButtonBack(),
                _profilePicture(),
                _settingsIconButton(context)
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
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    return Scaffold(
      // appBar: AppBarCustom.basicAppBar(texts.profile),
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: DefaultTabController(
          length: 2,
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
                        Tab(text: texts.packListsLC),
                        Tab(text: texts.events),
                      ],
                    ),
                  ),
                  expandedHeight: 400,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _profile(
                        context), // This is where you build the profile part
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _packListsItems(),
                _eventsListItems(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
