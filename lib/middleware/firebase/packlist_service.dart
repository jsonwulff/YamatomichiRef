import 'dart:async';
import 'package:app/middleware/api/packlist_api.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacklistService {
  //final FirebaseFirestore _store = FirebaseFirestore.instance;
  CollectionReference packlists;
  FirebaseFirestore _store = FirebaseFirestore.instance;
  UserProfileService userProfileService = UserProfileService();

  changeSource(FirebaseFirestore store) {
    _store = store;
  }

  PacklistService() {
    packlists = _store.collection('packlists');
  }

  Future<String> addNewPacklist(
      Map<String, dynamic> data, PacklistNotifier packlistNotifier) async {
    var ref = await addPacklistToFirestore(data);
    if (ref != null) await getPacklistAPI(ref, packlistNotifier);
    return 'Success';
  }

  Future<List<Map<String, dynamic>>> getPacklists() async {
    var snaps = await packlists.orderBy('createdAt').get();
    List<Map<String, dynamic>> packlistslist = [];
    snaps.docs.forEach((element) => packlistslist.add(element.data()));
    return packlistslist;
  }

  getSnapshots() {
    return packlists.snapshots();
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

  Future<void> deletePacklist(Packlist packlist) async {
    await deletePacklistAPI(packlist);
  }

  Future<void> updatePacklist(Packlist packlist, Map<String, dynamic> map,
      Function packlistUpdated) async {
    await updatePacklistAPI(packlist, map);
    packlistUpdated(packlist);
  }

  Future<bool> highlightPacklist(
      Packlist packlist, PacklistNotifier packlistNotifier) async {
    print('highlight packlist begun');
    if (packlist.endorsedHighlighted) {
      await updatePacklistAPI(packlist, {'endorsedHighlighted': false});
      print('packlist highlighted set to false');
      //highlight(event, false);
      await getPacklistAPI(packlist.id, packlistNotifier);
      return true;
    } else {
      await updatePacklistAPI(packlist, {'endorsedHighlighted': true});
      print('packlist highlighted set to true');
      //highlight(event, true);
      await getPacklistAPI(packlist.id, packlistNotifier);
      return true;
    }
  }

  String getDocumentRef(String packlistID) {
    return packlists.doc(packlistID).toString();
  }
}
