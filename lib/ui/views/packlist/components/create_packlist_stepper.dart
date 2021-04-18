import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/packlist/components/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'custom_text_form_field.dart';
import 'gear_item_spawner.dart';

class CreatePacklistStepperView extends StatefulWidget {
  @override
  _CreatePacklistStepperViewState createState() =>
      _CreatePacklistStepperViewState();
}

class _CreatePacklistStepperViewState extends State<CreatePacklistStepperView> {
  // createdBy userId;
  UserProfileNotifier userProfileNotifier;

  var _detailsFormKey = GlobalKey<FormState>();

  // list of timestamps for the gearitems to be removed from firebase
  var removeditems = [];

  // _user.id get user in session
  Packlist packlist = new Packlist();
  // var packlist.categories;

  // list for all categories, each element is a List<GearItem>
  var categories = <dynamic>[];

  // list of itemGear for each category
  var carrying = <GearItem>[];
  var sleepingGear = <GearItem>[];
  var foodAndCooking = <GearItem>[];
  var clothesPacked = <GearItem>[];
  var clothesWorn = <GearItem>[];
  var other = <GearItem>[];

  // stepper variables
  var _currentStep = 0;

  // whether to show the add button in categories step
  bool isAddingNewItem = false;

  // image files uploaded by user
  var images = <File>[];

