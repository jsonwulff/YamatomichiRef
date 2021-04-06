import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GearReviewView extends StatefulWidget {
  GearReviewView({Key key}) : super(key: key);

  @override
  _GearReviewState createState() => _GearReviewState();
}

class _GearReviewState extends State<GearReviewView> {
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(texts.gearReview),
        backgroundColor: Colors.black,
        /*bottom: TabBar( TODO Implement tabbar

        )*/
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: [
              buildGearReviewItem(context),
              buildGearReviewItem(context),
              buildGearReviewItem(context),
              buildGearReviewItem(context),
            ],
          ),
        ),

        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createGearReview');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Colorway for the tag should be defined by the tag name
  Chip buildCategoryTag(BuildContext context) {
    return Chip(
      backgroundColor: Colors.blue,
      label: Text('Snow hike'),
    );
  }

  Flex buildGearReviewItem(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            height: 220.0,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, supportRoute); // Navigate to packlist
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
                                "https://www.yamatomichi.com/wp-content/uploads/2019/02/three_Winter-Moss-_-Standard_color_3rd.jpg"))),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Yama bag 200",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 25.0)),
                          // TODO IMPLEMENT RATING HERE
                          Text(
                            'Weight: 12 kg',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Price: 1200 kr',
                            textAlign: TextAlign.left,
                          ),
                          buildCategoryTag(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
