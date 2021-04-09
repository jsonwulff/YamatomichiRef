import 'package:app/constants/constants.dart';
import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/form_fields/text_form_field_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'event_controllers.dart';
import 'form_keys.dart'; // Use localization

class StepperWidget extends StatefulWidget {
  StepperWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  //final regionKey = GlobalKey<FormFieldState>();
  EventNotifier eventNotifier;
  EventControllers eventControllers;
  Event event;
  UserProfileNotifier userProfileNotifier;
  CalendarService db = CalendarService();
  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();
  DateTime startDate;
  DateTime endDate;
  DateTime deadline;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String _value;
  List<String> currentRegions = ['Choose country'];
  bool changedRegion = false;

  @override
  void initState() {
    super.initState();
    print('Initializing state');
    FormKeys();
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    event = eventNotifier.event;
    userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
      //userProfile = userProfileNotifier.userProfile;
    }
  }

  setControllers() {
    eventControllers = EventControllers(context);
  }

  Step getStep1() {
    var texts = AppLocalizations.of(context);

    return Step(
      title: new Text(texts.eventDetails),
      content: Form(
          key: FormKeys.step1Key,
          child: Column(
            children: [
              TextInputFormFieldComponent(
                EventControllers.titleController,
                AuthenticationValidation.validateNotNull,
                texts.eventTitle,
                key: Key('event_title'),
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

  Step getStep2(UserProfile userProfile) {
    return Step(
      title: new Text('Location'),
      content: Column(children: [
        _buildCountryDropdown(userProfile),
        _buildHikingRegionDropDown(userProfile),
        Form(
            key: FormKeys.step2Key,
            child: Column(
              children: <Widget>[
                TextInputFormFieldComponent(
                  EventControllers.meetingPointController,
                  AuthenticationValidation.validateNotNull,
                  'Meeting point',
                  iconData: Icons.add_location_outlined,
                ),
                TextInputFormFieldComponent(
                  EventControllers.dissolutionPointController,
                  AuthenticationValidation.validateNotNull,
                  'Dissolution point',
                  iconData: Icons.flag_outlined,
                )
              ],
            ))
      ]),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep3() {
    var texts = AppLocalizations.of(context);
    return Step(
      title: new Text(texts.participant),
      content: Form(
          key: FormKeys.step3Key,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  TextInputFormFieldComponent(
                    EventControllers.minParController,
                    AuthenticationValidation.validateNotNull,
                    texts.minParticipants,
                    iconData: Icons.person_outlined,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  TextInputFormFieldComponent(
                    EventControllers.maxParController,
                    AuthenticationValidation.validateNotNull,
                    texts.maxParticipants,
                    iconData: Icons.group_outlined,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
              TextInputFormFieldComponent(
                EventControllers.requirementsController,
                AuthenticationValidation.validateNotNull,
                'Participation requirements',
                iconData: Icons.tab,
              ),
              TextInputFormFieldComponent(
                EventControllers.equipmentController,
                AuthenticationValidation.validateNotNull,
                texts.equipment,
                iconData: Icons.backpack_outlined,
              ),
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep4() {
    var texts = AppLocalizations.of(context);
    return Step(
      title: new Text(texts.payment),
      content: Form(
          key: FormKeys.step4Key,
          child: Column(
            children: <Widget>[
              TextInputFormFieldComponent(
                EventControllers.priceController,
                AuthenticationValidation.validateNotNull,
                texts.price,
                iconData: Icons.money_outlined,
              ),
              TextInputFormFieldComponent(
                EventControllers.paymentController,
                AuthenticationValidation.validateNotNull,
                texts.paymentOptions,
                iconData: Icons.payment_outlined,
              )
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
    );
  }

  Step getStep5() {
    var texts = AppLocalizations.of(context);

    return Step(
      title: new Text(texts.description),
      content: Form(
          key: FormKeys.step5Key,
          child: Column(
            children: <Widget>[
              const Text('Add photo'),
              TextInputFormFieldComponent(
                EventControllers.descriptionController,
                AuthenticationValidation.validateNotNull,
                texts.description,
                iconData: Icons.description_outlined,
              )
            ],
          )),
      isActive: _currentStep >= 0,
      state: _currentStep >= 4 ? StepState.complete : StepState.disabled,
    );
  }

  Widget buildStartDateRow(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
            onTap: () => selectDate(context, 'start'),
            child: AbsorbPointer(
                child: TextInputFormFieldComponent(
              EventControllers.startDateController,
              AuthenticationValidation.validateNotNull, //AuthenticationValidation.validateDates,
              texts.startDate,
              iconData: Icons.date_range_outlined,
              width: MediaQuery.of(context).size.width / 2.5,
            ))),
        GestureDetector(
          onTap: () => selectTime(context, 'start'),
          child: AbsorbPointer(
              child: TextInputFormFieldComponent(
            EventControllers.startTimeController,
            AuthenticationValidation.validateNotNull, //AuthenticationValidation.validateDates,
            texts.startTime,
            iconData: Icons.access_time_outlined,
            width: MediaQuery.of(context).size.width / 3,
          )),
        ),
      ],
    );
  }

  Widget buildEndDateRow(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
            onTap: () => selectDate(context, 'end'),
            child: AbsorbPointer(
                child: TextInputFormFieldComponent(
              EventControllers.endDateController,
              AuthenticationValidation.validateDates,
              texts.endDate,
              iconData: Icons.date_range_outlined,
              optionalController: EventControllers.startDateController,
              width: MediaQuery.of(context).size.width / 2.5,
            ))),
        GestureDetector(
            onTap: () => selectTime(context, 'end'),
            child: AbsorbPointer(
                child: TextInputFormFieldComponent(
              EventControllers.endTimeController,
              AuthenticationValidation.validateNotNull,
              texts.endTime,
              iconData: Icons.access_time_outlined,
              width: MediaQuery.of(context).size.width / 3,
            ))),
      ],
    );
  }

  Widget buildDeadlineField(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => selectDate(context, 'deadline'),
      child: AbsorbPointer(
          child: TextInputFormFieldComponent(
        EventControllers.deadlineController,
        AuthenticationValidation.validateNotNull,
        texts.deadline,
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
            EventControllers.startDateController.text = formattedDate;
            break;
          case 'end':
            endDate = updateDateTime(picked, endTime);
            print('end date ' + endDate.toString());
            EventControllers.endDateController.text = formattedDate;
            break;
          case 'deadline':
            deadline = picked;
            print('from date ' + deadline.toString());
            EventControllers.deadlineController.text = formattedDate;
            break;
        }
      });
  }

  void selectTime(BuildContext context, String timeType) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null)
      setState(() {
        String formattedDate =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        switch (timeType) {
          case 'start':
            startTime = picked;
            startDate = updateDateTime(startDate, picked);
            print('from date ' + startDate.toString());
            EventControllers.startTimeController.text = formattedDate;
            break;
          case 'end':
            endTime = picked;
            endDate = updateDateTime(endDate, picked);
            print('end date ' + endDate.toString());
            EventControllers.endTimeController.text = formattedDate;
            break;
        }
      });
  }

  DateTime updateDateTime(DateTime date, TimeOfDay time) {
    if (date == null)
      return new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);
    else if (time == null)
      return date;
    else
      return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime getDateTime2(String date, String time) {
    print('getDateTime ' + date);
    print('getDateTime ' + time);
    return new DateTime(
        int.parse(date.substring(6, 10)),
        int.parse(date.substring(3, 5)),
        int.parse(date.substring(0, 2)),
        int.parse(time.substring(0, 2)),
        int.parse(time.substring(3, 5)));
  }

  DateTime getDateTime(String date) {
    return DateTime(int.parse(date.substring(6, 10)), int.parse(date.substring(3, 5)),
        int.parse(date.substring(0, 2)), 0, 0);
  }

  Widget buildCategoryDropDown() {
    //var texts = AppLocalizations.of(context);
    return DropdownButton(
      isExpanded: true,
      hint: Text('Select category'),
      value: EventControllers.categoryController.text == ''
          ? _value
          : EventControllers.categoryController.text,
      onChanged: (String newValue) {
        setState(() {
          _value = newValue;
          EventControllers.categoryController.text = newValue;
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

  initDropdown() {
    if (EventControllers.countryController.text != '') {
      if (currentRegions != null /*&& FormKeys.regionKey.currentState != null*/) {
        //print('regionKey ' + FormKeys.regionKey.toString());
        //FormKeys.regionKey.currentState.reset();
      }
      currentRegions = countryRegions[EventControllers.countryController.text];
      changedRegion = true;
    }
  }

  Widget _buildCountryDropdown(UserProfile userProfile) {
    print('country ' + EventControllers.countryController.text);
    return DropdownButtonFormField(
      hint: Text('Select country'),
      validator: (value) {
        if (value == null) {
          return 'Select country';
        }
        return null;
      },
      value: EventControllers.countryController.text == ''
          ? userProfile.country
          : EventControllers.countryController.text, // Intial value
      onChanged: (value) {
        setState(() {
          if (currentRegions != null /*&&
              FormKeys.regionKey.currentState != null*/
              ) {
            //print('regionKey ' + FormKeys.regionKey.toString());
            //FormKeys.regionKey.currentState.reset();
          }
          currentRegions = countryRegions[value];
          changedRegion = true;
          EventControllers.countryController.text = value;
        });
      },
      items: countriesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildHikingRegionDropDown(UserProfile userProfile) {
    initDropdown();
    return DropdownButtonFormField(
      //key: FormKeys.regionKey,
      hint: Text('Select region'),
      validator: (value) {
        if (value == null) {
          return 'Select region';
        } else if (value == 'Choose country') {
          return 'Please choose a country above and select region next';
        }
        return null;
      },
      value: EventControllers.regionController.text == ''
          ? currentRegions.contains(userProfile.hikingRegion)
              ? userProfile.hikingRegion
              : null
          : currentRegions.contains(EventControllers.regionController.text)
              ? EventControllers.regionController.text
              : null, // Intial value
      onChanged: (value) {
        EventControllers.regionController.text = value;
      },
      items: currentRegions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    setControllers();
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    UserProfile userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    Map<String, dynamic> getMap() {
      return {
        'title': EventControllers.titleController.text,
        'createdBy': userProfile.id,
        'description': EventControllers.descriptionController.text,
        'category': EventControllers.categoryController.text,
        'country': EventControllers.countryController.text,
        'region': EventControllers.regionController.text,
        'price': EventControllers.priceController.text,
        'payment': EventControllers.paymentController.text,
        'maxParticipants': int.parse(EventControllers.maxParController.text),
        'minParticipants': int.parse(EventControllers.minParController.text),
        'participants': [],
        'requirements': EventControllers.requirementsController.text,
        'equipment': EventControllers.equipmentController.text,
        'meeting': EventControllers.meetingPointController.text,
        'dissolution': EventControllers.dissolutionPointController.text,
        'imageUrl': "nothing",
        'startDate': getDateTime2(
            EventControllers.startDateController.text, EventControllers.startTimeController.text),
        'endDate': getDateTime2(
            EventControllers.endDateController.text, EventControllers.endTimeController.text),
        'deadline': getDateTime(EventControllers.deadlineController.text),
      };
    }

    tryCreateEvent() async {
      var data = getMap();
      var value = await db.addNewEvent(data, eventNotifier);
      if (value == 'Success') {
        Navigator.pushNamed(context, '/event');
        EventControllers.updated = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      }
    }

    _onEvent(Event event) {
      EventNotifier eventNotifier = Provider.of<EventNotifier>(context, listen: false);
      eventNotifier.event = event;
      getEvent(event.id, eventNotifier).then(setControllers());
      Navigator.pushNamed(context, '/event');
      EventControllers.updated = false;
    }

    _saveEvent() {
      print('save event Called');
      //Event event = Provider.of<EventNotifier>(context, listen: false).event;
      updateEvent(event, _onEvent, getMap());
    }

    tapped(int step) {
      setState(() => _currentStep = step);
    }

    continued() {
      if (_currentStep == 0) {
        FormKeys.step1Key.currentState.save();
        if (FormKeys.step1Key.currentState.validate()) setState(() => _currentStep += 1);
      } else if (_currentStep == 1) {
        FormKeys.step2Key.currentState.save();
        if (FormKeys.step2Key.currentState.validate()) setState(() => _currentStep += 1);
      } else if (_currentStep == 2) {
        FormKeys.step3Key.currentState.save();
        if (FormKeys.step3Key.currentState.validate()) setState(() => _currentStep += 1);
      } else if (_currentStep == 3) {
        FormKeys.step4Key.currentState.save();
        if (FormKeys.step4Key.currentState.validate()) setState(() => _currentStep += 1);
      } else if (_currentStep == 4) {
        FormKeys.step5Key.currentState.save();
        if (FormKeys.step5Key.currentState.validate()) {
          if (!(eventNotifier.event == null)) {
            _saveEvent();
          } else {
            tryCreateEvent();
          }
        }
      }
    }

    cancel() {
      if (_currentStep > 0) setState(() => _currentStep -= 1);
    }

    return Scaffold(
        body: Container(
            child: Column(children: [
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
            getStep2(userProfile),
            getStep3(),
            getStep4(),
            getStep5(),
          ],
        ),
      )
    ])));
  }
}
