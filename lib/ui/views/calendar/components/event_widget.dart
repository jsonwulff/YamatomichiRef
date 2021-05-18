import 'package:app/assets/theme/theme_data_custom.dart';
import 'package:app/constants/categories.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/shared/components/mini_avatar.dart';
import 'package:app/ui/shared/formatters/datetime_formatter.dart';
import 'package:app/ui/utils/chip_color.dart';
import 'package:app/ui/views/calendar/event_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/constants/countryRegion.dart';

// ignore: must_be_immutable
class EventWidget extends StatefulWidget {
  EventWidget(
      {Key key,
      this.id,
      this.title,
      this.createdBy,
      this.description,
      this.category,
      this.country,
      this.region,
      this.maxParticipants,
      this.participants,
      this.startDate,
      this.endDate,
      this.mainImage,
      this.highlighted})
      : super(key: key);
  final String id;
  final String title;
  final String createdBy;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String mainImage;
  final String category;
  final String country;
  final String region;
  final int maxParticipants;
  final List participants;
  final bool highlighted;

  @override
  _EventWidgetViewState createState() => _EventWidgetViewState();
}

class _EventWidgetViewState extends State<EventWidget> {
  EventNotifier eventNotifier;
  CalendarService calendarService = CalendarService();
  UserProfileService _userProfileService;

  openEvent(BuildContext context) async {
    if (widget == null || widget.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This event has been deleted'),
        ),
      );
      return;
    }
    await calendarService.getEventAsNotifier(widget.id, eventNotifier);
    pushNewScreen(context, screen: EventView(), withNavBar: false);
  }

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    // setup();
  }

  String getCategoryTxt(context, String txt) {
    if (txt.length > 2) {
      return txt;
    } else {
      return getSingleCategoryFromId(context, txt);
    }
  }

  @override
  Widget build(BuildContext context) {
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    var _theme = Theme.of(context);
    var _media = MediaQuery.of(context);
    var texts = AppLocalizations.of(context);

    var _leftPicture = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        image: DecorationImage(
          image: widget.mainImage == null
              ? AssetImage('lib/assets/images/logo_eventwidget.png')
              : NetworkImage(widget.mainImage),
          fit: BoxFit.cover,
        ),
      ),
    );

    var _title = Container(
      width: _media.size.width * 0.5,
      child: Text(
        widget.title,
        style: _theme.textTheme.headline3,
        overflow: TextOverflow.ellipsis,
      ),
    );

    var _categoryChip = Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.identity()..scale(0.7),
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        label: Text(
          getCategoryTxt(context, widget.category),
          style: TextStyle(color: Colors.black54),
        ),
        side: BorderSide(color: chooseChipColor(widget.category), width: 3),
        backgroundColor:
            Colors.white, //chooseChipColor(widget.category), //Theme.of(context).primaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    var _locationDateParticipants = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Color.fromRGBO(81, 81, 81, 1),
                size: 15,
              ),
              Expanded(
                child: Text(
                  getCountryTranslated(context, widget.country) +
                      ", " +
                      getRegionTranslated(context, widget.country, widget.region),
                  style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color.fromRGBO(81, 81, 81, 1),
                size: 15,
              ),
              Expanded(
                child: Text(
                  formatCalendarDateTime(context, widget.startDate, widget.endDate),
                  style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Color.fromRGBO(81, 81, 81, 1),
                size: 15,
              ),
              Expanded(
                child: Text(
                  widget.participants.length.toString() +
                      "/" +
                      widget.maxParticipants.toString() +
                      " " +
                      texts.participant,
                  style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    Widget bottomRightYamaLogoAvatar() {
      if (widget.highlighted == true) {
        return Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 22.5, //22.5
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('lib/assets/images/logo_without_bottom_yama.png'),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 22.5,
            backgroundColor: Colors.transparent,
          ),
        );
      }
    }

    Future<UserProfile> setup() async {
      return await _userProfileService.getUserProfile(widget.createdBy);
    }

    _userAvatar() {
      return FutureBuilder(
        future: setup(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MiniAvatar(user: snapshot.data);
          } else {
            return CircleAvatar(
              radius: 16.0,
              backgroundColor: Colors.white,
            );
          }
        },
      );
    }

    return Card(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      elevation: 5.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        width: _media.size.width * 0.9,
        height: 140,
        constraints: BoxConstraints(
            minWidth: 0, minHeight: 0, maxWidth: _media.size.width * 0.9, maxHeight: 140),
        child: InkWell(
          onTap: () {
            openEvent(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _leftPicture,
              ),
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: _title),
                        Expanded(flex: 2, child: _categoryChip),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _locationDateParticipants),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    bottomRightYamaLogoAvatar(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                      child: _userAvatar(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
