import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/material.dart';

class StepperWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  DateTime selectedDate = DateTime.now();

  List<Step> steps = [
    Step(
      title: const Text('Event details'),
      isActive: true,
      state: StepState.editing,
      content: Column(children: <Widget>[
        TextInputFormFieldComponent(
          TextEditingController(),
          AuthenticationValidation.validateNotNull, //check dis pls
          'Event title',
          iconData: Icons.title,
        ),
        const Text('Category'), //choices
        const Text('Start date and time'),
        const Text('End date and time'),
        const Text('Deadline for signup'),
      ]),
    ),
    Step(
      title: const Text('Location'),
      isActive: false,
      state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Country'), //autofill
        const Text('Region'), //dropdown
        const Text('Meeting point???'),
        const Text('Dissolution point???'),
      ]),
    ),
    Step(
      title: const Text('Participants'),
      isActive: false,
      state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Min. participants'), // default 0
        const Text('Max. participants'), // default 20+
        const Text('Participation requirements'), //string
        const Text('Equipment') //string
      ]),
    ),
    Step(
      title: const Text('Payment'),
      isActive: false,
      state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Price'),
        const Text('Payment options'),
      ]),
    ),
    Step(
      title: const Text('Desciption'),
      isActive: false,
      state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Add photo'),
        const Text('Description'),
      ]),
    ),
  ];

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < (steps.length - 1)
        ? setState(() => _currentStep += 1)
        // ignore: unnecessary_statements
        : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create new event')),
        body: Stepper(
          type: stepperType,
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: steps,
        ));
  }
}
