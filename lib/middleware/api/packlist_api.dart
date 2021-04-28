import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _store = FirebaseFirestore.instance;

changeSource(FirebaseFirestore store) {
  _store = store;
}

addPacklistToFirestore(Packlist data) async {
  Map<String, dynamic> newPacklist = data.toMap();

  CollectionReference packlists = _store.collection('packlists');

  DocumentReference ref = await packlists.add(newPacklist);
  return ref.id;
}

getPacklistAsStream(String packlistID) {
  return _store.collection('packlists').doc(packlistID).snapshots();
}

getPacklistAPI(String packlistID, PacklistNotifier packlistNotifier) async {
  DocumentSnapshot snapshot =
      await _store.collection('packlists').doc(packlistID).get();
  Packlist packlist = Packlist.fromFirestore(snapshot);
  packlistNotifier.packlist = packlist;
  print('getPacklist called');
}

getPackListsAPI() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('packLists')
      .orderBy("createdAt")
      .get();

  List<Packlist> _packlistCollection = [];

  snapshot.docs.forEach((document) {
    Packlist packlist = Packlist.fromMap(document.data());
    _packlistCollection.add(packlist);
  });
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

getGearItemsForPacklistAPI(
    PacklistNotifier packlistNotifier, String packlistId) async {
  //TODO evaluate: the cast might be wrong. But this feature is not yet fully implemented

  // ignore: unused_local_variable
  // QuerySnapshot snapshot = (await FirebaseFirestore.instance.collection('packLists/$packlistId/')) as QuerySnapshot;
}
