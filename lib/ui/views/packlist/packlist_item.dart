import 'package:app/middleware/api/packlist_api.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PacklistItemView extends StatelessWidget {
  PacklistItemView({
    Key key,
    this.id,
    this.title,
    this.weight,
    this.items,
    this.amountOfDays,
    this.description,
  }) : super(key: key);
  final String id;
  final String title;
  final String weight;
  final String items;
  final String amountOfDays;
  final String description;
  PacklistNotifier packlistNotifier;

  openPacklist(BuildContext context) async {
    await getPacklistAPI(id, packlistNotifier);
    Navigator.pushNamed(context, '/packlist');
  }

  Chip _chipForTag() {
    return Chip(
        backgroundColor: Colors.blue,
        label: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "Tag (STATIC)",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  CircleAvatar _userAvatar() {
    return CircleAvatar(
      backgroundImage: NetworkImage(
          "https://pyxis.nymag.com/v1/imgs/7ad/fa0/4eb41a9408fb016d6eed17b1ffd1c4d515-07-jon-snow.rsquare.w330.jpg"),
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
        title,
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
                  image: NetworkImage(
                      "https://images.squarespace-cdn.com/content/v1/5447ce79e4b04184cfa2c66b/1510510844786-D30FRFBSALN1QE3SWIV6/ke17ZwdGBToddI8pDm48kJUlZr2Ql5GtSKWrQpjur5t7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z5QPOohDIaIeljMHgDF5CVlOqpeNLcJ80NK65_fV7S1UfNdxJhjhuaNor070w_QAc94zjGLGXCa1tSmDVMXf8RUVhMJRmnnhuU1v2M8fLFyJw/BIKEPACKING-GEAR-LIST-PACK-LIST-SCANDINAVIA-GUSTAV-THUESEN-1.jpg"),
                ),
              ),
              height: 220.0,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, packlistSpecificRoute); // Navigate to packlist
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
                          Column(
                            children: [
                              _title,
                              Row(
                                children: [
                                  Text("Days (STATIC)"),
                                  Text("Weight (STATIC)"),
                                  Text("Items (STATIC)"),
                                ],
                              )
                            ],
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
