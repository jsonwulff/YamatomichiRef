import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TextEditingController nameController = TextEditingController();
  String nameToSet = 'Satoshi Nakamoto';
  var validator = AuthenticationValidation.validateName;
  String label = 'Full Name';
  IconData icon = Icons.person;
  String buttonText = 'Send';

  // ignore: unused_element
  setUp() {
    nameController = TextEditingController();
  }

  // MaterialApp appCreator(Widget widget) {
  //   final formKey = new GlobalKey<FormState>();

  //   return MaterialApp(
  //     home: Scaffold(
  //       body: Form(
  //         key: formKey,
  //         child: Column(
  //           children: [
  //             widget,
  //             ElevatedButton(
  //               onPressed: () {
  //                 formKey.currentState.save();
  //               },
  //               child: Text(buttonText),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  MaterialApp appCreatorStandardSingleController() {
    final formKey = new GlobalKey<FormState>();

    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              TextInputFormFieldComponent(
                nameController,
                validator,
                label,
                iconData: icon,
              ),
              ElevatedButton(
                onPressed: () {
                  formKey.currentState.save();
                  formKey.currentState.validate();
                  formKey.currentState.save();
                },
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('Basic functinoality tests', () {
    testWidgets(
        'Create text input form field with labelText: Full Name, iconData: Icons.person',
        (WidgetTester tester) async {
      await tester.pumpWidget(appCreatorStandardSingleController());

      final labelTextFinder = find.text(label);
      final iconDataFinder = find.byIcon(icon);

      expect(labelTextFinder, findsOneWidget);
      expect(iconDataFinder, findsOneWidget);
    });

    testWidgets(
        'Given input text of Satoshi Nakamoto: no error is shown on text on validate, name being set to Satoshi Nakamoto',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        appCreatorStandardSingleController(),
      );

      await tester.enterText(find.byType(TextFormField), nameToSet);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Please enter your name'), findsNothing);
      expect(nameController.text, nameToSet);
    });

    testWidgets('Given an empty input on name shows error code',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        appCreatorStandardSingleController(),
      );

      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(nameController.text, '');
    });
  });
}
