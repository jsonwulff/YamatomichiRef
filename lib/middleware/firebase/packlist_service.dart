import 'dart:async';
import 'dart:io';
import 'package:app/middleware/api/packlist_api.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PacklistService {
  PacklistService({BuildContext context}) {
    // texts = AppLocalizations.of(context);
  }

  dynamic texts;

  final List<String> _subcollections = [
    "carrying",
    "clothesPacked",
    "clothesWorn",
    "foodAndCookingEquipment",
    "other",
    "sleepingGear"
  ];

  Future<dynamic> addNewPacklist(Packlist data, PacklistNotifier packlistNotifier) async {
    List<Future<String>> imageFutures = [];
    for (File image in data.images) {
      imageFutures.add(uploadImageAPI(image, data));
    }

    if (imageFutures.isNotEmpty)
      await Future.wait(imageFutures).then((urls) => data.imageUrl = urls);

    String ref = await addPacklistToFirestore(data);
    if (ref != null) {
      data.id = ref;
      getPacklistAPI(ref, packlistNotifier);
      print('Packlistnotifier: ' + packlistNotifier.packlist.toString());
    }

    List<Future<dynamic>> gearFutures = [];
    for (Tuple2<String, List<GearItem>> gearItems in data.gearItemsAsTuples) {
      for (GearItem item in gearItems.item2) {
        gearFutures.add(addGearItem(item, ref, gearItems.item1).then((gearRef) {
          item.id = gearRef;
          return gearRef;
        }));
      }
    }

    await Future.wait(gearFutures);
    return 'Success';
  }

  Future<dynamic> addNewImagesToPacklist(Packlist packlist, List<File> images) async {
    List<Future<String>> imageFutures = [];
    for (File image in images) {
      imageFutures.add(uploadImageAPI(image, packlist));
    }

    List<String> list = [];

    if (imageFutures.isNotEmpty) {
      await Future.wait(imageFutures).then((urls) => list = urls);
    }

    return list;
  }

  Future<dynamic> addGearItems(
      List<Tuple2<String, GearItem>> listToBeAdded, Packlist packlist) async {
    List<Future<dynamic>> gearFutures = [];

    for (Tuple2<String, GearItem> item in listToBeAdded) {
      gearFutures.add(addGearItem(item.item2, packlist.id, item.item1).then((gearRef) {
        item.item2.id = gearRef;
        return gearRef;
      }));
    }

    await Future.wait(gearFutures);
    return 'New GearItems added';
  }

  Future<List<GearItem>> getGearItemsInCategory(Packlist packlist, String gearCategory) async {
    return await getGearItemsInCategoryAPI(packlist.id, gearCategory);
  }

  Future<List<Tuple3<String, int, List<GearItem>>>> getAllGearItems(
      Packlist packlist, List<Tuple2<String, String>> categories) async {
    List<Tuple3<String, int, List<GearItem>>> itemsList = [];

    for (var category in categories) {
      List<GearItem> items = await getGearItemsInCategory(packlist, category.item2);

      int totalWeightForCategory = 0;

      for (GearItem item in items) {
        totalWeightForCategory += item.amount * item.weight;
      }

      itemsList.add(Tuple3(category.item1, totalWeightForCategory, items));
    }

    return itemsList;
  }

  Future<dynamic> updateGearItems(
      List<Tuple2<String, GearItem>> gearItems, Packlist packlist) async {
    // List<Future<void>> updateFutures;
    // for (Tuple2 item in gearItems) {
    //   updateFutures.add(value)
    // }

    gearItems.forEach((element) async {
      await updateGearItemAPI(packlist, element.item2, element.item1);
    });

    return 'gearitems updated';
  }

  Future<dynamic> deleteGearItems(
      List<Tuple2<String, GearItem>> gearItems, Packlist packlist) async {
    gearItems.forEach((element) async {
      await deleteGearItemAPI(packlist, element.item2, element.item1);
    });

    return 'gearitems deleted';
  }

  Future<List<Packlist>> getPacklists() async {
    return await getPackListsAPI();
  }

  Future<List<Packlist>> getUserPacklists(UserProfile user) async {
    return await getUserPacklistAPI(user.id);
  }

  Future<List<Packlist>> getFavoritePacklists(UserProfile user) async {
    return await getFavoritePacklistsAPI(user);
  }

  Future<void> deletePacklist(Packlist packlist) async {
    List<Future<void>> deleteFutures = [];
    for (String cat in _subcollections) {
      deleteFutures
          .add(getGearItemsInCategory(packlist, cat).then((list) => list.forEach((element) {
                deleteGearItemAPI(packlist, element, cat);
              })));
    }
    await Future.wait(deleteFutures);

    await deletePacklistAPI(packlist);
  }

  Future<void> updatePacklist(
      Packlist packlist, Map<String, dynamic> map, Function packlistUpdated) async {
    await updatePacklistAPI(packlist, map);
    //packlistUpdated(packlist);
  }

  // Future<bool> highlightPacklist(Packlist packlist, PacklistNotifier packlistNotifier) async {
  //   print('highlight packlist begun');
  //   if (packlist.endorsed) {
  //     await updatePacklistAPI(packlist, {'endorsed': false});
  //     print('packlist highlighted set to false');
  //     //highlight(event, false);
  //     await getPacklistAPI(packlist.id, packlistNotifier);
  //     return true;
  //   } else {
  //     await updatePacklistAPI(packlist, {'endorsed': true});
  //     print('packlist highlighted set to true');
  //     //highlight(event, true);
  //     await getPacklistAPI(packlist.id, packlistNotifier);
  //     return true;
  //   }
  // }

  dynamic uploadNewImageToPacklist(File picture, Packlist packlist) async {
    await uploadImageAPI(picture, packlist);
  }

  Future<void> deleteImage(String url, Packlist packlist) async {
    await deleteImageAPI(url, packlist);
  }

  Future<void> addTofavoritePacklist(UserProfile profile, Packlist packlist) async {
    if (profile.favoritePacklists == null) profile.favoritePacklists = [];
    profile.favoritePacklists.add(packlist.id);
    await updateUserProfile(profile, (e) {});
  }

  Future<void> removeFromFavoritePacklist(UserProfile profile, Packlist packlist) async {
    profile.favoritePacklists.remove(packlist.id);
    await updateUserProfile(profile, (e) {});
  }

