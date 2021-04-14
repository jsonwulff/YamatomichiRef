import 'package:app/middleware/api/support_api.dart';
import 'package:app/middleware/models/faq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  SupportApi _api;

  SupportService() {
    _api = new SupportApi();
  }

  Stream<FaqItem> faqItems() async* {
    // var faqItems = [];
    await for (QuerySnapshot s in _api.getFaqItemsStream()) {
      for (DocumentSnapshot item in s.docs) {
        yield FaqItem.fromMap(item.data());
        // faqItems.add(FaqItem.fromMap(item.data()));
      }
    }
    // yield faqItems;

    // _api.getFaqItemsStream().map((event) => for (var item in event.docs()) {

    // });
    // FaqItem.fromMap(event.docs()));
  }
}