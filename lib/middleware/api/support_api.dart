import 'package:app/middleware/models/faq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: return either success or failure

// abstract class AtApi {
//   FirebaseFirestore _store;

//   addFaqItem();

//   getFaqItem();

//   updateFaqItem();

//   deleteFaqItem();
// }

class SupportApi {
  FirebaseFirestore _store;

  SupportApi({supportEvents, store}) {
    _store != null ? _store = store : _store = FirebaseFirestore.instance; 
  }

  Stream<QuerySnapshot> getFaqItemsStream() {
    return _store.collection('supportFaqItems').snapshots();    
  }
}
