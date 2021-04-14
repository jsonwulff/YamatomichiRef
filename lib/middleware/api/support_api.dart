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
  CollectionReference _supportEvents;
  FirebaseFirestore _store;

  SupportApi(this._supportEvents, this._store);

  getFaqItemsStream() {
    return _store.collection('supportFaqItems').snapshots();
    
    // var snapshot =
    //   await _store.collection('supportFaqItems').get();
    // FaqItem faqItem = FaqItem.fromFirestore(snapshot);
    // eventNotifier.event = event;
    // print('getEvent called');
    
    
    // var snaps = await _supportEvents.orderBy('title').get();
    // var faqItems = [];
    // snaps.docs.forEach((element) => faqItems.add(element.data()));
    // return faqItems;
  }
}
