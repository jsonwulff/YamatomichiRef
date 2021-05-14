import 'package:app/middleware/api/packlist_api.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/ui/shared/components/mini_avatar.dart';
import 'package:app/ui/views/packlist/packlist_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
  }

  Future<UserProfile> setup() async {
    return await _userProfileService.getUserProfile(widget.createdBy);
  }

  openPacklist(BuildContext context) async {
    await getPacklistAPI(widget.id, packlistNotifier);
    pushNewScreen(context, screen: PacklistPageView(), withNavBar: false);
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

  _userAvatar() {
    return FutureBuilder(
      future: setup(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MiniAvatar(user: snapshot.data);
        } else {
          return Container(
            alignment: Alignment(0.0, 0.0),
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.white,
            ),
          );
        }
      },
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
              height: 300.0,
              child: InkWell(
                onTap: () {
                  openPacklist(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.all(15.0), child: _chipForTag()),
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
                                    Text(
                                      this.widget.amountOfDays +
                                          ' days / ' +
                                          this.widget.weight +
                                          'g in total / ' +
                                          this.widget.items +
                                          ' items',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Text(this.widget.amountOfDays + ' days / '),
                                    // Text(this.widget.weight + 'g in total / '),
                                    // Text(this.widget.items + ' items'),
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
