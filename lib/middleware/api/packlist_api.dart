import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: unused_element
FirebaseFirestore _store = FirebaseFirestore.instance;

changeSource(FirebaseFirestore store) {
  _store = store;
}

addPacklistToFirestore(Map<String, dynamic> data) async {
  //List<String> foo = List.from(data['participants']);

  Packlist newPacklist = Packlist();
  newPacklist.title = data['title'];
  newPacklist.amountOfDays = data['amountOfDays'];
  newPacklist.season = data['season'];
  newPacklist.tag = data['tag'];
  newPacklist.description = data['description'];
  newPacklist.createdAt = Timestamp.now();
  newPacklist.updatedAt = Timestamp.now();
  newPacklist.carrying = data['carrying'];
  newPacklist.sleepingGear = data['sleepingGear'];
  newPacklist.clothesPacked = data['clothesPacked'];
  newPacklist.clothesWorn = data['clothesWorn'];
  newPacklist.foodAndCooking = data['foodAndCooking'];
  newPacklist.other = data['other'];
  newPacklist.createdBy = data['createdBy']; //currentUser
  newPacklist.endorsedHighlighted = data['endorsedHighlighted'];
  newPacklist.allowComments = data['allowComments'];
  newPacklist.imageUrl = data['imageUrl'];
  //newPacklist.mainImage = data['mainImage'];

  // newPacklist.mainImage = data['mainImage']; MAYBE THIS SHOULD BE HERE??

  CollectionReference packlists = _store.collection('packlists');

  DocumentReference ref = await packlists.add(newPacklist.toMap());
  await packlists.doc(ref.id).update({
    "id": ref.id,
  });
  return ref.id;
}

//TODO : check if this not being Async is the problem
getPacklistAsStream(String packlistID) {
  return _store.collection('packlists').doc(packlistID).snapshots();
}

//TODO : AND this is som Copy paste jank/ the right way
getPacklistAsStream2(String packlistID) async {
  print('1,5');
  var stream = _store.collection('packlists').doc(packlistID).snapshots();
  print('2');
  return stream;
}

getPacklistAPI(String packlistID, PacklistNotifier packlistNotifier) async {
  DocumentSnapshot snapshot =
      await _store.collection('packlists').doc(packlistID).get();
  Packlist packlist = Packlist.fromFirestore(snapshot);
  packlistNotifier.packlist = packlist;
  print('getPacklist called');
}

updatePacklistAPI(Packlist packlist, Map<String, dynamic> map) async {
  CollectionReference packlistRef = _store.collection('packlists');
  packlist.updatedAt = Timestamp.now();
  await packlistRef
      .doc(packlist.id)
      .update(map)
      .then((value) => {print('updatePacklist() called')});
}

deletePacklistAPI(Packlist packlist) async {
  print('deletePacklist() begun');
  CollectionReference packlistRef = _store.collection('packlists');
  await packlistRef.doc(packlist.id).delete().then((value) {
    print("packlist deleted");
  });
}

getPackListsAPI(PacklistNotifier packlistNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('packLists').get();

  List<Packlist> _packlistCollection = [];

  snapshot.docs.forEach((document) {
    Packlist packlist = Packlist.fromMap(document.data());
    _packlistCollection.add(packlist);
  });
}

getGearItemsForPacklistAPI(
    PacklistNotifier packlistNotifier, String packlistId) async {
  //TODO evaluate: the cast might be wrong. But this feature is not yet fully implemented

  // ignore: unused_local_variable
  // QuerySnapshot snapshot = (await FirebaseFirestore.instance.collection('packLists/$packlistId/')) as QuerySnapshot;
}
