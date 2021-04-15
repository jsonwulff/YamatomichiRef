import 'package:app/middleware/api/support_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  SupportApi _api;

  SupportService({SupportApi api}) {
    api != null ? _api = api : _api = new SupportApi();
  }

  Future<List<DocumentSnapshot>> _generateListOfItems(
      Future<QuerySnapshot> snapshot) async {
    List<DocumentSnapshot> faqItems = [];
    QuerySnapshot s = await snapshot;
    for (DocumentSnapshot item in s.docs) {
      faqItems.add(item);
    }
    return faqItems;
  }

  Future<List<DocumentSnapshot>> getEnglishFaqList() async {
    return _generateListOfItems(_api.getEnglishFaqData());
  }

  Future<List<DocumentSnapshot>> getJapaneseFaqList() async {
    return _generateListOfItems(_api.getJapaneseFaqData());
  }
}
