import 'package:app/middleware/api/support_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  SupportApi _api;

  SupportService() {
    _api = new SupportApi();
  }

  _generateListOfItems(Future<QuerySnapshot> snapshot) async {
    var faqItems = [];
    QuerySnapshot s = await snapshot;
    for (DocumentSnapshot item in s.docs) {
      faqItems.add(item);
    }
    return faqItems;
  }

  Future getEnglishFaqList() async {
    return _generateListOfItems(_api.getEnglishFaqData());
  }
  
  Future getJapaneseFaqList() async {
    return _generateListOfItems(_api.getJapaneseFaqData());
  }
}
