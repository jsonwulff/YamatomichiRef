import 'dart:math';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalProfileView extends StatefulWidget {
  @override
  _PersonalProfileViewState createState() => _PersonalProfileViewState();
}

/*Source: https://stackoverflow.com/questions/59904719/instagram-profile-header-layout-in-flutter  */
class _PersonalProfileViewState extends State<PersonalProfileView> {
  double get randHeight => Random().nextInt(100).toDouble();

  List<Widget> _randomChildren;

  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery
  List<Widget> _randomHeightWidgets(BuildContext context) {
    _randomChildren ??= List.generate(3, (index) {
      final height = randHeight.clamp(
        50.0,
        MediaQuery.of(context)
            .size
            .width, // simply using MediaQuery to demonstrate usage of context
      );
      return Container(
        color: Colors.primaries[index],
        height: height,
        child: Text('Random Height Child ${index + 1}'),
      );
    });

    return _randomChildren;
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
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
                  bottom: TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: texts.packListsLC),
                      Tab(text: texts.events),
                    ],
                  ),
                  expandedHeight: 450,
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
                Container(
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
                ),
                Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _profile() {
    var texts = AppLocalizations.of(context);

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
            child: Container(
              alignment: Alignment(0.0, 0.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://www.yamatomichi.com/wp-content/uploads/2019/02/Three-1600-52.jpg"),
                radius: 60.0,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Jens H. Jensen",
            style: Theme.of(context).textTheme.headline1
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Tokyo, Japan",
            style: Theme.of(context).textTheme.headline3
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: texts.aboutMe,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text:
                          "Hello my name is Jens I love hiking jadjajdajdskjdajskda dskaf;hj;adshfasd;hfa;sdhfa;sdjhfajds;hfasjdhf;jahsdjf;has;dhfa;shdfa;ksdhfa;sdhfa;sdh",
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

/* return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("add you image URL here "),
                    fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage("Add you profile DP image URL here "),
                  radius: 60.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Text(
            "Jens H. Jensen",
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.blueGrey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Tokyo, Japan",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Project",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "15",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Followers",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "2000",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    ));
  }
}*/
