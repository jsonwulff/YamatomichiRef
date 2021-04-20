import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:app/middleware/api/support_api.dart';
import 'package:app/middleware/firebase/support_service.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  SupportService _supportService;
  SupportApi _supportApi;
  MockFirestoreInstance _firestore;

  setUp(() async {
    _firestore = MockFirestoreInstance();
    _supportApi = SupportApi(store: _firestore);

    _supportService = new SupportService(api: _supportApi);
  });

  group('Tests of the faq functions', () {
    test('Given a proper API getEnglishFaqList returns a list containing 1 faq',
        () async {
      _firestore
          .collection('faqItems')
          .doc('languages')
          .collection('english')
          .add({
        'title': 'title 1',
        'body': 'body 1',
      });

      var data = await _supportService.getEnglishFaqList();
      
      expect(data.length, 1);
    });
    
    test('Given a proper API getEnglishFaqList returns a list containing 1 faq',
        () async {
      _firestore
          .collection('faqItems')
          .doc('languages')
          .collection('japanese')
          .add({
        'title': 'title 1',
        'body': 'body 1',
      });

      var data = await _supportService.getJapaneseFaqList();
      
      expect(data.length, 1);
    });
  });
}
