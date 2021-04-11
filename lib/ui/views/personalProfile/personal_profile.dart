import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalProfileView extends StatefulWidget {
  @override
  _PersonalProfileViewState createState() => _PersonalProfileViewState();
}

/*Source: https://stackoverflow.com/questions/59904719/instagram-profile-header-layout-in-flutter  */
class _PersonalProfileViewState extends State<PersonalProfileView> {
  _settingsIconButton() {
    return true // profile viewed belongs to user in session
    ? IconButton(
      icon: Icon(Icons.settings),
      onPressed: () => Navigator.of(context).pop(),
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
        backgroundImage: NetworkImage(
            "https://www.yamatomichi.com/wp-content/uploads/2019/02/Three-1600-52.jpg"),
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
    return Text("Jens H. Jensen", style: Theme.of(context).textTheme.headline1);
  }

  _regionAndCountry() {
    return Text("Tokyo, Japan", style: Theme.of(context).textTheme.headline3);
  }

  _packListsItems() {
    return Container(
      child: ListView.builder(
        itemCount: 10,
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

  _profile() {
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
                _settingsIconButton()
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
                    background:
                        _profile(), // This is where you build the profile part
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
