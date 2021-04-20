import 'package:app/assets/theme/theme_data_custom.dart';
import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/shared/formatters/datetime_formatter.dart';
import 'package:app/ui/views/calendar/components/material_custom.dart';
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
      this.endDate})
      : super(key: key);
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

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

    var _leftPicture = ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
      child: Image.network(
        'https://picsum.photos/250?image=9',
        height: _media.size.height * 0.15,
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

    var _categoryChip2 = Container(
      height: _media.size.height * 0.03,
      child: Chip(
        label: Text(
          'Type of event',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    var _categoryChip3 = Chip(
      label: Text(
        'Type of event',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    var _lecationDateParticipants = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
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
              ),
            ],
          ),
        ),
      ],
    );

    var _bottomRightYamaLogoAvatar = Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        radius: _media.size.width * 0.035,
        backgroundImage: NetworkImage(
            "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
      ),
    );

    var _bottomRightOwnerAvatar = Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        radius: _media.size.width * 0.035,
        backgroundImage: NetworkImage(
            "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
      ),
    );

    return TextButton(
        child: MaterialCustom.standard(
          Container(
            width: _media.size.width * 0.9,
            child: InkWell(
              child: Row(
                children: [
                  _leftPicture,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title,
                        _categoryChip,
                        // _categoryChip2,
                        // _categoryChip3,
                        Container(
                          width: _media.size.width * 0.53,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _lecationDateParticipants,
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: _bottomRightYamaLogoAvatar,
                                  ),
                                  _bottomRightOwnerAvatar,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onPressed: () {
          openEvent(context);
        });
  }
}
