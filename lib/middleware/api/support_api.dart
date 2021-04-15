import 'package:cloud_firestore/cloud_firestore.dart';

class SupportApi {
  FirebaseFirestore _store;

  SupportApi({FirebaseFirestore store}) {
    store != null ? _store = store : _store = FirebaseFirestore.instance;
  }

  Future<QuerySnapshot> getData() async {
    return await _store.collection('supportFaqItems').get();
  }

  Future<QuerySnapshot> getEnglishFaqData() async {
    return await _store
        .collection('faqItems')
        .doc('languages')
        .collection('english')
        .get();
  }

  Future<QuerySnapshot> getJapaneseFaqData() async {
    return await _store
        .collection('faqItems')
        .doc('languages')
        .collection('japanese')
        .get();
  }
}
