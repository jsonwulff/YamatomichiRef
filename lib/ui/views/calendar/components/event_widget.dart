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
        height: MediaQuery.of(context).size.height * 0.15,
      ),
    );

    // TODO make text go ... when to long
    var _title = Text(
      title,
      style: _theme.textTheme.headline3,
      overflow: TextOverflow.ellipsis,
    );

    var _categoryChip = Transform(
      transform: Matrix4.identity()..scale(0.8),
      child: Chip(
        label: Text(
          'Type of event',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    var _lecationDateParticipants = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Color.fromRGBO(81, 81, 81, 1)),
            Text(
              'Hokkaido, Japan',
              style: _theme.textTheme.bodyText2,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.calendar_today, color: Color.fromRGBO(81, 81, 81, 1)),
            Text(
              formatCalendarDateTime(context, startDate, endDate),
              style: _theme.textTheme.bodyText2,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.person, color: Color.fromRGBO(81, 81, 81, 1)),
            Text(
              '20/30 participants',
              style: _theme.textTheme.bodyText2,
            ),
          ],
        ),
      ],
    );

    var _bottomRightYamaLogoAvatar = Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
      ),
    );

    var _bottomRightOwnerAvatar = Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title,
                      _categoryChip,
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: _lecationDateParticipants,
                          ),
                          _bottomRightYamaLogoAvatar,
                          _bottomRightOwnerAvatar,
                        ],
                      ),
                    ],
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
