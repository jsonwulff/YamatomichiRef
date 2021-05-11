import 'dart:async';

import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/components/divider.dart';
import 'package:app/ui/shared/components/mini_avatar.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/calendar/components/comment_widget.dart';
import 'package:app/ui/views/calendar/components/event_img_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar.dart';
import 'components/event_controllers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;

class EventView extends StatefulWidget {
  EventView({
    Key key,
    this.title,
    this.userProfileNotifier,
    this.userProfileService,
  }) : super(key: key);

  final String title;
  final UserProfileNotifier userProfileNotifier;
  final UserProfileService userProfileService;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  CalendarService calendarService = CalendarService();
  UserProfileService userProfileService = UserProfileService();
  UserProfile userProfile;
  UserProfileNotifier userProfileNotifier;
  Event event;
  EventNotifier eventNotifier;
  UserProfile createdBy;
  AppLocalizations texts;
  bool maxCapacity = false;
  Stream stream;
  List<String> participants;
  Widget displayedParticipants;

  @override
  void initState() {
    super.initState();
    //Setup user
    setup();
  }

  Future<void> setup() async {
    if (userProfile == null) {
      userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
      if (userProfileNotifier.userProfile == null) {
        var tempUser = context.read<AuthenticationService>().user;
        if (tempUser != null) {
          String userUid = context.read<AuthenticationService>().user.uid;
          await userProfileService.getUserProfileAsNotifier(userUid, userProfileNotifier);
        }
      }
    }
    userProfile = Provider.of<UserProfileNotifier>(context, listen: false).userProfile;
    userProfileService.checkRoles(userProfile.id, userProfileNotifier);
    //Setup event
    updateEventInNotifier();
    //Setup createdByUser
    if (event.createdBy == null) {
      createdBy = userProfileService.getUnknownUser();
    } else {
      createdBy = await userProfileService.getUserProfile(event.createdBy);
    }
    stream = calendarService.getStreamOfParticipants(eventNotifier);

    setState(() {});
  }

  updateEventInNotifier() {
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    event = eventNotifier.event;
  }

  Widget buildEventPicture() {
    return Visibility(
        visible: event.mainImage == null ? false : true,
        replacement: Container(height: 230),
        child: Container(
            margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: EventCarousel(
              mainImage: event.mainImage == null ? null : event.mainImage,
              images: event.imageUrl == null ? [] : event.imageUrl.toList(),
            )));
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd. MMMM HH:mm').format(dateTime);
  }

  String _formatDateTimeDeadline(DateTime dateTime) {
    return DateFormat('dd. MMMM').format(dateTime);
  }

  Color maxCapacityColor() {
    if (participants.length >= event.maxParticipants)
      return Colors.red;
    else
      return Color.fromRGBO(81, 81, 81, 1);
  }

