import 'dart:io';
import 'package:app/constants/countryRegion.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';
import 'package:app/ui/shared/dialogs/img_pop_up.dart';
import 'package:app/ui/views/calendar/event_page.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/packlist/components/custom_text_form_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'event_controllers.dart';
import 'form_keys.dart';

class StepperWidget extends StatefulWidget {
  StepperWidget({Key key, this.event, this.eventNotifier, this.editing}) : super(key: key);
  final Event event;
  final EventNotifier eventNotifier;
  final bool editing;

  @override
  State<StatefulWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();

  EventControllers eventControllers;
  UserProfileNotifier userProfileNotifier;
  UserProfile userProfile;
  CalendarService db = CalendarService();

  String translatedCountry;
  String translatedRegion;

  int _currentStep = 0;

  //used in date/time pickers
  DateTime startDate;
  DateTime endDate;
  DateTime deadline;
  TimeOfDay startTime;
  TimeOfDay endTime;

  //used in category dropdown
  String _value;

  bool allowComments;
  bool isEventFree = false;

  List<String> currentRegions = ['AppLocalizations.of(context).chooseCountry']; //'Choose country'
  bool changedRegion = false;

  //images
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<dynamic> images = [];
  List<File> newImages = [];
  List<dynamic> imagesMarkedForDeletion = [];
  dynamic mainImage;

  @override
  void initState() {
    super.initState();
    print('Initializing state');
    FormKeys();
    /*eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    event = eventNotifier.event;
    userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
    }*/
    if (widget.event != null) {
      // ignore: unnecessary_statements
      widget.event.mainImage != null
          ? mainImage = widget.event.mainImage
          // ignore: unnecessary_statements
          : null;
      images = widget.event.imageUrl;
    }
  }

  /*setControllers() {
    eventControllers = EventControllers(context);
  }*/