  // static lists for dropdownmenues
  // TODO : needs translation
  var seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];
  var tags = [
    'Hiking',
    'Trail running',
    'Bicycling',
    'Snow hiking',
    'Ski',
    'Fast packing',
    'Others'
  ];

  var choosenTags = [];

  // static list for item steps
  // TODO : needs translation
  var itemCategories = [
    'Carrying',
    'Sleeping gear',
    'Food and cooking equipment',
    'Clothes packed',
    'Clothes worn',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
      //userProfile = userProfileNotifier.userProfile;
    }
    categories.add(carrying);
    categories.add(sleepingGear);
    categories.add(foodAndCooking);
    categories.add(clothesPacked);
    categories.add(clothesWorn);
    categories.add(other);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 7 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  // dropdownformfield designed in regards to the figma
  buildDropDownFormField(List<String> data, String hint, String initialValue) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: DropdownButtonFormField(
        // ignore: missing_return
        validator: (value) {
          if (value == null) return '';
        },
        hint: Text(hint),
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        value: initialValue,
        items: data.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            if (!choosenTags.contains(newValue)) {
              // choosenTags.add(newValue);
              // tags.remove(newValue);
            }
            initialValue = newValue;
          });
        },
      ),
    );
  }

  // building the first step where user provide the overall details for the packlist
  // TODO : needs translation
  Step buildDetailsStep() {
    return Step(
      title: new Text('Details', style: Theme.of(context).textTheme.headline2),
      content: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Form(
          key: _detailsFormKey,
          child: Column(
            children: <Widget>[
              CustomTextFormField(
                null,
                'Title',
                30,
                1,
                1,
                TextInputType.text,
                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                validator: (String value) {
                  if (value.isEmpty) return '';
                  // if (!value.contains(RegExp(r'^[0-9]*$'))) return 'Only integers accepted';
                },
              ),
              CustomTextFormField(
                null,
                'Amount of days',
                null,
                1,
                1,
                TextInputType.number,
                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (String value) {
                  if (value.isEmpty) return '';
                  // if (!value.contains(RegExp(r'^[0-9]*$'))) return 'Only integers accepted';
                },
              ),
              buildDropDownFormField(seasons, 'Season', null),
              buildDropDownFormField(tags, 'Tag', null),
              CustomTextFormField(
                  null,
                  'Description',
                  500,
                  10,
                  10,
                  TextInputType.multiline,
                  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  inputFormatter: FilteringTextInputFormatter.allow(
                      RegExp(r'.', dotAll: true)))
            ],
          ),
        ),
      ),
      isActive: true,
      // state: step_contains_content_provied_by_user
      //     ? StepState.complete
      //     : StepState.,
    );
  }

  // the following three methods are all related to the second step of the stepper :
  //    1. build the row for showing the pictures the user has uploaded
  //          - the pictures are in a container with a delete button in top right corner
  //    2. upload picture method more or less taken from ProfileView
  //    3. combining and returning the final "Add pictures" step

  buildPicturesRow(List<File> data) {
    List<Widget> pictures = [];
    for (var pic in data) {
      pictures.add(Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
        width: 90.0,
        height: 90.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(image: FileImage(pic), fit: BoxFit.cover)),
        // remove image icon in top right corner of container
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                icon: Icon(Icons.do_disturb_on_rounded, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  setState(() {
                    data.remove(pic);
                  });
                })
          ],
        ),
      ));
    }

    var foo = Wrap(children: pictures);
    return pictures;
  }

  // basically copied from Julian's implementation in profileView
  // no connection to firebase storage yet
  uploadPicture() {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Take picture',
                    textAlign: TextAlign.center,
                  ),
                  // dense: true,
                  onTap: () async {
                    var tempImageFile =
                        await ImageUploader.pickImage(ImageSource.camera);
                    var tempCroppedImageFile =
                        await ImageUploader.cropImage(tempImageFile.path);

                    setState(() {
                      images.add(tempCroppedImageFile ?? tempImageFile);
                    });

                    Navigator.pop(context);
                  },
                ),
                Divider(
                  thickness: 1,
                  height: 5,
                ),
                ListTile(
                  title: const Text(
                    'Choose from photo library',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () async {
                    var tempImageFile =
                        await ImageUploader.pickImage(ImageSource.gallery);
                    var tempCroppedImageFile =
                        await ImageUploader.cropImage(tempImageFile.path);

                    setState(() {
                      images.add(tempCroppedImageFile);
                    });

                    Navigator.pop(context);
                  },
                ),
                Divider(thickness: 1),
                ListTile(
                  title: const Text(
                    'Close',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          );
        });
  }

  Step buildAddPicturesStep() {
    return Step(
      title: Text('Add pictures', style: Theme.of(context).textTheme.headline2),
      content: Container(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text('Upload pictures for your packlist',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...buildPicturesRow(images),
                  Container(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: IconButton(
                          iconSize: 45.0,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            images.length < 9
                                ? uploadPicture() // open picture selector and add the picture to the images list
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Max 4 images'))); // snackbar informing user that you can't have more than 4 images
                          }),
                    ),
                  )
                ],
              ),
            ]),
      ),
      isActive: true,
      // state: _currentStep >= 1
      //     ? StepState.complete
      //     : StepState.disabled,
    );
  }

  // build items step helpers
  // should take a list of map<string, object> of items already added to the category
  buildExistingItems(List<GearItem> data) {
    var expansionList = [];

    for (var item in data) {
      expansionList.add(
        Column(
          children: [
            new Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: new ExpansionTile(
                key: GlobalKey(),
                initiallyExpanded: false,
                tilePadding: EdgeInsets.all(0.0),
                title: Text(
                  item.title + ' x ' + item.amount.toString(),
                  style: Theme.of(context).textTheme.headline3,
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  GearItemSpawner(
                    false,
                    data,
                    item: item,
                    despawn: _updateIsAddingNewItem,
                    removedItems: removeditems,
                  ),
                ],
              ),
            ),
            Divider(thickness: 1.0)
          ],
        ),
      );
    }

    return expansionList;
  }

  void _updateIsAddingNewItem(bool value) {
    setState(() => isAddingNewItem = value);
  }

  buildItemSteps() {
    List<Step> itemSteps = [];
    for (var i = 0; i < itemCategories.length; i++) {
      itemSteps.add(
        new Step(
          title: Text(
            itemCategories[i],
            style: Theme.of(context).textTheme.headline2,
          ),
          isActive: true,
          content: Column(
            children: [
              ...buildExistingItems(categories[i]),
              isAddingNewItem
                  ? GearItemSpawner(
                      true,
                      categories[i],
                      despawn: _updateIsAddingNewItem,
                      removedItems: removeditems,
                    )
                  : Container(),
              !isAddingNewItem
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                isAddingNewItem = true;
                              });
                            }),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      );
    }
    return itemSteps;
  }

  _buildConfirm() {
    return Button(
        label: 'Confirm',
        onPressed: () {
          if (_detailsFormKey.currentState.validate() && images.isNotEmpty) {
            // createdAt = TimeStamp.Now();

            packlist.createdBy = userProfileNotifier.userProfile.id;

            // TODO : write data to firestore
            Navigator.of(context).pop();
          } else if (images.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('You need to provide at least one image')));
          } else {
            setState(() {
              _currentStep = 0;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stepper(
                type: StepperType.vertical,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return _currentStep < 7
                      ? Row(
                          children: [
                            Button(
                              label: 'Continue', // TODO : localization
                              onPressed: () {
                                isAddingNewItem = false;
                                continued();
                              },
                            ),
                            // Container()
                          ],
                        )
                      : Container();
                },
                steps: <Step>[
                  buildDetailsStep(),
                  buildAddPicturesStep(),
                  ...buildItemSteps(),
                ],
              ),
              _buildConfirm()
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
