import 'dart:async';
import 'package:app/middleware/api/packlist_api.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';

class PacklistService {
  PacklistService();

  Future<String> addNewPacklist(
      Packlist data, PacklistNotifier packlistNotifier) async {
    String ref = await addPacklistToFirestore(data);
    if (ref != null) {
      data.id = ref;
      packlistNotifier.packlist = data;
    }
    return 'Success';
  }

  Future<List<Packlist>> getPacklists() async {
    return await getPackListsAPI();
  }

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
