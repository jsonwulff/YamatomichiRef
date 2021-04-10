import 'dart:io';
import 'dart:math';

import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                pinned: true,
                bottom: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: "Packlists"),
                    Tab(text: "Events"),
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
    );
  }

  _profile() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://www.goworldtravel.com/wp-content/uploads/2019/06/hiking-patagonia-Torres-del-paine-1080x500.jpg"),
                    fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.yamatomichi.com/wp-content/uploads/2019/02/Three-1600-52.jpg"),
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
            height: 20,
          ),
          Text(
            "About me",
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
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
