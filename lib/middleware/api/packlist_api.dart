import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// ignore: unused_element
FirebaseFirestore _store = FirebaseFirestore.instance;

changeSource(FirebaseFirestore store) {
  _store = store;
}

getPackLists(PacklistNotifier packlistNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('packLists').get();

  List<Packlist> _packlistCollection = [];

  snapshot.docs.forEach((document) { 
    Packlist packlist = Packlist.fromMap(document.data());
    _packlistCollection.add(packlist);
  });
}

getGearItemsForPacklist(PacklistNotifier packlistNotifier, String packlistId) async {
  //TODO evaluate: the cast might be wrong. But this feature is not yet fully implemented
  // ignore: unused_local_variable
  // QuerySnapshot snapshot = (await FirebaseFirestore.instance.collection('packLists/$packlistId/')) as QuerySnapshot;
}

