import 'package:app/assets/theme/theme_data_custom.dart';
import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/shared/formatters/datetime_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventWidget extends StatelessWidget {
  EventWidget(
      {Key key,
      this.id,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.mainImage})
      : super(key: key);
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String mainImage;

  EventNotifier eventNotifier;

  openEvent(BuildContext context) async {
    await getEvent(id, eventNotifier);
    Navigator.pushNamed(context, '/event');
  }

  @override
  Widget build(BuildContext context) {
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    var _theme = Theme.of(context);
    var _media = MediaQuery.of(context);

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
          'Type of event',
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
                'Hokkaido, Japan',
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
                '20/30 participants',
                style: ThemeDataCustom.calendarEventWidgetText().bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    var _bottomRightYamaLogoAvatar = Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('lib/assets/images/logo_2.png'),
      ),
    );

    var _bottomRightOwnerAvatar = Align(
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
                                _bottomRightYamaLogoAvatar,
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
