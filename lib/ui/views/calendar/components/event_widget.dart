import 'dart:math';

import 'package:app/assets/theme/theme_data_custom.dart';
import 'package:app/constants/constants.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/shared/formatters/datetime_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class EventWidget extends StatelessWidget {
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

  EventNotifier eventNotifier;
  CalendarService calendarService = CalendarService();
  UserProfileService _userProfileService;

  openEvent(BuildContext context) async {
    await calendarService.getEventAsNotifier(id, eventNotifier);
    Navigator.pushNamed(context, '/event');
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
          image: mainImage == null
              ? AssetImage('lib/assets/images/logo_2.png')
              : NetworkImage(mainImage),
          fit: BoxFit.cover,
        ),
      ),
    );

    var _title = Container(
      width: _media.size.width * 0.5,
      child: Text(
        title,
        style: _theme.textTheme.headline3,
        overflow: TextOverflow.ellipsis,
      ),
    );

    var _categoryChip = Transform(
      transform: Matrix4.identity()..scale(0.8),
      child: Chip(
        label: Text(
          category, //TODO add and trans
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    var _locationDateParticipants = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 0, 4),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Color.fromRGBO(81, 81, 81, 1),
                size: 15,
              ),
              Text(
                region + ", " + country,
                style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color.fromRGBO(81, 81, 81, 1),
                size: 15,
              ),
              Text(
                formatCalendarDateTime(context, startDate, endDate),
                style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 0, 8),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Color.fromRGBO(81, 81, 81, 1),
                size: 15,
              ),
              Text(
                participants.length.toString() +
                    "/" +
                    maxParticipants.toString() +
                    " " +
                    texts.participant,
                style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    Widget bottomRightYamaLogoAvatar() {
      if (this.highlighted == true) {
        return Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.transparent,
            backgroundImage:
                AssetImage('lib/assets/images/logo_without_bottom_yama.png'),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.transparent,
          ),
        );
      }
    }

    var _bottomRightOwnerAvatar = Align(
      //TODO find out if a conversion to state widget and futurebuilder is needed
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(
            "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
      ),
    );

    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
      elevation: 5.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        // width: _media.size.width * 0.9,
        height: 140,
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
                    padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                          child: _title,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: _categoryChip,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _locationDateParticipants,
                            Row(
                              children: [
                                bottomRightYamaLogoAvatar(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: _bottomRightOwnerAvatar,
                                ),
                              ],
                            ),
                          ],
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
