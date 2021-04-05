import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: the widget isn't cleared after each test
void main() {
  bool returnVal;

  MaterialApp appCreator() {
    return MaterialApp(
      home: Material(
        child: Builder(
          builder: (BuildContext context) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  returnVal = await simpleChoiceDialog(context, 'test');
                },
                child: Text('testDialog'),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('SimpleChoiceDialog returns : false, if answered : no', (WidgetTester tester) async {
    await tester.pumpWidget(appCreator());
    await tester.tap(find.text('testDialog'));
    await tester.pumpAndSettle();

    expect(returnVal, null);

    await tester.tap(find.text('No'));

    expect(returnVal, false);
    returnVal = null;
  });

  testWidgets('SimpleChoiceDialog returns : true, if answered : yes', (WidgetTester tester) async {
    await tester.pumpWidget(appCreator());
    await tester.tap(find.text('testDialog'));
    await tester.pumpAndSettle();

    expect(returnVal, null);

    await tester.tap(find.text('Yes'));

    expect(returnVal, true);
    returnVal = null;
  });
}
