import 'package:app/middleware/api/support_api.dart';
import 'package:app/middleware/models/faq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  SupportApi _api;

  Stream<List<FaqItem>> faqItems() async* {
    var faqItems = [];
    await for (QuerySnapshot s in _api.getFaqItemsStream()) {
      for (DocumentSnapshot item in s.docs) {
        faqItems.add(FaqItem.fromMap(item.data()));
      }
    }
    yield faqItems;
  }
}