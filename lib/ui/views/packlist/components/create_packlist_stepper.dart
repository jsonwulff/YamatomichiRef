import 'package:app/ui/shared/buttons/button.dart';
import 'package:flutter/material.dart';

class StepperDemo extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Step buildDetailsStep() {
    return Step(
      title: new Text('Details'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Amount of days'), // TODO : make dropdown
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Season'), // TODO : make dropdown
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Tags'), // TODO : make dropdown
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'), // TODO : make dropdown
          ),
        ],
      ),
      isActive: true,
      // state: step_contains_content_provied_by_user
      //     ? StepState.complete
      //     : StepState.disabled,
    );
  }

  Step buildAddPicturesStep() {
    return Step(
      title: Text('Add pictures'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          

        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Row(children: [
                    Button(
                      label: 'Confirm',
                      onPressed: () => continued(),
                    ),
                    Container()
                  ]);
                },
                steps: <Step>[
                  buildDetailsStep(),
                  Step(
                    title: new Text('Address'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Home Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Postcode'),
                        ),
                      ],
                    ),
                    isActive: true,
                    // state: _currentStep >= 1
                    //     ? StepState.complete
                    //     : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Mobile Number'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Mobile Number'),
                        ),
                      ],
                    ),
                    isActive: true,
                    // state: _currentStep >= 2
                    //     ? StepState.complete
                    //     : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: switchStepsType,
      ),
    );
  }
}
