import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dtp;
import 'package:fa_stepper/fa_stepper.dart';

class StepperWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  final formKey = new GlobalKey<FormState>();
  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();
  DateTime startDate;
  DateTime endDate;
  DateTime deadline;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String _value;
  TextEditingController titleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  Step getStep1() {
    return Step(
      title: new Text('Event details'),
      content: Column(
        children: [
          Form(
              key: formKey,
              child: TextInputFormFieldComponent(
                titleController,
                AuthenticationValidation.validateNotNull,
                'Event title',
                iconData: Icons.title,
              )),
          buildCategoryDropDown(),
          buildStartDateRow(context),
          buildEndDateRow(context),
          buildDeadlineField(context)
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep2() {
    return Step(
      title: new Text('Location'),
      content: Column(
        children: <Widget>[
          const Text('Country'), //Autofill
          const Text('Region'), //dropdown
          TextInputFormFieldComponent(
            TextEditingController(),
            null,
            'Meeting point',
            iconData: Icons.add_location_outlined,
          ),
          TextInputFormFieldComponent(
            TextEditingController(),
            null,
            'Dissolution point',
            iconData: Icons.flag_outlined,
          )
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep3() {
    return Step(
      title: new Text('Participants'),
      content: Column(
        children: <Widget>[
          Row(
            children: [
              TextInputFormFieldComponent(
                TextEditingController(),
                AuthenticationValidation.validateNotNull,
                'Min. participants',
                iconData: Icons.person_outlined,
                width: MediaQuery.of(context).size.width / 2.6,
              ),
              TextInputFormFieldComponent(
                TextEditingController(),
                AuthenticationValidation.validateNotNull,
                'Max. participants',
                iconData: Icons.group_outlined,
                width: MediaQuery.of(context).size.width / 2.6,
              ),
            ],
          ),
          TextInputFormFieldComponent(
            TextEditingController(),
            AuthenticationValidation.validateNotNull,
            'Participation requirements',
            iconData: Icons.tab,
          ),
          TextInputFormFieldComponent(
            TextEditingController(),
            AuthenticationValidation.validateNotNull,
            'Equipment',
            iconData: Icons.backpack_outlined,
          ),
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep4() {
    return Step(
      title: new Text('Payment'),
      content: Column(
        children: <Widget>[
          TextInputFormFieldComponent(
            TextEditingController(),
            null,
            'Price',
            iconData: Icons.money_outlined,
          ),
          TextInputFormFieldComponent(
            TextEditingController(),
            null,
            'Payment options',
            iconData: Icons.payment_outlined,
          )
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep5() {
    return Step(
      title: new Text('Description'),
      content: Column(
        children: <Widget>[
          const Text('Add photo'),
          TextInputFormFieldComponent(
            TextEditingController(),
            null,
            'Description',
            iconData: Icons.description_outlined,
          )
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 4 ? StepState.complete : StepState.disabled,
    );
  }

  Widget buildStartDateRow(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => selectDate(context, 'start'),
          child: AbsorbPointer(
              child: TextInputFormFieldComponent(
            startDateController,
            null /**/,
            'start date',
            iconData: Icons.date_range_outlined,
            width: MediaQuery.of(context).size.width / 2.6,
          )),
        ),
        GestureDetector(
          onTap: () => selectTime(context, 'start'),
          child: AbsorbPointer(
              child: TextInputFormFieldComponent(
            startTimeController,
            null /**/,
            'start time',
            iconData: Icons.access_time_outlined,
            width: MediaQuery.of(context).size.width / 2.6,
          )),
        ),
      ],
    );
  }

  Widget buildEndDateRow(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => selectDate(context, 'end'),
          child: AbsorbPointer(
              child: TextInputFormFieldComponent(
            endDateController,
            null /**/,
            'end date',
            iconData: Icons.date_range_outlined,
            width: MediaQuery.of(context).size.width / 2.6,
          )),
        ),
        GestureDetector(
          onTap: () => selectTime(context, 'end'),
          child: AbsorbPointer(
              child: TextInputFormFieldComponent(
            endTimeController,
            null /**/,
            'end time',
            iconData: Icons.access_time_outlined,
            width: MediaQuery.of(context).size.width / 2.6,
          )),
        ),
      ],
    );
  }

  Widget buildDeadlineField(BuildContext context) {
    return GestureDetector(
        onTap: () => selectDate(context, 'deadline'),
        child: AbsorbPointer(
          child: Form(
              child: TextInputFormFieldComponent(
            deadlineController,
            null /**/,
            'deadline',
            iconData: Icons.date_range_outlined,
          )),
        ));
  }

  void selectDate(BuildContext context, String dateType) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        String formattedDate =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString()}";
        switch (dateType) {
          case 'start':
            startDate = updateDateTime(picked, startTime);
            print('from date ' + startDate.toString());
            startDateController.text = formattedDate;
            break;
          case 'end':
            endDate = updateDateTime(picked, endTime);
            print('end date ' + endDate.toString());
            endDateController.text = formattedDate;
            break;
          case 'deadline':
            deadline = picked;
            print('from date ' + deadline.toString());
            deadlineController.text = formattedDate;
            break;
        }
      });
  }

  void selectTime(BuildContext context, String timeType) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null)
      setState(() {
        String formattedDate =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        switch (timeType) {
          case 'start':
            startTime = picked;
            startDate = updateDateTime(startDate, picked);
            print('from date ' + startDate.toString());
            startTimeController.text = formattedDate;
            break;
          case 'end':
            endTime = picked;
            endDate = updateDateTime(endDate, picked);
            print('end date ' + endDate.toString());
            endTimeController.text = formattedDate;
            break;
        }
      });
  }

  DateTime updateDateTime(DateTime date, TimeOfDay time) {
    if (date == null)
      return new DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, time.hour, time.minute);
    else if (time == null)
      return date;
    else
      return new DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
  }

  Widget buildCategoryDropDown() {
    return DropdownButton(
      isExpanded: true,
      hint: Text('Select category'),
      value: _value,
      onChanged: (String newValue) {
        setState(() {
          _value = newValue;
          categoryController.text = newValue;
        });
      },
      items: <String>[
        'Hike',
        'Snow Hike',
        'Fastpacking',
        'Ski',
        'UL 101',
        'Run',
        'Popup',
        'MYOG Workshop',
        'Repair Workshop',
        'Other'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
          child: Stepper(
            type: StepperType.vertical,
            physics: ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: <Step>[
              getStep1(),
              getStep2(),
              getStep3(),
              getStep4(),
              getStep5()
            ],
          ),
        ),
      ],
    ));
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 4) {
      formKey.currentState.save();
      if (formKey.currentState.validate()) {
        setState(() => _currentStep += 1);
      }
    } else {
      formKey.currentState.save();
      tryCreateEvent();
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  tryCreateEvent() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      /*var value = await context
            .read<AuthenticationService>()
            .signUpUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        if (value == 'Success') {
          Navigator.pushNamed(context, homeRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value),
          ));
        }*/
    }
  }
}