/* Might be relevant in future
  Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    var snaps = await calendarEvents
        .where('startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date),
            isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
        .orderBy('startDate')
        .get();
    List<Map<String, dynamic>> events = [];

    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }
*/
/* Might be relevant in future
  // queries all events related to the provided user
  // both createdBy and participated in  
  Future<List<Map<String, dynamic>>> getEventsByUser(UserProfile user) async {
   var snapsCreatedByUser =
       await calendarEvents.where('createdBy', isEqualTo: user.id).get();
   var snapsParticipatedByUser = await calendarEvents
       .where('participants', arrayContains: user.id)
       .get();

   List<Map<String, dynamic>> events = [];
   snapsCreatedByUser.docs.forEach((element) => events.add(element.data()));
   snapsParticipatedByUser.docs.forEach((element) => events.add(element.data()));

   return events;
  }
*/

/*
  Stream<List<String>> getStreamOfParticipants(EventNotifier eventNotifier) async* {

  //Stream<List<String>> getStreamOfParticipants1(
  //    EventNotifier eventNotifier) async* {
    List<String> participants = [];
    Stream<DocumentSnapshot> stream = await getEventAsStream(eventNotifier.event.id);
    await for (DocumentSnapshot s in stream) {
      if (s.data() == null) return;
      participants = Event.fromMap(s.data()).participants.cast<String>();
      yield participants;
    }
  }*/
}
