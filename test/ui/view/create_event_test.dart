import 'package:app/ui/components/calendar/create_event_stepper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helper/create_app_helper.dart';
import '../../middleware/firebase/setup_firebase_auth_mock.dart';

class FirebaseMock extends Mock implements Firebase {}

void main() {
  setupFirebaseAuthMocks();
  StepperWidget stepper = StepperWidget();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Ensure everything from create event is rendered',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        CreateAppHelper.generateYamatomichiTestApp(StepperWidget()));

    expect(find.byKey(Key('event_title')), findsOneWidget);
    /* expect(find.byKey(Key('Support_ContactTitle')), findsOneWidget);
    expect(find.byKey(Key('Support_Contactsubtitle')), findsOneWidget);
    expect(find.byKey(Key('Support_ContactMailSubject')), findsOneWidget);
    expect(find.byKey(Key('Support_ContactMailBody')), findsOneWidget);
    expect(find.byKey(Key('Support_SendMailButton')), findsOneWidget);
    expect(find.byKey(Key('Support_faqTitle')), findsOneWidget);

    await tester.drag(find.byKey(Key('Support_faqTitle')), Offset(0, -300));
    await tester.pumpAndSettle();
    
    expect(find.byKey(Key('Support_ProductSupportTitle')), findsOneWidget);
    expect(find.byKey(Key('Support_ProductSupportButton')), findsOneWidget); */
  });
}
