import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/packlist_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/views/packlist/packlist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // Use localization

class PacklistNewView extends StatefulWidget {
  PacklistNewView({Key key}) : super(key: key);

  @override
  _PacklistNewState createState() => _PacklistNewState();
}

class _PacklistNewState extends State<PacklistNewView> {
  List<PacklistItemView> allPacklistItems = [];
  List<PacklistItemView> favourites = [];
  PacklistService db = PacklistService();
  PacklistNotifier packlistNotifier;
  UserProfileNotifier userProfileNotifier;

  ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    packlistNotifier = Provider.of<PacklistNotifier>(context, listen: false);
    //getStaticPaclist();
    userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier).then((e) {
        getPacklists();
      });
    } else {
      getPacklists();
    }
  }

  getPacklists() {
    db.getPacklists().then((e) => {
          allPacklistItems.clear(),
          e.forEach(
              (element) => {createPacklistItem(element, allPacklistItems)}),
          updateState(),
        });
    db.getFavoritePacklists(userProfileNotifier.userProfile).then((value) => {
          favourites.clear(),
          value.forEach((element) => {createPacklistItem(element, favourites)}),
          updateState(),
        });
  }

  void updateState() {
    setState(() {});
  }

  createPacklistItem(Packlist data, List list) {
    if (data != null) { // this will handle packlists that have been deleted, but are still in the favorite list
    var packlistItem = PacklistItemView(
        id: data.id,
        title: data.title,
        weight: data.totalWeight.toString(),
        items: data.totalAmount.toString(),
        amountOfDays: data.amountOfDays,
        tag: data.tag,
        createdBy: data.createdBy,
        mainImageUrl: data.imageUrl[0],
      );
      list.add(packlistItem);
    }
  }

  _favouritesTab() {
    return Container(
        child: ListView.builder(
            itemCount: favourites.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: favourites[index],
              );
            }));
  }

  _browseTab() {
    return Container(
        child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemCount: allPacklistItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: allPacklistItems[index],
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 0.0,
                bottom: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  labelStyle: Theme.of(context).textTheme.headline3,
                  tabs: [
                    Tab(text: texts.favourites),
                    Tab(text: texts.browse),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _favouritesTab(),
              _browseTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '99problemsbutabitchaintone',
            onPressed: () {
              packlistNotifier.remove();
              Navigator.pushNamed(context, '/createPacklist');
            },
            child: Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: '98problemsbutabitchaintone',
              onPressed: () {
                Navigator.pushNamed(context, '/filtersForPacklist');
              },
              child: Icon(Icons.sort_outlined),
            ),
          ),
        ],
      ),

      // TODO INSERT BOTTOM NAV BAR
    );
  }
}
