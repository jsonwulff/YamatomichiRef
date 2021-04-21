import 'dart:async';

import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/calendar/components/comment_widget.dart';
import 'package:app/ui/views/calendar/components/event_img_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/event_controllers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;

class EventView extends StatefulWidget {
  EventView({Key key, this.title, this.userProfileNotifier, this.userProfileService})
      : super(key: key);

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
    userProfileService.isAdmin(userProfile.id, userProfileNotifier);
    setup();
  }

  Future<void> setup() async {
    print('setup');
    //Setup event
    updateEventInNotifier();
    //Setup createdByUser
    if (event.createdBy == null) {
      createdBy = userProfileService.getUnknownUser();
    } else {
      createdBy = await userProfileService.getUserProfile(event.createdBy);
    }
    if (eventNotifier == null) print('the fack');
    stream = calendarService.getStreamOfParticipants(eventNotifier).asBroadcastStream();
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
            margin: EdgeInsets.all(8.0),
            child: EventCarousel(
              mainImage: event.mainImage == null ? null : event.mainImage,
              images: event.imageUrl == null ? [] : event.imageUrl.toList(),
            )));
  }

  _formatDateTime(DateTime dateTime) {
    return DateFormat('dd. MMMM HH:mm').format(dateTime);
  }

  Color maxCapacityColor() {
    if (maxCapacity)
      return Colors.red;
    else
      return Colors.black;
  }

  Widget buildUserInfo(Event event) {
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
              else if (streamSnapshot.data.length >= event.maxParticipants)
                status = 'grey';
              else
                status = 'join';
              return makeEventButton(status);
            default:
              return makeEventButton(status);
          }
        });
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
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
        child: Text(
          event.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromRGBO(81, 81, 81, 1)),
        ),
      ),
    );
  }

  Widget buildInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        Icon(Icons.perm_identity_outlined, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: participantCountWidget(),
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
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
                            //color: Color.fromARGB(255, 169, 169, 169),
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
                    child: Icon(Icons.location_on, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('${_formatDateTime(event.startDate.toDate())} / ${event.meeting}',
                        key: Key('eventStartAndMeeting'),
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
                    child: Icon(Icons.flag, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('${_formatDateTime(event.endDate.toDate())} / ${event.dissolution}',
                        key: Key('eventEndAndDissolution'),
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
                        Icon(Icons.hourglass_bottom_rounded, color: Color.fromRGBO(81, 81, 81, 1))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sign up before ${_formatDateTime(event.deadline.toDate())}',
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
            Navigator.pushNamed(context, '/createEvent');
          },
          child: Icon(Icons.mode_outlined, color: Colors.black),
        ));
  }

  deleteButtonAction(Event event) async {
    print('delete button action');
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
    if (userProfile.id == event.createdBy && userProfile.roles != null) {
      if (userProfile.roles['administrator']) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [buildEditButton(), buildHighlightButton(event), buildDeleteButton(event)]);
      }
    }
    if (userProfile.id == event.createdBy) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [buildEditButton(), buildDeleteButton(event)]);
    }
    if (userProfile.roles != null) {
      if (userProfile.roles['administrator']) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [buildHighlightButton(event), buildDeleteButton(event)]);
      }
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
    return Container(
        height: 500,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: participants.length,
          itemBuilder: (context, index) {
            return participant(participants[index]);
          },
        ));
  }

  Widget participant(UserProfile participant) {
    if (participant != null) {
      if (participant.imageUrl == null) {
        return Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ));
      }
      return Padding(
          padding: EdgeInsets.only(left: 10),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(participant.imageUrl), fit: BoxFit.fill),
            ),
          ));
    } else {
      return Container();
    }
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
    return Container(
        height: 50,
        child: StreamBuilder(
            initialData: [],
            stream: stream,
            builder: (context, streamSnapshot) {
              switch (streamSnapshot.connectionState) {
                case ConnectionState.none:
                  return Text('None?');
                case ConnectionState.waiting:
                  return participantsList(
                    participantList,
                    context,
                  );
                case ConnectionState.active:
                  if (!streamSnapshot.hasData) return Text('No data in stream');
                  return FutureBuilder(
                      future: addParticipantsToList(streamSnapshot.data),
                      builder: (context, futureSnapshot) {
                        switch (futureSnapshot.connectionState) {
                          case ConnectionState.none:
                            return Text('None?');
                          case ConnectionState.waiting:
                            return participantsList(
                              participantList,
                              context,
                            );
                          case ConnectionState.done:
                            if (!futureSnapshot.hasData) return Text('No data in list');
                            participantList = futureSnapshot.data;
                            return participantsList(
                              participantList,
                              context,
                            );
                          default:
                            return Container();
                        }
                      });
                default:
                  return Container();
              }
            }));
  }

  Widget participantCountWidget() {
    String count = '0';
    return StreamBuilder(
        initialData: [],
        stream: stream,
        builder: (context, streamSnapshot) {
          switch (streamSnapshot.connectionState) {
            case ConnectionState.none:
              return Text('None?');
            case ConnectionState.waiting:
              print('waiting');
              return Text(
                '${count} / ${event.maxParticipants} (minimum ${event.minParticipants})',
                style: TextStyle(color: maxCapacityColor()),
              );
            case ConnectionState.active:
              print('active');
              if (!streamSnapshot.hasData) return Text('No data in stream');
              count = streamSnapshot.data.length.toString();
              if (streamSnapshot.data.length >= event.maxParticipants)
                maxCapacity = true;
              else
                maxCapacity = false;
              return Text(
                '${count} / ${event.maxParticipants} (minimum ${event.minParticipants})',
                style: TextStyle(color: maxCapacityColor()),
              );
            default:
              return Container();
          }
        });
  }

  Widget endorsed() {
    if (event.highlighted) {
      return Container(
          alignment: Alignment.topRight,
          padding: new EdgeInsets.only(top: 15, right: 15, left: 15),
          child: new Container(
            height: 45.0,
            width: 45.0,
            child: new Card(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage('https://lwhiker.com/brands/yamatomichi/logo/400'),
                      fit: BoxFit.fill),
                ),
              ),
              color: Color.fromRGBO(0, 0, 0, 0),
              elevation: 4.0,
              shadowColor: Color.fromRGBO(0, 0, 0, 0),
            ),
          ));
    } else {
      return Container(
          alignment: Alignment.topRight,
          child: Transform.translate(
              //offset: Offset(0, 100),
              offset: Offset(45, 20),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  width: 150.0,
                  child: Text('yamatomichi',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10.0,
                          letterSpacing: 1.0,
                          color: Colors.black.withOpacity(0.7))),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
                  ]),
                ),
              )));
    }
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
      widget = CommentWidget(documentRef: event.id);
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

  Widget divider() {
    return Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: Color.fromRGBO(220, 221, 223, 1),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // return StreamProvider<List<String>>(
    //   create: (_) => calendarService.getStreamOfParticipants(eventNotifier),
    //   child: participantCountWidget(),
    // );
    var texts = AppLocalizations.of(context);
    if (userProfile == null || event == null || createdBy == null) {
      return load();
    } else {
      return Scaffold(
        appBar: AppBar(
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
              )),
        ),
      );
    }
  }
}

/*Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  participantListWidget(),
                ],
              ),
            )))
          ]),
          floatingActionButton: buildButtons(event));*/
