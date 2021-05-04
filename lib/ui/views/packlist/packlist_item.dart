import 'dart:math';

import 'package:app/constants/constants.dart';
import 'package:app/middleware/api/packlist_api.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PacklistItemView extends StatefulWidget {
  PacklistItemView({
    Key key,
    this.id,
    this.title,
    this.weight,
    this.items,
    this.amountOfDays,
    this.tag,
    this.createdBy,
    this.mainImageUrl,
  }) : super(key: key);
  final String id;
  final String title;
  final String weight;
  final String items;
  final String amountOfDays;
  final String tag;
  final String createdBy;
  final String mainImageUrl;

  @override
  _PacklistItemViewState createState() => _PacklistItemViewState();
}

class _PacklistItemViewState extends State<PacklistItemView> {
  PacklistNotifier packlistNotifier;
  UserProfileService _userProfileService;
  UserProfile _user;

  final _random = new Random();

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    setup();
  }

  Future<void> setup() async {
    _user = await _userProfileService
        .getUserProfile(widget.createdBy)
        .whenComplete(() => setState(() {}));
    // print(_user.imageUrl);
    // setState(() {});
  }

  openPacklist(BuildContext context) async {
    await getPacklistAPI(widget.id, packlistNotifier);
    Navigator.pushNamed(context, '/packListSpecific');
  }

  Chip _chipForTag() {
    return Chip(
        backgroundColor: Colors.blue,
        label: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            this.widget.tag,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  // TODO : super funky solution ..
  _userAvatar() {
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: CircleAvatar(
        child: _user.imageUrl == null
            ? Text(
                _user.firstName[0] + _user.lastName[0],
                style: TextStyle(fontSize: 40, color: Colors.white),
              )
            : null,
        backgroundColor:
            profileImageColors[_random.nextInt(profileImageColors.length)],
        backgroundImage:
            _user.imageUrl != null ? NetworkImage(_user.imageUrl) : null,
        radius: 25.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    packlistNotifier = Provider.of<PacklistNotifier>(context, listen: false);
    var _theme = Theme.of(context);
    var _media = MediaQuery.of(context);

    var _title = Container(
      width: _media.size.width * 0.5,
      child: Text(
        this.widget.title,
        style: _theme.textTheme.headline3,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.mainImageUrl),
                ),
              ),
              height: 220.0,
              child: InkWell(
                onTap: () {
                  openPacklist(context);

                  // Navigator.pushNamed(
                  //     context, packlistSpecificRoute); // Navigate to packlist
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: _chipForTag()),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          _userAvatar(),
                          Container(
                            margin: EdgeInsets.only(left: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _title,
                                Row(
                                  children: [
                                    Text(this.widget.amountOfDays + ' days / '),
                                    Text(this.widget.weight + 'g in total / '),
                                    Text(this.widget.items + ' items'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
