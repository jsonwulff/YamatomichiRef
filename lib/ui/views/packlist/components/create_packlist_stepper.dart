import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/packlist_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:tuple/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'custom_text_form_field.dart';
import 'gear_item_spawner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePacklistStepperView extends StatefulWidget {
  @override
  _CreatePacklistStepperViewState createState() => _CreatePacklistStepperViewState();
}

class _CreatePacklistStepperViewState extends State<CreatePacklistStepperView> {
  // createdBy userId;
  UserProfileNotifier userProfileNotifier;
  PacklistNotifier packlistNotifier;
  PacklistService service;

  bool isUpdating;

  var _detailsFormKey = GlobalKey<FormState>();

  // detailstep variables
  String season;
  String tag;
  TextEditingController titleController = TextEditingController();
  TextEditingController amountOfDaysController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // list of timestamps for the gearitems to be removed from firebase
  // dunno if neccesary ?
  var removeditems = [];

  // _user.id get user in session
  Packlist _packlist;
  // var _packlist.categories;

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
  bool _isPrivate = false;

  // image files uploaded by user
  var images = <File>[];

  // static lists for dropdownmenues
  // TODO : needs translation
  //
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

  var itemCategories = <Tuple2<String, String>>[];

  @override
  void initState() {
    super.initState();
    service = PacklistService();
    packlistNotifier = Provider.of<PacklistNotifier>(context, listen: false);
    userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
      //userProfile = userProfileNotifier.userProfile;
    }

    if (packlistNotifier.packlist != null) {
      _packlist = packlistNotifier.packlist;
      isUpdating = true;
      // for (Tuple2 item in itemCategories) {
      //   categories.add(service.getGearItemsInCategory(_packlist, item.item2));
      // }
      _getGearItems(_packlist, itemCategories, service).then((value) => setState(() {}));
      _isPrivate = _packlist.private;
      // categories.add(service.getGearItemsInCategory(_packlist, 'carrying'));
      // categories.add(service.getGearItemsInCategory(_packlist, 'sleepingGear'));
      // categories.add(service.getGearItemsInCategory(_packlist, 'foodAndCookingEquipment'));
      // categories.add(service.getGearItemsInCategory(_packlist, 'clothesPacked'));
      // categories.add(service.getGearItemsInCategory(_packlist, 'clothesWorn'));
      // categories.add(service.getGearItemsInCategory(_packlist, 'other'));
    } else {
      _packlist = new Packlist();
      isUpdating = false;
      categories.add(carrying);
      categories.add(sleepingGear);
      categories.add(foodAndCooking);
      categories.add(clothesPacked);
      categories.add(clothesWorn);
      categories.add(other);
    }

    // images = _packlist.imageUrls;

