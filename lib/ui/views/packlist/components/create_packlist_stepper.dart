import 'dart:io';
import 'dart:math';

import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/packlist_service.dart';
import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';
import 'package:app/ui/shared/dialogs/img_pop_up.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:tuple/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

import '../packlist_page.dart';
import '../../../shared/form_fields/custom_text_form_field.dart';
import 'gear_item_spawner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePacklistStepperView extends StatefulWidget {
  @override
  _CreatePacklistStepperViewState createState() => _CreatePacklistStepperViewState();
}

class _CreatePacklistStepperViewState extends State<CreatePacklistStepperView> {
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

  // _user.id get user in session
  Packlist _packlist;

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
  List<dynamic> images = [];
  List<File> newImages = [];
  // List<dynamic> imagesDynamicList = [];
  List<dynamic> dynamicImages = [];
  List<dynamic> imagesMarkedForDeletion = [];
  dynamic mainImage;
  // ignore: unused_field
  bool _isImageUpdated;

  ScrollController _scrollController = new ScrollController(
    keepScrollOffset: false,
  );

  // static lists for dropdownmenues
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

  // used for updating/deleting existing gearitems when editing packlist
  List<Tuple2<String, GearItem>> tmpListForDelete = [];
  List<Tuple2<String, GearItem>> tmpListForUpdate = [];

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
    }

    if (packlistNotifier.packlist != null) {
      _packlist = packlistNotifier.packlist;
      isUpdating = true;
      // ignore: unnecessary_statements
      _packlist.mainImage != null ? mainImage = _packlist.mainImage : null;
      images = _packlist.imageUrl;
      _getGearItems(_packlist, itemCategories, service).then((value) => setState(() {}));
      _isPrivate = _packlist.private;
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

    titleController.text = _packlist.title;
    amountOfDaysController.text = _packlist.amountOfDays;
    season = _packlist.season;
    tag = _packlist.tag;
    descriptionController.text = _packlist.description;
  }

  Future<void> _getGearItems(
      Packlist packlist, List<Tuple2> _list, PacklistService _service) async {
    categories.add(await service.getGearItemsInCategory(_packlist, 'carrying'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'sleepingGear'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'foodAndCookingEquipment'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'clothesPacked'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'clothesWorn'));
    categories.add(await service.getGearItemsInCategory(_packlist, 'other'));
  }

  tapped(int step) {
    setState(() {
      _currentStep = step;
      _scrollController.jumpTo(step.toDouble());
    });
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
                50,
                1,
                1,
                TextInputType.text,
                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                controller: titleController,
                validator: (String value) {
                  if (value.isEmpty) return '';
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

  void _setImagesState() {
    setState(() {
      print('set state');
      _isImageUpdated = true;
    });
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

  void eventPreviewPopUp(dynamic url) async {
    String answer = await imgChoiceDialog(url, context: context, isPacklist: true);
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

  _buildAddPicturesStep() {
    var texts = AppLocalizations.of(context);

    return Step(
      title: new Text(texts.addPictures, style: Theme.of(context).textTheme.headline2),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 16.0),
              child: InkWell(
                  child: Text(
                    texts.addPictures,
                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                  ),
                  onTap: () {
                    picture();
                  }),
            ),
            picturePreview(),
          ],
        ),
      ),
      isActive: true,
      // state: widget.editing
      //     ? StepState.complete
      //     : _currentStep >= 4
      //         ? StepState.complete
      //         : StepState.disabled,
    );
  }

  // build items step helpers
  // should take a list of map<string, object> of items already added to the category
  _buildExistingItems(List<GearItem> data, String categoryInFirestore) {
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
                    removedItems: tmpListForDelete,
                    updatedItems: tmpListForUpdate,
                    category: categoryInFirestore,
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
                ..._buildExistingItems(categories[i], itemCategories[i].item2),
                isAddingNewItem
                    ? GearItemSpawner(
                        true,
                        categories[i],
                        despawn: _updateIsAddingNewItem,
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
          height: 35.0,
          label: texts.confirm,
          onPressed: () async {
            if (_detailsFormKey.currentState.validate()) {
              if (_packlist.createdAt == null) {
                _packlist.createdAt = Timestamp.now();
              }

              _packlist.title = titleController.text;
              _packlist.amountOfDays = amountOfDaysController.text;
              _packlist.season = season;
              _packlist.tag = tag;
              _packlist.description = descriptionController.text;
              _packlist.private = _isPrivate;
              _packlist.allowComments = true;
              _packlist.createdBy = userProfileNotifier.userProfile.id;

              var totalweight = 0;
              var totalAmount = 0;

              var gearItems = <Tuple2<String, List<GearItem>>>[];

              List<Tuple2<String, GearItem>> itemsToBeAdded = [];

              for (int i = 0; i < categories.length; i++) {
                var tmpList = <GearItem>[];
                for (var item in categories[i]) {
                  item.createdAt = Timestamp.now();
                  tmpList.add(item);
                  if (item.id == null) {
                    itemsToBeAdded.add(Tuple2(itemCategories[i].item2, item));
                  }
                  totalweight += item.amount * item.weight;
                  totalAmount += item.amount;
                }
                gearItems.add(Tuple2(itemCategories[i].item2, tmpList));
              }

              _packlist.gearItemsAsTuples = gearItems;

              _packlist.totalWeight = totalweight;
              _packlist.totalAmount = totalAmount;

              if (mainImage is File) {
                var tmpList = await service.addNewImagesToPacklist(_packlist, [mainImage]);
                mainImage = tmpList[0];
              }

              _packlist.mainImage = mainImage;

              if (!isUpdating) {
                _packlist.images = newImages;

                service.addNewPacklist(_packlist, packlistNotifier);
                packlistNotifier.packlist = _packlist;
                Navigator.pop(context);
                pushNewScreen(context, screen: PacklistPageView(), withNavBar: false);
              } else {
                if (newImages.isNotEmpty) {
                  images.addAll(await service.addNewImagesToPacklist(_packlist, newImages));
                }

                if (imagesMarkedForDeletion.isNotEmpty) {
                  for (dynamic d in imagesMarkedForDeletion) {
                    // ignore: unnecessary_statements
                    d is String ? service.deleteImage(d, _packlist) : null;
                  }
                }

                _packlist.imageUrl = images;

                service.updateGearItems(tmpListForUpdate, _packlist);
                service.deleteGearItems(tmpListForDelete, _packlist);
                service.addGearItems(itemsToBeAdded, _packlist);
                service.updatePacklist(_packlist, _packlist.toMap(), null);

                packlistNotifier.packlist = _packlist;

                Navigator.pop(context);
                Navigator.pop(context);
                pushNewScreen(context, screen: PacklistPageView(), withNavBar: false);
              }
            } else {
              setState(() {
                _currentStep = 0;
              });
            }
          }),
    );
  }

  _buildCancel() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Button(
        width: double.infinity,
        height: 35.0,
        label: AppLocalizations.of(context).cancel,
        backgroundColor: Colors.red,
        onPressed: () async {
          if (await simpleChoiceDialog(
              context, AppLocalizations.of(context).areYouSureChangesWillBeLost)) {
            Navigator.pop(context);
          }
        },
      ),
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

    return FocusWatcher(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          elevation: 0,
          title: Text(
            // Check route whether or not you have the intention of edit or create
            isUpdating ? texts.editPacklist : texts.createPacklist,
            style: Theme.of(context).textTheme.headline1,
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () async {
              if (await simpleChoiceDialog(
                  context, AppLocalizations.of(context).areYouSureChangesWillBeLost)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stepper(
                key: Key(Random.secure()
                    .nextDouble()
                    .toString()), // shout out to 'gersur' https://github.com/flutter/flutter/issues/27187
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
              _buildConfirm(),
              _buildCancel(),
            ],
          ),
        ),
      ),
    );
  }
}