  Step getStep1() {
    var texts = AppLocalizations.of(context);

    return Step(
      title: new Text(texts.details, style: Theme.of(context).textTheme.headline2),
      content: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Form(
            key: FormKeys.step1Key,
            child: Column(
              children: [
                CustomTextFormField(
                  null,
                  texts.title,
                  30,
                  1,
                  1,
                  TextInputType.text,
                  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  controller: EventControllers.titleController,
                  validator: AuthenticationValidation.validateNotNull,
                ),
                buildCategoryDropDown(),
                buildStartDateRow(context),
                buildEndDateRow(context),
                buildDeadlineField(context)
              ],
            )),
      ),
      isActive: _currentStep >= 0,
      state: widget.editing
          ? StepState.complete
          : _currentStep >= 0
              ? StepState.complete
              : StepState.disabled,
    );
  }

  Step getStep2(UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    return Step(
      title: new Text(texts.location),
      content: Column(children: [
        _buildCountryDropdown(userProfile),
        _buildHikingRegionDropDown(userProfile),
        Form(
            key: FormKeys.step2Key,
            child: Column(
              children: <Widget>[
                CustomTextFormField(
                  null,
                  texts.meetingPoint,
                  50,
                  1,
                  1,
                  TextInputType.text,
                  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  controller: EventControllers.meetingPointController,
                  validator: AuthenticationValidation.validateNotNull,
                ),
                CustomTextFormField(
                  null,
                  texts.dissolutionPoint,
                  50,
                  1,
                  1,
                  TextInputType.text,
                  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  controller: EventControllers.dissolutionPointController,
                  validator: AuthenticationValidation.validateNotNull,
                ),
              ],
            ))
      ]),
      isActive: _currentStep >= 0,
      state: widget.editing
          ? StepState.complete
          : _currentStep >= 1
              ? StepState.complete
              : StepState.disabled,
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
                  Expanded(
                    flex: 2,
                    child: CustomTextFormField(
                      null,
                      texts.minParticipants,
                      null,
                      1,
                      1,
                      TextInputType.number,
                      EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 10.0),
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      controller: EventControllers.minParController,
                      validator: AuthenticationValidation.validateNotNull,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomTextFormField(
                      null,
                      texts.maxParticipants,
                      null,
                      1,
                      1,
                      TextInputType.number,
                      EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      controller: EventControllers.maxParController,
                      validator: AuthenticationValidation.validateNotNull,
                    ),
                  ),
                ],
              ),
              CustomTextFormField(
                null,
                texts.participationRequirements,
                100,
                1,
                3,
                TextInputType.text,
                EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                controller: EventControllers.requirementsController,
                validator: AuthenticationValidation.validateNotNull,
              ),
              CustomTextFormField(
                null,
                texts.equipment,
                100,
                1,
                3,
                TextInputType.text,
                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                controller: EventControllers.equipmentController,
                validator: AuthenticationValidation.validateNotNull,
              ),
            ],
          )),
      isActive: _currentStep >= 0,
      state: widget.editing
          ? StepState.complete
          : _currentStep >= 2
              ? StepState.complete
              : StepState.disabled,
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
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      value: isEventFree,
                      onChanged: (value) {
                        isEventFree = value;
                        setState(() {});
                      }),
                  Text('Is this event free?'),
                ],
              ),
              !isEventFree ? getPaymentStepFormfields() : Container()
            ],
          )),
      isActive: _currentStep >= 0,
      state: widget.editing
          ? StepState.complete
          : _currentStep >= 3
              ? StepState.complete
              : StepState.disabled,
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
              InkWell(
                  child: Text(
                    texts.uploadPictures,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    picture();
                  }),
              picturePreview(),
              CustomTextFormField(
                null,
                texts.description,
                500,
                1,
                15,
                TextInputType.text,
                EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                controller: EventControllers.descriptionController,
                validator: AuthenticationValidation.validateNotNull,
              ),
              buildCommentSwitchRow()
            ],
          )),
      isActive: _currentStep >= 0,
      state: widget.editing
          ? StepState.complete
          : _currentStep >= 4
              ? StepState.complete
              : StepState.disabled,
    );
  }

  getPaymentStepFormfields() {
    var texts = AppLocalizations.of(context);

    return Column(
      children: [
        CustomTextFormField(
          null,
          texts.price,
          null,
          1,
          1,
          TextInputType.number,
          EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
          inputFormatter: FilteringTextInputFormatter.digitsOnly,
          controller: EventControllers.priceController,
          validator: AuthenticationValidation.validateNotNull,
        ),
        CustomTextFormField(
          null,
          texts.paymentOptions,
          30,
          1,
          1,
          TextInputType.text,
          EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          controller: EventControllers.paymentController,
          validator: AuthenticationValidation.validateNotNull,
        ),
      ],
    );
  }

  picture() async {
    var texts = AppLocalizations.of(context);
    await imagePickerModal(
      context: context,
      modalTitle: texts.uploadImage,
      cameraButtonText: texts.takePicture,
      onCameraButtonTap: () async {
        var tempImageFile = await ImageUploader.pickImage(ImageSource.camera);
        var tempCroppedImageFile =
            await ImageUploader.cropImageWithoutRestrictions(tempImageFile.path);

        if (tempCroppedImageFile != null) {
          mainImage == null
              ? mainImage = tempCroppedImageFile
              : newImages.add(tempCroppedImageFile);
        }

        _setImagesState();
      },
      photoLibraryButtonText: texts.chooseFromPhotoLibrary,
      onPhotoLibraryButtonTap: () async {
        var tempImageFile = await ImageUploader.pickImage(ImageSource.gallery);
        var tempCroppedImageFile =
            await ImageUploader.cropImageWithoutRestrictions(tempImageFile.path);

        if (tempCroppedImageFile != null) {
          mainImage == null
              ? mainImage = tempCroppedImageFile
              : newImages.add(tempCroppedImageFile);
        }

        _setImagesState();
      },
      deleteButtonText: '',
      onDeleteButtonTap: null,
      showDeleteButton: false,
    );
  }

  Widget picturePreview() {
    int length =
        mainImage == null ? images.length + newImages.length : images.length + newImages.length + 1;
    return Container(
        height: length == 0
            ? 0.0
            : length % 4 == 0
                ? 90 * ((length / 4))
                : length < 4
                    ? 90
                    : 90 * ((length / 4).floor() + 1.0),
        child: GridView.count(
            crossAxisCount: 4,
            children: [generateMainPicturePreview()]
              ..addAll(List.generate(images.length, (index) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: InkWell(
                        onTap: () => eventPreviewPopUp(images.elementAt(index).toString()),
                        child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage(images.elementAt(index).toString()),
                                  fit: BoxFit.cover),
                              //NetworkImage(url), fit: BoxFit.cover),
                            ))));
              }))
              ..addAll(List.generate(newImages.length, (index) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: InkWell(
                        onTap: () => eventPreviewPopUp(newImages.elementAt(index)),
                        child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: FileImage(newImages.elementAt(index)), fit: BoxFit.cover),
                              //NetworkImage(url), fit: BoxFit.cover),
                            ))));
              }))));
  }

  generateMainPicturePreview() {
    if (mainImage != null) {
      return Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: InkWell(
              onTap: () => eventPreviewPopUp(mainImage),
              child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey,
                    image: DecorationImage(
                        image: mainImage is String ? NetworkImage(mainImage) : FileImage(mainImage),
                        fit: BoxFit.cover),
                    //NetworkImage(url), fit: BoxFit.cover),
                  ))));
    } else
      return SizedBox.shrink();
  }

  void eventPreviewPopUp(dynamic url) async {
    String answer = await imgChoiceDialog(url, context: context);
    print(answer);
    if (answer == 'remove') {
      setState(() {
        if (mainImage == url) {
          print('true');
          imagesMarkedForDeletion.add(mainImage);
          if (images.isNotEmpty) {
            mainImage = images.first;
            images.remove(mainImage);
          } else if (newImages.isNotEmpty) {
            mainImage = newImages.first;
            newImages.remove(mainImage);
          } else {
            print('true');
            mainImage = null;
          }
        } else if (images.contains(url)) {
          imagesMarkedForDeletion.add(url);
          images.remove(url);
        } else if (newImages.contains(url)) {
          imagesMarkedForDeletion.add(url);
          newImages.remove(url);
        }
      });
    }
    if (answer == 'main') {
      setState(() {
        mainImage is String ? images.add(mainImage) : newImages.add(mainImage);
        mainImage = url;
        images.remove(mainImage);
        newImages.remove(mainImage);
      });
    }
  }

  void _setImagesState() {
    setState(() {});
  }

  Widget buildStartDateRow(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => selectDate(context, 'start'),
                child: AbsorbPointer(
                  child: CustomTextFormField(null, texts.startDate, null, 1, 1, TextInputType.text,
                      EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                      controller: EventControllers.startDateController,
                      validator: AuthenticationValidation.validateNotNull),
                ),
              )),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => selectTime(context, 'start'),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                      null, texts.startTime, null, 1, 1, TextInputType.text, null,
                      controller: EventControllers.startTimeController,
                      validator: AuthenticationValidation.validateNotNull),
                ),
              )),
        ],
      ),
    );
  }

  Widget buildEndDateRow(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => selectDate(context, 'end'),
                child: AbsorbPointer(
                  child: CustomTextFormField(null, texts.endDate, null, 1, 1, TextInputType.text,
                      EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                      controller: EventControllers.endDateController,
                      validator: AuthenticationValidation
                          .validateNotNull), //this validation has to go back to validate dates at some point
                ),
              )),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => selectTime(context, 'end'),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    null,
                    texts.endTime,
                    null,
                    1,
                    1,
                    TextInputType.text,
                    null,
                    controller: EventControllers.endTimeController,
                    validator: AuthenticationValidation.validateNotNull,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget buildDeadlineField(BuildContext context) {
    var texts = AppLocalizations.of(context);
    //var texts = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: GestureDetector(
        onTap: () => selectDate(context, 'deadline'),
        child: AbsorbPointer(
          child: CustomTextFormField(null, texts.signUpByDeadline, null, 1, 1, TextInputType.text,
              EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
              controller: EventControllers.deadlineController,
              validator: AuthenticationValidation
                  .validateNotNull), //this validation has to go back to validate dates at some point
        ),
      ),
    );
  }

  void selectDate(BuildContext context, String dateType) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime.now();
    var lastDate = DateTime(2100);

    switch (dateType) {
      case 'start':
        if (EventControllers.endDateController.text != '')
          lastDate = getDateTime(EventControllers.endDateController.text);
        if (EventControllers.deadlineController.text != '') {
          initialDate = getDateTime(EventControllers.deadlineController.text);
          firstDate = getDateTime(EventControllers.deadlineController.text);
        }
        if (widget.editing) initialDate = getDateTime(EventControllers.startDateController.text);
        break;
      case 'end':
        if (EventControllers.startDateController.text != '') {
          firstDate = getDateTime(EventControllers.startDateController.text);
          initialDate = getDateTime(EventControllers.startDateController.text);
        }
        if (EventControllers.deadlineController.text != '') {
          initialDate = getDateTime(EventControllers.deadlineController.text);
          firstDate = getDateTime(EventControllers.deadlineController.text);
        }
        if (widget.editing) initialDate = getDateTime(EventControllers.endDateController.text);
        break;
      case 'deadline':
        if (EventControllers.startDateController.text != '')
          lastDate = getDateTime(EventControllers.startDateController.text);
        if (EventControllers.endDateController.text != '')
          lastDate = getDateTime(EventControllers.startDateController.text);
        if (widget.editing) initialDate = getDateTime(EventControllers.deadlineController.text);
        break;
    }

    final DateTime picked = await showDatePicker(
        context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate);
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
    var texts = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        hint: Text(texts.selectCategory),
        value: EventControllers.categoryController.text == ''
            ? _value
            : EventControllers.categoryController.text,
        onChanged: (String newValue) {
          setState(() {
            // what is the english version of new value, give that to the program
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
          /*
          texts.hike, 
          texts.snowHike,
          texts.fastpacking,
          texts.ski,
          texts.ul101,
          texts.run,
          texts.popup,
          texts.myogWorkshop,
          texts.repairWorkshop,
          texts.other */
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  initDropdown() {
    if (EventControllers.countryController.text != '') {
      if (currentRegions != null /*&& FormKeys.regionKey.currentState != null*/) {
        //print('regionKey ' + FormKeys.regionKey.toString());
        //FormKeys.regionKey.currentState.reset();
      }
      print('currentRegions init dropdown');
      print(EventControllers.countryController.text);
      Map<String, List<String>> map = getCountriesRegionsTranslated(context);
      print('map ' + map.toString());
      currentRegions = map[getCountryTranslated(context, EventControllers.countryController.text)];
      /*currentRegions =
          getCountriesRegionsTranslated(context)[EventControllers.countryController.text];*/
      print('currentRegions ' + currentRegions.toString());
      changedRegion = true;
    }
  }

  String setCountry() {
    if (widget.editing) {
      translatedCountry = getCountryTranslated(context, EventControllers.countryController.text);
      return getCountryTranslated(context, userProfile.country);
    } else {
      translatedCountry = getCountryTranslated(context, userProfile.country);
      return getCountryTranslated(context, userProfile.country);
    }
  }

  Widget _buildCountryDropdown(UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    print('country ' + EventControllers.countryController.text);
    return DropdownButtonFormField(
      decoration: InputDecoration(
          errorStyle: TextStyle(height: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      hint: Text(texts.selectCountry),
      validator: (value) {
        if (value == null) {
          return texts.selectCountry;
        }
        return null;
      },
      value: setCountry(), // Intial value
      onChanged: (value) {
        setState(() {
          if (currentRegions != null /*&&
              FormKeys.regionKey.currentState != null*/
              ) {
            print('regionKey ' + FormKeys.regionKey.toString());
            _regionKey.currentState.reset();
          }
          print('currentRegions country dropdown');
          currentRegions = getCountriesRegionsTranslated(context)[value];
          print('currentRegions ' + currentRegions.toString());
          changedRegion = true;
          EventControllers.countryController.text = value;
        });
      },
      items: getCountriesListTranslated(context).map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String getRegion() {
    print('contains ' + currentRegions.toString());
    print('get regions');
    print('country ' + EventControllers.countryController.text);
    print('region ' + EventControllers.regionController.text);
    return EventControllers.regionController.text == ''
        ? currentRegions.contains(
                getRegionTranslated(context, userProfile.country, userProfile.hikingRegion))
            ? EventControllers.regionController.text =
                getRegionTranslated(context, userProfile.country, userProfile.hikingRegion)
            : null
        : currentRegions.contains(getRegionTranslated(context,
                EventControllers.countryController.text, EventControllers.regionController.text))
            ? getRegionTranslated(context, EventControllers.countryController.text,
                EventControllers.regionController.text)
            : null;
  }

  Widget _buildHikingRegionDropDown(UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    initDropdown();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        key: _regionKey,
        hint: Text(texts.selectRegion),
        validator: (value) {
          if (value == null) {
            return texts.selectRegion;
          } else if (value == texts.chooseCountry) {
            return texts.pleaseChooseACountryAboveAndSelectRegionNext;
          }
          return null;
        },
        value: getRegion(), // Intial value
        onChanged: (value) {
          EventControllers.regionController.text = value;
        },
        items: currentRegions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildCommentSwitchRow() {
    var texts = AppLocalizations.of(context);
    EventControllers.allowCommentsController.text == ''
        ? allowComments = true
        : EventControllers.allowCommentsController.text == 'true'
            ? allowComments = true
            : allowComments = false;

    return Row(
      children: [
        Checkbox(
            value: allowComments,
            activeColor: Colors.blue,
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                allowComments = value;
                EventControllers.allowCommentsController.text = value.toString();
              });
            }),
        Text(texts.allowCommentsOnEvent),
      ],
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'title': EventControllers.titleController.text,
      'createdBy': userProfile.id,
      'description': EventControllers.descriptionController.text,
      'category': EventControllers.categoryController.text,
      'country': getCountryIdFromString(context, EventControllers.countryController.text),
      'region': getRegionIdFromString(
          context, EventControllers.countryController.text, EventControllers.regionController.text),
      'price': EventControllers.priceController.text,
      'payment': EventControllers.paymentController.text,
      'maxParticipants': int.parse(EventControllers.maxParController.text),
      'minParticipants': int.parse(EventControllers.minParController.text),
      'requirements': EventControllers.requirementsController.text,
      'equipment': EventControllers.equipmentController.text,
      'meeting': EventControllers.meetingPointController.text,
      'dissolution': EventControllers.dissolutionPointController.text,
      'imageUrl': images,
      'mainImage': mainImage,
      'startDate': getDateTime2(
          EventControllers.startDateController.text, EventControllers.startTimeController.text),
      'endDate': getDateTime2(
          EventControllers.endDateController.text, EventControllers.endTimeController.text),
      'deadline': getDateTime(EventControllers.deadlineController.text),
      'allowComments': allowComments,
    };
  }

  Future<String> addImageToStorage(File file) async {
    String url;
    String datetime =
        DateTime.now().toString().replaceAll(':', '').replaceAll('/', '').replaceAll(' ', '');
    String filePath = 'eventImages/${userProfile.id}/$datetime.jpg';
    Reference reference = _storage.ref().child(filePath);
    await reference.putFile(file).whenComplete(() async {
      url = await reference.getDownloadURL();
    });
    return url;
  }

  deleteImageInStorage(String url) {
    _storage.refFromURL(url.split('?alt').first).delete();
  }

  Future<Map<String, dynamic>> prepareData() async {
    var data = getMap();
    if (mainImage != null) {
      print(mainImage.toString());
      if (mainImage is File) {
        print(mainImage.toString());
        mainImage = await addImageToStorage(mainImage);
      }
      data.addAll({'mainImage': mainImage});
    }
    if (newImages != null) {
      for (File file in newImages) {
        print(file.toString());
        images.add(await addImageToStorage(file));
      }
      data.addAll({'imageUrl': images});
    }
    if (imagesMarkedForDeletion.isNotEmpty) {
      for (dynamic d in imagesMarkedForDeletion) {
        // ignore: unnecessary_statements
        d is String ? deleteImageInStorage(d) : null;
      }
    }
    return data;
  }

  tryCreateEvent() async {
    var data = await prepareData();
    var value = await db.addNewEvent(data, widget.eventNotifier);
    if (value == 'Success') {
      Navigator.pop(context);
      pushNewScreen(context, screen: EventView(), withNavBar: false);
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
    db.getEventAsNotifier(
        event.id, eventNotifier); //getEvent(event.id, eventNotifier).then(setControllers());
    Navigator.pop(context);
    EventControllers.updated = false;
  }

  _saveEvent() async {
    print('save event Called');
    var data = await prepareData();
    db.updateEvent(widget.event, data, _onEvent);
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
        if (!(widget.eventNotifier.event == null)) {
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

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    //Maybe this:
    //currentRegions = [AppLocalizations.of(context).chooseCountry];

    //setControllers();
    //widget.eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    userProfile = Provider.of<UserProfileNotifier>(context).userProfile;
    if (userProfile == null) return Container(child: Text('something went wrong'));

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
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return _currentStep < 4
                ? Row(
                    children: [
                      Button(
                        label: texts.continueLC,
                        onPressed: () {
                          continued();
                        },
                      ),
                      // Container()
                    ],
                  )
                : Button(
                    width: double.infinity,
                    label: texts.confirm,
                    onPressed: () {
                      continued();
                    },
                  );
          },
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
