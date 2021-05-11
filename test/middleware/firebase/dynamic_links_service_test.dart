import 'package:app/middleware/firebase/dynamic_links_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class BuildContextMock extends Mock implements BuildContext {}

main() {
  String testMail = 'satoshi@gmx.com';
  String invalidEmail = 'adamBackIsSatoshiNakamoto';

  group('Tests of generateResetPasswordCode', () {
    test('Given valied email, returns action code with said email', () {
      ActionCodeSettings result = DynamicLinkService.generateResetPasswordCode(testMail);

      expect(result.url.contains(testMail), true);
    });

    test('Given invalid email, returns format expection', () {
      expect(() => DynamicLinkService.generateResetPasswordCode(invalidEmail), throwsException);
    });
  });
}
