@Skip('DEPRECATED')
import 'package:app/ui/views/calendar/event_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/create_app_helper.dart';
import '../../../middleware/firebase/setup_firebase_auth_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Ensure everything from event is rendered with normal user',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(CreateAppHelper.generateYamatomichiTestApp((EventView())));

    //expect(find.byKey(Key('eventPicture')), findsOneWidget);
    //expect(find.byKey(Key('userPicture')), findsOneWidget);
    //expect(find.byKey(Key('userName')), findsOneWidget);
    expect(find.byKey(Key('eventTitle')), findsOneWidget);
    expect(find.byKey(Key('eventRegionAndCountrt')), findsOneWidget);
    expect(find.byKey(Key('highlightedText')), findsOneWidget);
    expect(find.byKey(Key('joinButton')), findsOneWidget);
    expect(find.byKey(Key('eventPrice')), findsOneWidget);
    expect(find.byKey(Key('eventPayment')), findsOneWidget);
    expect(find.byKey(Key('eventStartAndMeeting')), findsOneWidget);
    expect(find.byKey(Key('eventEndAndDissolution')), findsOneWidget);
    expect(find.byKey(Key('eventDescription')), findsOneWidget);
    expect(find.byKey(Key('eventRequirements')), findsOneWidget);
    expect(find.byKey(Key('eventEquipment')), findsOneWidget);
    expect(find.byKey(Key('highlightButton')), findsOneWidget);
    expect(find.byKey(Key('editButton')), findsOneWidget);
    expect(find.byKey(Key('deleteButton')), findsOneWidget);
  });
}
