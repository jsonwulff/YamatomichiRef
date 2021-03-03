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

  MaterialApp appCreator(Widget widget) {
    return MaterialApp(
        home: Scaffold(
      body: widget,
    ));
  }

  testWidgets(
      'Create text input form field with labelText: Full Name, iconData: Icons.person',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      appCreator(
        TextInputFormFieldComponent(
          nameController,
          validator,
          label,
          iconData: icon,
        ),
      ),
    );

    final labelTextFinder = find.text(label);
    final iconDataFinder = find.byIcon(icon);

    expect(labelTextFinder, findsOneWidget);
    expect(iconDataFinder, findsOneWidget);
  });

  testWidgets(
      'Given input text of Satoshi Nakamoto: no error is shown on text on validate, name being set to Satoshi Nakamoto',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      appCreator(
        TextInputFormFieldComponent(
          nameController,
          validator,
          label,
          iconData: icon,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), nameToSet);

    final noNameEnteredFinder = find.text('Please enter your name');

    // TODO: find a better way of checking this
    expect(noNameEnteredFinder.toString(),
        'zero widgets with text "Please enter your name" (ignoring offstage widgets)');
    expect(nameController.text, nameToSet);
  });
}