    titleController.text = _packlist.title;
    amountOfDaysController.text = _packlist.amountOfDays;
    season = _packlist.season;
    tag = _packlist.tag;
    descriptionController.text = _packlist.description;
  }

  Future<void> _getGearItems(
      Packlist packlist, List<Tuple2> _list, PacklistService _service) async {
    // for (Tuple2 item in _list) {
    //   categories.add(await _service.getGearItemsInCategory(packlist, item.item2));
    // }
    categories.add(await service.getGearItemsInCategory(_packlist, 'carrying'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'sleepingGear'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'foodAndCookingEquipment'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'clothesPacked'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'clothesWorn'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'other'));
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    // ignore: unnecessary_statements
    _currentStep < 7 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    // ignore: unnecessary_statements
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  // dropdownformfield designed in regards to the figma
  buildDropDownFormField(List<String> data, String hint, String initialValue, Function setField) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: DropdownButtonFormField(
        key: GlobalKey(),
        // ignore: missing_return
        validator: (value) {
          if (value == null) return '';
        },
        hint: Text(hint),
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        value: initialValue,
        items: data.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            // valueToSet = newValue;
            print(initialValue);
            print(newValue);
            initialValue = newValue;
            setField(newValue);
            print(initialValue);
          });
        },
      ),
    );
  }

  _setSeason(String value) {
    this.season = value;
  }

  _setTag(String value) {
    this.tag = value;
  }

  // building the first step where user provide the overall details for the _packlist
  // TODO : needs translation
  _buildDetailsStep() {
    var texts = AppLocalizations.of(context);

    return Step(
      title: new Text(texts.details, style: Theme.of(context).textTheme.headline2),
      content: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Form(
          key: _detailsFormKey,
          child: Column(
            children: <Widget>[
              CustomTextFormField(
                null,
                texts.title,
                30,
                1,
                1,
                TextInputType.text,
                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                controller: titleController,
                validator: (String value) {
                  if (value.isEmpty) return '';
                  // if (!value.contains(RegExp(r'^[0-9]*$'))) return 'Only integers accepted';
                },
              ),
              CustomTextFormField(
                null,
                texts.amountOfDays,
                null,
                1,
                1,
                TextInputType.number,
                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                controller: amountOfDaysController,
                validator: (String value) {
                  if (value.isEmpty) return '';
                  // if (!value.contains(RegExp(r'^[0-9]*$'))) return 'Only integers accepted';
                },
              ),
              buildDropDownFormField(seasons, texts.season, this.season, _setSeason),
              buildDropDownFormField(tags, texts.category, this.tag, _setTag),
              CustomTextFormField(null, texts.description, 500, 10, 10, TextInputType.multiline,
                  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  controller: descriptionController,
                  inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'.', dotAll: true))),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  activeColor: Theme.of(context).primaryColor,
                  title: Text(
                    'Private',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  value: _isPrivate,
                  onChanged: (newValue) {
                    setState(() {
                      _isPrivate = newValue;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              )
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
  _buildPicturesRow(List<File> data) {
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

    return pictures;
  }

  // basically copied from Julian's implementation in profileView
  // no connection to firebase storage yet
  _uploadPicture() {
    return showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        builder: (BuildContext context) {
          var texts = AppLocalizations.of(context);

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Add picture to packlist',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(thickness: 1),
                ListTile(
                  title: Text(
                    texts.takePicture,
                    textAlign: TextAlign.center,
                  ),
                  // dense: true,
                  onTap: () async {
                    var tempImageFile = await ImageUploader.pickImage(ImageSource.camera);
                    var tempCroppedImageFile = await ImageUploader.cropImage(tempImageFile.path);

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
                  title: Text(
                    texts.chooseFromPhotoLibrary,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () async {
                    var tempImageFile = await ImageUploader.pickImage(ImageSource.gallery);
                    var tempCroppedImageFile = await ImageUploader.cropImage(tempImageFile.path);

                    setState(() {
                      images.add(tempCroppedImageFile);
                    });

                    Navigator.pop(context);
                  },
                ),
                Divider(thickness: 1),
                ListTile(
                  title: Text(
                    texts.close,
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

  _buildAddPicturesStep() {
    var texts = AppLocalizations.of(context);
    return Step(
      title: Text(texts.addPictures, style: Theme.of(context).textTheme.headline2),
      content: Container(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(texts.uploadPicturesForYourPacklist,
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ..._buildPicturesRow(images),
                  Container(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: IconButton(
                          iconSize: 45.0,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            images.length < 9
                                ? _uploadPicture() // open picture selector and add the picture to the images list
                                : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(texts
                                        .maxEightImages))); // snackbar informing user that you can't have more than 8 images
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
  _buildExistingItems(List<GearItem> data) {
    var expansionList = [];

    for (var item in data) {
      expansionList.add(
        Column(
          children: [
            new Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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

  _buildItemSteps() {
    List<Step> itemSteps = [];
    if (categories.isNotEmpty) {
      for (var i = 0; i < itemCategories.length; i++) {
        itemSteps.add(
          new Step(
            title: Text(
              itemCategories[i].item1,
              style: Theme.of(context).textTheme.headline2,
            ),
            isActive: true,
            content: Column(
              children: [
                ..._buildExistingItems(categories[i]),
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
    }
    return itemSteps;
  }

  _buildConfirm() {
    var texts = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Button(
          width: double.infinity,
          label: texts.confirm,
          onPressed: () {
            // _detailsFormKey.currentState.save();
            if (_detailsFormKey.currentState.validate() && images.isNotEmpty) {
              if (_packlist.createdAt == null) {
                _packlist.createdAt = Timestamp.now();
              }

              _packlist.title = titleController.text;
              _packlist.amountOfDays = amountOfDaysController.text;
              _packlist.season = season;
              _packlist.tag = tag;
              _packlist.description = descriptionController.text;
              _packlist.private = _isPrivate;
              _packlist.endorsed == null
                  ? _packlist.endorsed = false
                  // ignore: unnecessary_statements
                  : null;
              _packlist.allowComments = true;
              _packlist.createdBy = userProfileNotifier.userProfile.id;

              var totalweight = 0;
              var totalAmount = 0;

              var gearItems = <Tuple2<String, List<GearItem>>>[];

              for (int i = 0; i < categories.length; i++) {
                var tmpList = <GearItem>[];
                for (var item in categories[i]) {
                  item.createdAt = Timestamp.now();
                  tmpList.add(item);
                  totalweight += item.amount * item.weight;
                  totalAmount += item.amount;
                }
                gearItems.add(Tuple2(itemCategories[i].item2, tmpList));
              }

              _packlist.gearItemsAsTuples = gearItems;

              _packlist.totalWeight = totalweight;
              _packlist.totalAmount = totalAmount;

              _packlist.images = images;

              print(_packlist.title);
              print(_packlist.createdBy);
              print(_packlist.amountOfDays);
              print(_packlist.description);
              print(_packlist.endorsed);
              print(_packlist.season);
              print(_packlist.tag);
              print(_packlist.totalAmount);
              print(_packlist.totalWeight);

              if (!isUpdating) {
                print("create new packlist called in stepper");
                service.addNewPacklist(_packlist);
              } else {
                print("update packlist called in stepper");
                service.updatePacklist(_packlist, _packlist.toMap(), null);
              }

              Navigator.of(context).pop();
            } else if (images.isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(texts.youNeedToProvideAtLeastOneImage)));
            } else {
              setState(() {
                _currentStep = 0;
              });
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    itemCategories = [
      Tuple2(texts.carrying, 'carrying'),
      Tuple2(texts.sleepingGear, 'sleepingGear'),
      Tuple2(texts.foodAndCookingEquipment, 'foodAndCookingEquipment'),
      Tuple2(texts.clothesPacked, 'clothesPacked'),
      Tuple2(texts.clothesWorn, 'clothesWorn'),
      Tuple2(texts.other, 'other'),
    ];

    return Scaffold(
      body: SingleChildScrollView(
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
                            label: texts.continueLC,
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
                _buildDetailsStep(),
                _buildAddPicturesStep(),
                ..._buildItemSteps(),
              ],
            ),
            _buildConfirm()
          ],
        ),
      ),
    );
  }
}
