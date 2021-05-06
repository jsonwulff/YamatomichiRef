import 'dart:io';

import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore _store = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

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
}

getGearItemsInCategoryAPI(String packlistID, String gearCategory) async {
  QuerySnapshot gearQuery = await _store
      .collection('packlists')
      .doc(packlistID)
      .collection(gearCategory)
      .get();
  List<GearItem> gearItems = [];
  for (QueryDocumentSnapshot snapshot in gearQuery.docs)
    gearItems.add(GearItem.fromFirestore(snapshot));

  return gearItems;
}

getPackListsAPI() async {
  QuerySnapshot snapshot = await _store
      .collection('packlists')
      .where('private', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .get();

  List<Packlist> _packlistCollection = [];

  snapshot.docs.forEach((document) {
    Packlist packlist = Packlist.fromFirestore(document);
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

getFavoritePacklistsAPI(UserProfile profile) async {
  List<Future<Packlist>> futures = [];
  for (String id in profile.favoritePacklists ?? []) {
    futures.add(_store
        .collection('packlists')
        .doc(id)
        .get()
        .then((snapshot) => Packlist.fromFirestore(snapshot))
        .catchError((e) {
          print(e);
          return null;
        })
        );
  }

  return await Future.wait(futures);
}

getGearItemsForPacklistAPI(
    PacklistNotifier packlistNotifier, String packlistId) async {
  //TODO evaluate: the cast might be wrong. But this feature is not yet fully implemented

  // ignore: unused_local_variable
  // QuerySnapshot snapshot = (await FirebaseFirestore.instance.collection('packLists/$packlistId/')) as QuerySnapshot;
}

updatePacklistAPI(Packlist packlist, Map<String, dynamic> map) async {
  CollectionReference packlistRef = _store.collection('packlists');
  packlist.updatedAt = Timestamp.now();
  await packlistRef
      .doc(packlist.id)
      .update(map)
      .then((value) => {print('updatePacklist() called')});
}

updateGearItemAPI(Packlist packlist, GearItem gearItem, String category) async {
  DocumentReference ref = _store
      .collection('packlists')
      .doc(packlist.id)
      .collection(category)
      .doc(gearItem.id);
  await ref.update(gearItem.toMap()).then((_) {
    print('updateGearItem() called');
  });
}

deletePacklistAPI(Packlist packlist) async {
  CollectionReference packlistRef = _store.collection('packlists');
  await packlistRef.doc(packlist.id).delete().then((value) {
    print("packlist deleted");
  });
}

deleteGearItemAPI(Packlist packlist, GearItem gearItem, String category) async {
  DocumentReference ref = _store
      .collection('packlists')
      .doc(packlist.id)
      .collection(category)
      .doc(gearItem.id);
  await ref.delete();
}

Future<String> uploadImageAPI(File data, Packlist packlist) async {
  String url;
  String time = DateTime.now()
      .toString()
      .replaceAll(':', '')
      .replaceAll('/', '')
      .replaceAll(' ', '')
      .replaceAll('-', '');
  String path = 'packlistImages/${packlist.createdBy}/$time.jpg';
  Reference dir = _storage.ref().child(path);
  await dir.putFile(data).whenComplete(() async {
    url = await dir.getDownloadURL();
  });
  return url;
}

deleteImageAPI(String url, Packlist packlist) async {
  await _storage.ref(url).delete();
  packlist.imageUrl.remove(url);
  updatePacklistAPI(packlist, {'imageUrl': packlist.imageUrl});
}
