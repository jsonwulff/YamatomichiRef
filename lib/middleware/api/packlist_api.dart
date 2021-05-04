import 'dart:io';

import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore _store = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;
RegExp _imageExpression = RegExp(r"^(\d+)\.png$");

changeSource(FirebaseFirestore store) {
  _store = store;
}

addPacklistToFirestore(Packlist data) async {
  Map<String, dynamic> newPacklist = data.toMap();

  CollectionReference packlists = _store.collection('packlists');

  DocumentReference ref = await packlists.add(newPacklist);
  return ref.id;
}

addGearItem(GearItem data, String packlistID, String gearCategory) async {
  Map<String, dynamic> newGearItem = data.toMap();

  CollectionReference gearCategoryItems =
      _store.collection('packlists').doc(packlistID).collection(gearCategory);

  DocumentReference ref = await gearCategoryItems.add(newGearItem);
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

getGearItemsInCategoryAPI(String packlistID, String gearCategory) async {
  QuerySnapshot gearQuery = await _store
      .collection('packlists')
      .doc(packlistID)
      .collection(gearCategory)
      .get();
  List<GearItem> _gearItems = [];
  for (QueryDocumentSnapshot snapshot in gearQuery.docs)
    _gearItems.add(GearItem.fromFirestore(snapshot));

  return _gearItems;
}

getPackListsAPI() async {
  QuerySnapshot snapshot =
      await _store.collection('packlists').orderBy("createdAt").get();

  List<Packlist> _packlistCollection = [];

  snapshot.docs.forEach((document) {
    Packlist packlist = Packlist.fromMap(document.data());
    _packlistCollection.add(packlist);
  });

  return _packlistCollection;
}

getUserPacklistAPI(String userID) async {
  QuerySnapshot _snapshot = await _store
      .collection('packlists')
      .where('createdBy', isEqualTo: userID)
      .get();

  List<Packlist> _packlists = [];

  for (QueryDocumentSnapshot _doc in _snapshot.docs)
    _packlists.add(Packlist.fromFirestore(_doc));

  return _packlists;
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

uploadImage(File data, Packlist packlist) async {
  String time = DateTime.now()
      .toString()
      .replaceAll(':', '')
      .replaceAll('/', '')
      .replaceAll(' ', '')
      .replaceAll('-', '');
  String path = 'packlistImages/${packlist.id}/$time.jpg';
  Reference dir = _storage.ref(path);
  await dir.putFile(data);
  return path;
}
