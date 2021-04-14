import 'package:app/middleware/api/support_api.dart';
import 'package:app/middleware/models/faq.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  SupportApi _api;

  SupportService() {
    _api = new SupportApi();
  }

  Future getFaqItems() async {
    var faqItems = [];
    QuerySnapshot s = await _api.getData();
    for (DocumentSnapshot item in s.docs) {
      faqItems.add(item);
    }
    return faqItems;
  }
}
