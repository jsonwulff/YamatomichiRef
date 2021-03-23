import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/models/event.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:intl/intl.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:app/ui/components/calendar/event_controllers.dart';

//Display a specific event
//DESIGN DIS PLS = https://stackoverflow.com/questions/49402837/flutter-overlay-card-widget-on-a-container

class EventView extends StatefulWidget {
  EventView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  CalendarService db = CalendarService();
  UserProfile userProfile;
  UserProfileNotifier userProfileNotifier;
  bool highlighted;

  @override
  void initState() {
    super.initState();
    userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
      //userProfile = userProfileNotifier.userProfile;
      //print(userProfile);
    }
  }

  Widget buildEventPicture(String imageUrl) {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
              image: NetworkImage(
                  "https://media-exp1.licdn.com/dms/image/C4D1BAQHTTXqGSiygtw/company-background_10000/0/1550684469280?e=2159024400&v=beta&t=MjXC23zEDVy8zUXSMWXlXwcaeLxDu6Gt-hrm8Tz1zUE"),
              fit: BoxFit.cover),
        ));
  }

  _formatDateTime(DateTime dateTime) {
    return DateFormat('EE dd. MMMM y').format(dateTime);
  }

  Widget buildUserInfo(Event event) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
                    fit: BoxFit.fill),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Jon Snow',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(81, 81, 81, 1)),
                )),
          ],
        ));
  }

  Widget buildTitleColumn(Event event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildHightlightedText(event),
        buildJoinEventButton(event.id),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(
            event.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(81, 81, 81, 1)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Text(
            'Hachimantai, ${event.region}, Japan',
            style:
                TextStyle(fontSize: 16, color: Color.fromRGBO(81, 81, 81, 1)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: buildUserInfo(event),
        ),
        Divider(
          color: Colors.grey,
          thickness: 2,
        )
        //Event title
      ],
    );
  }

  Widget buildHightlightedText(Event event) {
    if (event.highlighted)
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text('*** HIGHLIGHTED BY YAMATOMICHI ***',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(81, 81, 81, 1))));
    else
      return Text('');
  }

  Widget buildJoinEventButton(String eventID) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: ElevatedButton(
            child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Text(
                  'Join event',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            onPressed: () {}, //check stream for participants
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0))))));
  }

  Widget buildInfoColumn(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.person,
                        color: Color.fromRGBO(81, 81, 81, 1))),
                // Padding(
                //     padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
                //     child: StreamBuilder(
                //       stream: getEventParticipants(),
                //       initialData: event.participants.length,
                //       builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                //         Text(
                //           '${snapshot.data.length} / ${event.maxParticipants}',
                //           style:
                //               TextStyle(color: Color.fromRGBO(81, 81, 81, 1)))
                //       }
                //     )
                // ),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.payment_outlined,
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        '${event.price} ',
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                      Text(
                        '( ${event.payment} )',
                        style: TextStyle(
                          color: Color.fromARGB(255, 169, 169, 169),
                        ),
                      )
                    ])),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.location_on,
                        color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        '${_formatDateTime(event.startDate.toDate())} / ${event.meeting}',
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                        overflow: TextOverflow.ellipsis))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        Icon(Icons.flag, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        '${_formatDateTime(event.endDate.toDate())} / ${event.dissolution}',
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                        overflow: TextOverflow.ellipsis))
              ],
            )),
        // Padding(
        //     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //     child: Row(
        //       children: [
        //         Padding(padding: EdgeInsets.all(10), child: Icon(Icons.info)),
        //         Padding(
        //             padding: EdgeInsets.all(10),
        //             child: Text('${event.requirements}',
        //                 overflow: TextOverflow.ellipsis))
        //       ],
        //     )),
        // Padding(
        //     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //     child: Row(
        //       children: [
        //         Padding(
        //             padding: EdgeInsets.all(10), child: Icon(Icons.backpack)),
        //         Padding(
        //             padding: EdgeInsets.all(10),
        //             child: Text('${event.equipment}',
        //                 overflow: TextOverflow.ellipsis))
        //       ],
        //     )),
        Divider(
          color: Colors.grey,
          thickness: 2,
        ),

        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('About',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(81, 81, 81, 1),
                    height: 1.8))),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text('${event.description}',
              style: TextStyle(
                  color: Color.fromRGBO(119, 119, 119, 1), height: 1.8)),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('Participation Requirements',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(81, 81, 81, 1),
                    height: 1.8))),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text('${event.requirements}',
                style: TextStyle(
                    color: Color.fromRGBO(119, 119, 119, 1), height: 1.8))),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('Equipment',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(81, 81, 81, 1),
                    height: 1.8))),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text('${event.equipment}',
                style: TextStyle(
                    color: Color.fromRGBO(119, 119, 119, 1), height: 1.8))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Event event = Provider.of<EventNotifier>(context, listen: true).event;
    EventNotifier eventNotifier =
        Provider.of<EventNotifier>(context, listen: false);
    userProfile = userProfileNotifier.userProfile;

    highlightButtonAction(Event event) async {
      print('highlight button action');
      await db.highlightEvent(event, eventNotifier);
    }

    highlightIcon(Event event) {
      if (event.highlighted)
        return Icons.star_outlined;
      else
        return Icons.star_outline_outlined;
    }

    Widget buildHighlightButton(Event event) {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
            onPressed: () {
              highlightButtonAction(event);
            },
            child: Icon(highlightIcon(event)),
          ));
    }

    Widget buildEditButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
            child: Icon(Icons.edit_outlined),
          ));
    }

    deleteButtonAction(Event event) async {
      print('delete button action');
      if (await db.deleteEvent(context, event)) {
        Navigator.pushNamed(context, '/calendar');
        Provider.of<EventNotifier>(context, listen: false).remove();
        EventControllers.dispose();
      }
    }

    Widget buildDeleteButton(Event event) {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FloatingActionButton(
              heroTag: 'btn2',
              onPressed: () {
                print('delete button pressed');
                deleteButtonAction(event);
              },
              child: Icon(Icons.delete_outline)));
    }

    asyncIsAdmin() async {
      await isAdmin(context);
    }

    Widget buildButtons(Event event) {
      asyncIsAdmin();
      if (userProfile.id == event.createdBy && userProfile.roles != null) {
        if (userProfile.roles['administrator']) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            buildEditButton(),
            buildHighlightButton(event),
            buildDeleteButton(event)
          ]);
        } else
          return null;
      } else if (userProfile.id == event.createdBy) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [buildEditButton(), buildDeleteButton(event)]);
      } else if (userProfile.roles != null) {
        if (userProfile.roles['administrator']) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            buildDeleteButton(event),
            buildHighlightButton(event)
          ]);
        }
      } else
        return null;
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(119, 119, 119, 1),
            title: Text('EVENT'),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
                eventNotifier.remove();
                EventControllers.dispose();
              },
            )),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
            width: MediaQuery.of(context)
                .size
                .width, //try to not overflow.. doesnt work
            child: Column(
              children: [
                buildEventPicture(event.imageUrl),
                buildTitleColumn(event),
                buildInfoColumn(event),
              ],
            ),
          )))
        ]),
        floatingActionButton: buildButtons(event));
  }
}
