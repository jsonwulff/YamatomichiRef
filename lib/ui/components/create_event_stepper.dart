import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/material.dart';
import 'package:fa_stepper/fa_stepper.dart';

class StepperWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();

  List<FAStep> steps = [
    FAStep(
      title: const Text('Event details'),
      isActive: true,
      //state: getState(),
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
    FAStep(
      title: const Text('Location'),
      isActive: true,
      //state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Country'), //autofill
        const Text('Region'), //dropdown
        const Text('Meeting point???'),
        const Text('Dissolution point???'),
      ]),
    ),
    FAStep(
      title: const Text('Participants'),
      isActive: true,
      //state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Min. participants'), // default 0
        const Text('Max. participants'), // default 20+
        const Text('Participation requirements'), //string
        const Text('Equipment') //string
      ]),
    ),
    FAStep(
      title: const Text('Payment'),
      isActive: true,
      //state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Price'),
        const Text('Payment options'),
      ]),
    ),
    FAStep(
      title: const Text('Desciption'),
      isActive: true,
      //state: StepState.editing,
      content: Column(children: <Widget>[
        const Text('Add photo'),
        const Text('Description'),
      ]),
    ),
  ];

  FAStepstate getState() {
    if (_currentStep >= 2)
      return FAStepstate.complete;
    else
      return FAStepstate.disabled;
  }

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
        body: FAStepper(
          type: FAStepperType.horizontal,
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: steps,
        ));
    /*body: FAStepper(
          steps: <FAStep>[
                     FAStep(
                      title: new Text('Account'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email Address'),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0 ?
                      FAStepstate.complete : FAStepstate.disabled,
                    ),
        )*/
  }
}
