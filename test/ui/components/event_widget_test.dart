import 'package:app/ui/components/calendar/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MaterialApp appCreatorStandard() {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            EventWidget(
              title: "TestEvent",
              description: "Event used for testing",
              startDate: DateTime(2017, 9, 7, 17, 30),
              endDate: DateTime(2017, 9, 10, 17, 30),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('Create event widget, shows title and description',
      (WidgetTester tester) async {
    await tester.pumpWidget(appCreatorStandard());

    final labelTextFinder1 = find.text('TestEvent');
    final labelTextFinder2 = find.text('Event used for testing');

    expect(labelTextFinder1, findsOneWidget);
    expect(labelTextFinder2, findsOneWidget);
  });

  // testWidgets('Give fromDate before today shows error code',
  //     (WidgetTester tester) async {
  //   throw UnimplementedError();
  // });

  // testWidgets('Give toDate before today shows error code',
  //     (WidgetTester tester) async {
  //   throw UnimplementedError();
  // });

  // testWidgets('Give toDate before fromDate shows error code',
  //     (WidgetTester tester) async {
  //   throw UnimplementedError();
  // });

  // testWidgets('Missing data shows error code', (WidgetTester tester) async {
  //   throw UnimplementedError();
  // });
}
