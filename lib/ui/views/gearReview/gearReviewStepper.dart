import 'package:app/middleware/api/review_api.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/gearReview_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/models/review.dart';
import 'package:app/notifiers/gearReview_notifier.dart';
import 'package:app/ui/shared/form_fields/text_form_field_generator.dart';
import 'package:app/ui/views/calendar/components/form_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'gearReview_controllers.dart'; // Use localization

class GearReviewStepperWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GearReviewStepperWidgetState();
}

class _GearReviewStepperWidgetState extends State<GearReviewStepperWidget> {
  //final regionKey = GlobalKey<FormFieldState>();
  GearReviewNotifier gearReviewNotifier;
  GearReviewControllers gearReviewControllers;
  Review review;
  UserProfileNotifier userProfileNotifier;
  GearReviewService db = GearReviewService();
  int _currentStep = 0;
  // String _value;

  @override
  void initState() {
    super.initState();
    print('Initializing state');
    FormKeys();
    gearReviewNotifier =
        Provider.of<GearReviewNotifier>(context, listen: false);
    review = gearReviewNotifier.review;
    userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
      //userProfile = userProfileNotifier.userProfile;
    }
  }

  setControllers() {
    gearReviewControllers = GearReviewControllers(context);
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
                GearReviewControllers.titleController,
                AuthenticationValidation.validateNotNull,
                texts.eventTitle,
                iconData: Icons.title,
              ),
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
        Form(
            key: FormKeys.step2Key,
            child: Column(
              children: <Widget>[
                TextInputFormFieldComponent(
                  GearReviewControllers.descriptionController,
                  AuthenticationValidation.validateNotNull,
                  'Description',
                  iconData: Icons.description_outlined,
                ),
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
                    GearReviewControllers.categoryController,
                    AuthenticationValidation.validateNotNull,
                    texts.category,
                    iconData: Icons.category_outlined,
                    width: MediaQuery.of(context).size.width / 2.6,
                  ),
                ],
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
                GearReviewControllers.priceController,
                AuthenticationValidation.validateNotNull,
                texts.price,
                iconData: Icons.money_outlined,
              ),
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
                GearReviewControllers.descriptionController,
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
    return DateTime(int.parse(date.substring(6, 10)),
        int.parse(date.substring(3, 5)), int.parse(date.substring(0, 2)), 0, 0);
  }

  Widget build(BuildContext context) {
    setControllers();
    gearReviewNotifier =
        Provider.of<GearReviewNotifier>(context, listen: false);
    UserProfile userProfile =
        Provider.of<UserProfileNotifier>(context).userProfile;

    Map<String, dynamic> getMap() {
      return {
        'title': GearReviewControllers.titleController.text,
        'createdBy': userProfile.id,
        'description': GearReviewControllers.descriptionController.text,
        'category': GearReviewControllers.categoryController.text,
        'price': GearReviewControllers.priceController.text,
        'imageUrl': "nothing",
      };
    }

    tryCreateGearReview() async {
      var data = getMap();
      var value = await db.addNewGearReview(data, gearReviewNotifier);
      if (value == 'Success') {
        Navigator.pushNamed(context, '/gearReview');
        GearReviewControllers.updated = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      }
    }

    _onReview(Review review) {
      GearReviewNotifier gearReviewNotifier =
          Provider.of<GearReviewNotifier>(context, listen: false);
      gearReviewNotifier.review = review;
      getReview(review.id, gearReviewNotifier).then(setControllers());
      Navigator.pushNamed(context, '/gearReview');
      GearReviewControllers.updated = false;
    }

    _saveReview() {
      print('save review Called');
      //Event event = Provider.of<EventNotifier>(context, listen: false).event;
      updateGearReview(review, _onReview, getMap());
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
        if (FormKeys.step5Key.currentState.validate()) {
          if (!(gearReviewNotifier.review == null)) {
            _saveReview();
          } else {
            tryCreateGearReview();
          }
        }
      }
    }

    cancel() {
      if (_currentStep > 0) setState(() => _currentStep -= 1);
    }

    return Container(
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
            getStep5()
          ],
        ),
      )
    ]));
  }
}
