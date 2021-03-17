import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/components/form_keys.dart';
import 'package:provider/provider.dart';

class StepperWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  CalendarService db = CalendarService();
  int _currentStep = 0;
  bool showCreateEventButton = false;
  DateTime selectedDate = DateTime.now();
  DateTime startDate;
  DateTime endDate;
  DateTime deadline;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String _value;
  var titleController = TextEditingController();
  var startDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var deadlineController = TextEditingController();
  var categoryController = TextEditingController();
  var meetingPointController = TextEditingController();
  var dissolutionPointController = TextEditingController();
  var minParController = TextEditingController();
  var maxParController = TextEditingController();
  var requirementsController = TextEditingController();
  var equipmentController = TextEditingController();
  var priceController = TextEditingController();
  var paymentController = TextEditingController();
  var descriptionController = TextEditingController();

  Step getStep1() {
    return Step(
      title: new Text('Event details'),
      content: Form(
          key: FormKeys.step1Key,
          child: Column(
            children: [
              TextInputFormFieldComponent(
                titleController,
                AuthenticationValidation.validateNotNull,
                'Event title',
                iconData: Icons.title,
              ),
              buildCategoryDropDown(),
              buildStartDateRow(context),
              buildEndDateRow(context),
              buildDeadlineField(context)
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep2() {
    return Step(
      title: new Text('Location'),
      content: Form(
          key: FormKeys.step2Key,
          child: Column(
            children: <Widget>[
              const Text('Country'), //Autofill
              const Text('Region'), //dropdown
              TextInputFormFieldComponent(
                meetingPointController,
                AuthenticationValidation.validateNotNull,
                'Meeting point',
                iconData: Icons.add_location_outlined,
              ),
              TextInputFormFieldComponent(
                dissolutionPointController,
                AuthenticationValidation.validateNotNull,
                'Dissolution point',
                iconData: Icons.flag_outlined,
              )
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep3() {
    return Step(
      title: new Text('Participants'),
      content: Form(
          key: FormKeys.step3Key,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  TextInputFormFieldComponent(
                    minParController,
                    AuthenticationValidation.validateNotNull,
                    'Min. participants',
                    iconData: Icons.person_outlined,
                    width: MediaQuery.of(context).size.width / 2.6,
                  ),
                  TextInputFormFieldComponent(
                    maxParController,
                    AuthenticationValidation.validateNotNull,
                    'Max. participants',
                    iconData: Icons.group_outlined,
                    width: MediaQuery.of(context).size.width / 2.6,
                  ),
                ],
              ),
              TextInputFormFieldComponent(
                requirementsController,
                AuthenticationValidation.validateNotNull,
                'Participation requirements',
                iconData: Icons.tab,
              ),
              TextInputFormFieldComponent(
                equipmentController,
                AuthenticationValidation.validateNotNull,
                'Equipment',
                iconData: Icons.backpack_outlined,
              ),
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep4() {
    return Step(
      title: new Text('Payment'),
      content: Form(
          key: FormKeys.step4Key,
          child: Column(
            children: <Widget>[
              TextInputFormFieldComponent(
                priceController,
                AuthenticationValidation.validateNotNull,
                'Price',
                iconData: Icons.money_outlined,
              ),
              TextInputFormFieldComponent(
                paymentController,
                AuthenticationValidation.validateNotNull,
                'Payment options',
                iconData: Icons.payment_outlined,
              )
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep5() {
    return Step(
      title: new Text('Description'),
      content: Form(
          key: FormKeys.step5Key,
          child: Column(
            children: <Widget>[
              const Text('Add photo'),
              TextInputFormFieldComponent(
                descriptionController,
                AuthenticationValidation.validateNotNull,
                'Description',
                iconData: Icons.description_outlined,
              )
            ],
          )),
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
              AuthenticationValidation
                  .validateNotNull, //AuthenticationValidation.validateDates,
              'start date',
              iconData: Icons.date_range_outlined,
              width: MediaQuery.of(context).size.width / 2.2,
            ))),
        GestureDetector(
          onTap: () => selectTime(context, 'start'),
          child: AbsorbPointer(
              child: TextInputFormFieldComponent(
            startTimeController,
            AuthenticationValidation
                .validateNotNull, //AuthenticationValidation.validateDates,
            'start time',
            iconData: Icons.access_time_outlined,
            width: MediaQuery.of(context).size.width / 3,
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
              AuthenticationValidation.validateDates,
              'end date',
              iconData: Icons.date_range_outlined,
              width: MediaQuery.of(context).size.width / 2.2,
              optionalController: startDateController,
            ))),
        GestureDetector(
            onTap: () => selectTime(context, 'end'),
            child: AbsorbPointer(
                child: TextInputFormFieldComponent(
              endTimeController,
              AuthenticationValidation.validateNotNull,
              'end time',
              iconData: Icons.access_time_outlined,
              width: MediaQuery.of(context).size.width / 3,
            ))),
      ],
    );
  }

  Widget buildDeadlineField(BuildContext context) {
    return GestureDetector(
      onTap: () => selectDate(context, 'deadline'),
      child: AbsorbPointer(
          child: TextInputFormFieldComponent(
        deadlineController,
        AuthenticationValidation.validateNotNull,
        'deadline',
        iconData: Icons.date_range_outlined,
      )),
    );
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
    EventNotifier eventNotifier =
        Provider.of<EventNotifier>(context, listen: false);
    tryCreateEvent() async {
      print(descriptionController.text);
      Map<String, dynamic> data = {
        'title': titleController.text,
        'createdBy': "testID123",
        'description': descriptionController.text,
        'category': categoryController.text,
        'region': "Hokkaido",
        'price': priceController.text,
        'payment': paymentController.text,
        'maxParticipants': int.parse(maxParController.text),
        'minParticipants': int.parse(minParController.text),
        'participants': [],
        'requirements': requirementsController.text,
        'equipment': equipmentController.text,
        'meeting': meetingPointController.text,
        'dissolution': dissolutionPointController.text,
        'imageUrl': "nothing",
        'startDate': startDate,
        'endDate': endDate,
        'deadline': deadline,
      };
      var value = await db.addNewEvent(data, eventNotifier);
      if (value == 'Success') {
        Navigator.pushNamed(context, '/event');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      }
    }

    tapped(int step) {
      setState(() => _currentStep = step);
    }

    continued() {
      if (_currentStep == 0) {
        FormKeys.step1Key.currentState.save();
        if (FormKeys.step1Key.currentState.validate())
          setState(() => _currentStep += 1);
      } else if (_currentStep == 1) {
        FormKeys.step2Key.currentState.save();
        if (FormKeys.step2Key.currentState.validate())
          setState(() => _currentStep += 1);
      } else if (_currentStep == 2) {
        FormKeys.step3Key.currentState.save();
        if (FormKeys.step3Key.currentState.validate())
          setState(() => _currentStep += 1);
      } else if (_currentStep == 3) {
        FormKeys.step4Key.currentState.save();
        if (FormKeys.step4Key.currentState.validate())
          setState(() => _currentStep += 1);
      } else if (_currentStep == 4) {
        FormKeys.step5Key.currentState.save();
        if (FormKeys.step5Key.currentState.validate()) tryCreateEvent();
      }
      /*if (_currentStep < 4) {
      formKey.currentState.save();
      if (formKey.currentState.validate()) setState(() => _currentStep += 1);
      for (var key in FormKeys.keys) {
        key.currentState.save();
        if (!key.currentState.validate()) validated = false;
      }
      if (validated) {
        setState(() => _currentStep += 1);
      }*/
      else {
        //formKey.currentState.save();
        for (var key in FormKeys.keys) key.currentState.save();
        tryCreateEvent();
      }
    }

    cancel() {
      if (_currentStep > 0) setState(() => _currentStep -= 1);
    }

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
}
