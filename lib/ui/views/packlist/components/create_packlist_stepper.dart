import 'package:app/ui/shared/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepperDemo extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  var seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];
  var tags = ['Hiking', 'Trail running', 'Bicycling', 'Snow hiking', 'Ski', 'Fast packing', 'Others'];

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

  buildTextFormField(String errorMessage, String labelText, int maxLength,
      int minLines, int maxLines, TextInputType textInputType) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: TextFormField(
          // controller: textController,
          validator: (value) {
            if (value.trim().isEmpty) {
              return errorMessage;
            }
            return null;
          },
          // style: new TextStyle(fontSize: 14.0),
          maxLength: maxLength,
          decoration: InputDecoration(
              labelText: labelText,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black))),
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: textInputType
          // textInputAction: TextInputAction.next,
          ),
    );
  }

  buildDropDownFormField(List<String> data, String hint, String initialValue) {

    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: DropdownButtonFormField(
        hint: Text(hint),
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        value: initialValue,
        items: data.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            initialValue = newValue;
          });
        },
      ),
    );
  }

  Step buildDetailsStep() {
    return Step(
      title: new Text('Details'),
      content: Column(
        children: <Widget>[
          buildTextFormField('Please provide a title for the packlist', 'Title',
              50, 1, 1, TextInputType.text),
          buildTextFormField('How many days is the packlist suited for',
              'Amount of days', null, 1, 1, TextInputType.number),
          buildDropDownFormField(seasons, 'Season', null),
          buildDropDownFormField(tags, 'Tags', null),
          buildTextFormField('Please provide a description of your packlist',
              'Description', 500, 10, 10, TextInputType.multiline),
        ],
      ),
      isActive: true,
      // state: step_contains_content_provied_by_user
      //     ? StepState.complete
      //     : StepState.,
    );
  }

  Step buildAddPicturesStep() {
    return Step(
      title: Text('Add pictures'),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: []),
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

class AddItemSpawner extends StatelessWidget {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add item'),
          Row(
            children: [Expanded(child: TextFormField())],
          ),
        ],
      ),
      // margin: new EdgeInsets.all(8.0),
      // child: new TextField(
      //   controller: controller,
      //   decoration: new InputDecoration(hintText: 'Enter Data '),
      // ),
    );
  }
}