  Widget buildUserInfo(Event event) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, personalProfileRoute, arguments: createdBy.id);
                },
                child: MiniAvatar(user: createdBy)),
            Padding(
                key: Key('userName'),
                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
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

  /* ## the part between picture and tab bar ## */
  Widget buildTitleColumn(Event event) {
    print('region ' + event.region + ' .');
    print('country ' + event.country + " .");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildJoinEventButton(),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Text(
            '${event.region}, ${event.country}',
            key: Key('eventRegionAndCountry'),
            style: TextStyle(fontSize: 15, color: Color.fromRGBO(81, 81, 81, 1)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: buildUserInfo(event),
        ),
      ],
    );
  }

  Stream<bool> status() async* {}

  Widget buildJoinEventButton() {
    var status = 'grey';
    return StreamBuilder(
        initialData: [],
        stream: calendarService.getStreamOfParticipants(eventNotifier),
        builder: (context, streamSnapshot) {
          switch (streamSnapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (!streamSnapshot.hasData) status = 'grey';
              if (streamSnapshot.data.contains(userProfile.id))
                status = 'leave';
              else if (streamSnapshot.data.length >= event.maxParticipants ||
                  compareTimestamp(event.deadline, Timestamp.now()) < 0 ||
                  compareTimestamp(event.startDate, Timestamp.now()) < 0)
                status = 'grey';
              else
                status = 'join';
              return makeEventButton(status);
            default:
              return makeEventButton(status);
          }
        });
  }

  compareTimestamp(Timestamp date1, Timestamp date2) {
    var d1 = DateTime.parse(date1.toDate().toString());
    var d2 = DateTime.parse(date2.toDate().toString());
    return d1.difference(d2).inDays;
  }

  makeEventButton(String status) {
    if (status == 'grey')
      return greyEventButton();
    else if (status == 'join')
      return joinEventButton();
    else
      return leaveEventButton();
  }

  Widget greyEventButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                key: Key('joinButton'),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      'Not Available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))))));
  }

  Widget joinEventButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                key: Key('joinButton'),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      'Join event',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                onPressed: () {
                  calendarService.joinEvent(event.id, eventNotifier, userProfile.id);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))))));
  }

  Widget leaveEventButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
                key: Key('leaveButton'),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      'Leave event',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                onPressed: () {
                  calendarService.joinEvent(event.id, eventNotifier, userProfile.id);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))))));
  }

  Widget eventTitle() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
        child: Text(
          event.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromRGBO(81, 81, 81, 1)),
        ),
      ),
      event.highlighted == true
          ? Container(
              alignment: Alignment.topRight,
              padding: new EdgeInsets.only(top: 13, right: 20),
              child: new Container(
                height: 50.0,
                width: 50.0,
                child: new Card(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('lib/assets/images/logo_stamp3.png'), fit: BoxFit.fill),
                    ),
                  ),
                  color: Color.fromRGBO(0, 0, 0, 0),
                  elevation: 4.0,
                  shadowColor: Color.fromRGBO(0, 0, 0, 0),
                ),
              ))
          : Container(),
    ]);
  }

  Widget buildInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // event.highlighted == true
        //     ? Column(
        //         children: [
        //           Padding(
        //               padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Padding(
        //                       padding: EdgeInsets.all(10),
        //                       child:
        //                           Icon(Icons.star_outline, color: Color.fromRGBO(81, 81, 81, 1))),
        //                   Padding(
        //                     padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        //                     child: Text(
        //                       // ignore: unnecessary_brace_in_string_interps
        //                       'Yamatomichi likes this event!',
        //                       style: TextStyle(color: maxCapacityColor()),
        //                     ),
        //                   ),
        //                   Padding(
        //                       padding: EdgeInsets.all(10),
        //                       child:
        //                           Icon(Icons.star_outline, color: Color.fromRGBO(81, 81, 81, 1))),
        //                 ],
        //               )),
        //           divider()
        //         ],
        //       )
        //     : Container(),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        Icon(Icons.perm_identity_outlined, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text(
                    // ignore: unnecessary_brace_in_string_interps
                    '${participants.length.toString()} / ${event.maxParticipants} (minimum ${event.minParticipants})',
                    style: TextStyle(color: maxCapacityColor()),
                  ),
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.payment_outlined, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text(
                        '${event.price} ',
                        key: Key('eventPrice'),
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                      Text(
                        '( ${event.payment} )',
                        key: Key('eventPayment'),
                        style: TextStyle(
                          color: Color.fromRGBO(81, 81, 81, 1),
                        ),
                      )
                    ])),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.location_on, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        '${_formatDateTime(event.startDate.toDate())} - ${event.meeting}',
                        key: Key('eventStartAndMeeting'),
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                      ),
                    ))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.flag, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                          '${_formatDateTime(event.endDate.toDate())} - ${event.dissolution}',
                          key: Key('eventEndAndDissolution'),
                          style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1))),
                    ))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        Icon(Icons.hourglass_bottom_rounded, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        'Sign up before ${_formatDateTimeDeadline(event.deadline.toDate())}',
                        key: Key('eventEndAndDissolution'),
                        style: TextStyle(color: Color.fromRGBO(81, 81, 81, 1)),
                        overflow: TextOverflow.ellipsis))
              ],
            )),
        divider()
      ],
    );
  }

  highlightButtonAction(Event event) async {
    print('highlight button action');
    if (await calendarService.highlightEvent(event, eventNotifier)) {
      setup();
    }
  }

  highlightIcon(Event event) {
    if (event.highlighted)
      return Icon(Icons.star, color: Colors.black);
    else
      return Icon(Icons.star_outline, color: Colors.black);
  }

  Widget buildHighlightButton(Event event) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: GestureDetector(
          onTap: () {
            highlightButtonAction(event);
          },
          child: highlightIcon(event),
        ));
  }

  Widget buildEditButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: GestureDetector(
          //heroTag: 'btn1',
          onTap: () {
            Navigator.pushNamed(context, '/createEvent').then((value) => setState(() {}));
          },
          child: Icon(Icons.mode_outlined, color: Colors.black),
        ));
  }

  deleteButtonAction(Event event) async {
    print('delete button action');
    //TODO tranlate??
    if (await simpleChoiceDialog(context, 'Are you sure you want to delete this event?')) {
      Navigator.pop(context);
      eventNotifier.remove();
      EventControllers.dispose();
      await calendarService.deleteEvent(event);
    }
  }

  Widget buildDeleteButton(Event event) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
        child: GestureDetector(
            //heroTag: 'btn2',
            onTap: () {
              print('delete button pressed');
              deleteButtonAction(event);
            },
            child: Icon(Icons.delete_outline_rounded, color: Colors.black)));
  }

  Widget buildButtons(Event event) {
    if (userProfile.id == event.createdBy &&
        (userProfile.roles['ambassador'] || userProfile.roles['yamatomichi'])) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildHighlightButton(event), buildDeleteButton(event)]);
    }
    if (userProfile.id == event.createdBy) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildDeleteButton(event)]);
    }
    if (userProfile.roles['ambassador'] || userProfile.roles['yamatomichi']) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildHighlightButton(event), buildDeleteButton(event)]);
    }

    return Container();
  }

  Widget load() {
    return SafeArea(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget participantsList(List<UserProfile> participants, BuildContext context) {
    return Wrap(
        children: participants
            .map((item) => Padding(
                padding: EdgeInsets.only(right: 7, bottom: 5, top: 5), child: participant(item)))
            .toList()
            .cast<Widget>());
    // return Container(
    //     child: ListView.builder(
    //   scrollDirection: Axis.horizontal,
    //   itemCount: participants.length,
    //   itemBuilder: (context, index) {
    //     return Padding(
    //         padding: EdgeInsets.only(right: 10), child: participant(participants[index]));
    //   },
    // ));
  }

  Widget participant(UserProfile participant) {
    if (participant == null) return Container();
    if (participant.imageUrl == null) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, personalProfileRoute, arguments: participant.id);
        },
        child: MiniAvatar(user: participant),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, personalProfileRoute, arguments: participant.id);
      },
      child: MiniAvatar(user: participant),
    );
  }

  Future<List<UserProfile>> addParticipantsToList(List<String> pIDList) async {
    List<UserProfile> participants = [];
    for (var pID in pIDList) {
      participants.add(await userProfileService.getUserProfile(pID));
    }
    return participants;
  }

  Widget participantListWidget() {
    List<UserProfile> participantList = [];
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Participants',
            style: Theme.of(context).textTheme.headline3,
          ),
          Container(height: 10),
          Container(
              height: 45,
              child: FutureBuilder(
                  future: addParticipantsToList(participants),
                  builder: (context, futureSnapshot) {
                    switch (futureSnapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('None?');
                      case ConnectionState.waiting:
                        if (displayedParticipants == null) return load();
                        return displayedParticipants;
                      case ConnectionState.done:
                        if (!futureSnapshot.hasData) return Text('No data in list');
                        participantList = futureSnapshot.data;
                        displayedParticipants = participantsList(
                          participantList,
                          context,
                        );
                        return displayedParticipants;
                      default:
                        return Container();
                    }
                  }))
        ]));
  }

  // Widget participantCountWidget() {
  //   return StreamBuilder(
  //       initialData: [],
  //       stream: stream,
  //       builder: (context, streamSnapshot) {
  //         switch (streamSnapshot.connectionState) {
  //           case ConnectionState.none:
  //             return Text('None?');
  //           case ConnectionState.waiting:
  //             return Text(
  //               // ignore: unnecessary_brace_in_string_interps
  //               '${participants.length} / ${event.maxParticipants} (minimum ${event.minParticipants})',
  //               style: TextStyle(color: maxCapacityColor()),
  //             );
  //           case ConnectionState.active:
  //             print('active');
  //             if (!streamSnapshot.hasData) return Text('No data in stream');
  //             count = streamSnapshot.data.length.toString();
  //             if (streamSnapshot.data.length >= event.maxParticipants)
  //               maxCapacity = true;
  //             else
  //               maxCapacity = false;
  //             return Text(
  //               // ignore: unnecessary_brace_in_string_interps
  //               '${count} / ${event.maxParticipants} (minimum ${event.minParticipants})',
  //               style: TextStyle(color: maxCapacityColor()),
  //             );
  //           default:
  //             return Container();
  //         }
  //       });
  // }

  Widget endorsed() {
    return Container();
    // if (event.highlighted) {
    //   return Container(
    //       alignment: Alignment.topRight,
    //       padding: new EdgeInsets.only(top: 13, right: 20),
    //       child: new Container(
    //         height: 55.0,
    //         width: 55.0,
    //         child: new Card(
    //           child: Container(
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               image: DecorationImage(
    //                   image: AssetImage('lib/assets/images/logo_stamp3.png'), fit: BoxFit.fill),
    //             ),
    //           ),
    //           color: Color.fromRGBO(0, 0, 0, 0),
    //           elevation: 4.0,
    //           shadowColor: Color.fromRGBO(0, 0, 0, 0),
    //         ),
    //       ));
    // } else {
    //   return Container();
    // }
  }

  Widget sliverAppBar() {
    return Container(
      //height: 550,
      child: Column(
        children: [
          Stack(
            children: [
              buildEventPicture(),
              endorsed(),
            ],
          ),
          buildTitleColumn(event),
        ],
      ),
    );
  }

  Widget overviewTab() {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [eventTitle(), divider(), buildInfoColumn(), participantListWidget()]));
  }

  Widget aboutTab() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventTitle(),
        divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'About',
              style: Theme.of(context).textTheme.headline3,
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text('${event.description}',
              key: Key('eventDescription'),
              style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1), height: 1.8)),
        ),
        divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Participation Requirements',
              style: Theme.of(context).textTheme.headline3,
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text('${event.requirements}',
                key: Key('eventRequirements'),
                style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1), height: 1.8))),
        divider(),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Equipment',
              style: Theme.of(context).textTheme.headline3,
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text('${event.equipment}',
                key: Key('eventEquipment'),
                style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1), height: 1.8))),
      ],
    ));
  }

  Widget commentTab() {
    var widget;
    if (event.allowComments)
      widget = CommentWidget(
        documentRef: event.id,
        collection: DBCollection.Calendar,
      );
    else
      widget = Column(children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Text('Comments are turned off for this event'))
      ]);

    return Container(
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return StreamProvider<List<String>>(
    //   create: (_) => calendarService.getStreamOfParticipants(eventNotifier),
    //   child: participantCountWidget(),
    // );
    if (userProfile == null || event == null || createdBy == null) {
      return load();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Event",
            style: TextStyle(color: Colors.black),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              eventNotifier.remove();
              EventControllers.dispose();
            },
          ),
          actions: [buildButtons(event)],
        ),
        body: Container(
          child: StreamBuilder(
            stream: stream,
            builder: (context, streamSnapshot) {
              switch (streamSnapshot.connectionState) {
                case ConnectionState.active:
                  if (streamSnapshot.hasData) {
                    participants = streamSnapshot.data;
                    return DefaultTabController(
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
                                      Tab(text: 'Overview'),
                                      Tab(text: 'About'),
                                      Tab(text: 'Comments'),
                                    ],
                                  ),
                                ),
                                expandedHeight: 450,
                                flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.pin,
                                  background: sliverAppBar(),
                                ),
                              ),
                            ];
                          },
                          body: TabBarView(children: [
                            overviewTab(),
                            aboutTab(),
                            commentTab(),
                          ]),
                        ));
                  } else
                    return Container(child: Text('Something went wrong'));
                  break;
                case ConnectionState.waiting:
                  return load();
                  break;
                default:
                  return Container(child: Text('Something went wrong'));
                  break;
              }
            },
          ),
        ),
      );
    }
  }
}
