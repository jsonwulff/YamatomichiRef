import 'dart:io';

import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_text_form_field.dart';

class CreatePacklistStepperView extends StatefulWidget {
  @override
  _CreatePacklistStepperViewState createState() =>
      _CreatePacklistStepperViewState();
}

class _CreatePacklistStepperViewState extends State<CreatePacklistStepperView> {
  // stepper variables
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

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

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
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

  // textformfield designed in regards to the figma
  // TODO : delete this when refactoring is done
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

  // dropdownformfield designed in regards to the figma
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

  // building the first step where user provide the overall details for the packlist
  // TODO : needs translation
  // TODO : use the extracted class for custom fext form fields
  Step buildDetailsStep() {
    return Step(
      title: new Text('Details', style: Theme.of(context).textTheme.headline2),
      content: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            buildTextFormField('Please provide a title for the packlist',
                'Title', 50, 1, 1, TextInputType.text),
            buildTextFormField('How many days is the packlist suited for',
                'Amount of days', null, 1, 1, TextInputType.number),
            buildDropDownFormField(seasons, 'Season', null),
            buildDropDownFormField(tags, 'Tag', null),
            buildTextFormField('Please provide a description of your packlist',
                'Description', 500, 10, 10, TextInputType.multiline),
          ],
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
        margin: EdgeInsets.only(right: 10.0),
        width: 60.0,
        height: 60.0,
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
                      images.add(tempCroppedImageFile);
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
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text('Upload pictures for your packlist',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...buildPicturesRow(images),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        images.length <= 5
                            ? uploadPicture() // open picture selector and add the picture to the images list
                            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Max 4 images'))); // snackbar informing user that you can't have more than 4 images
                      })
                ],
              ),
            ),
          ]),
      isActive: true,
      // state: _currentStep >= 1
      //     ? StepState.complete
      //     : StepState.disabled,
    );
  }

  // build items step helpers
  // should take a list of map<string, object> of items already added
  buildExistingItems() {
    var listOfData = [];

    // var data1 = Map();
    // data1['title'] = 'test title';
    // data1['weight'] = 0.0;
    // data1['amount'] = 5;
    // data1['link'] = 'url';
    // data1['brand'] = 'test brand';

    // var data2 = Map();
    // data2['title'] = 'test title yo yo yo yo yo yo yo yo yo yo';
    // data2['weight'] = 0.0;
    // data2['amount'] = 2;
    // data2['link'] = 'url';
    // data2['brand'] = 'test brand';

    // listOfData.add(data1);
    // listOfData.add(data2);

    List<Widget> expansionList = [];

    for (var item in listOfData) {
      var itemMap = item;
      expansionList.add(
        Column(
          children: [
            new Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: new ExpansionTile(
                tilePadding: EdgeInsets.all(0.0),
                title: Text(
                  itemMap['title'] + ' x ' + itemMap['amount'].toString(),
                  style: Theme.of(context).textTheme.headline3,
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  AddItemSpawner(
                    false,
                    itemMap: itemMap,
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

  buildItemSteps() {
    List<Step> itemSteps = [];
    for (var category in itemCategories) {
      itemSteps.add(
        new Step(
          title: Text(
            category,
            style: Theme.of(context).textTheme.headline2,
          ),
          isActive: true,
          content: Column(
            children: [...buildExistingItems(), AddItemSpawner(true)],
          ),
        ),
      );
    }
    return itemSteps;
  }

  buildConfirmStep() {
    return Button(
        label: 'Confirm',
        onPressed: () {
          Navigator.of(context).pop();
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
                type: stepperType,
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
                              onPressed: () => continued(),
                            ),
                            Container()
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
              buildConfirmStep()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: switchStepsType,
      ),
    );
  }
}

// ignore: must_be_immutable
class AddItemSpawner extends StatelessWidget {
  // TODO : needs translation

  Map itemMap;
  TextEditingController controller = new TextEditingController();
  final bool isNew;

  AddItemSpawner(this.isNew, {this.itemMap});

  @override
  Widget build(BuildContext context) {
    if (itemMap == null) {
      itemMap = new Map();
      itemMap['title'] = 'Item name';
      itemMap['weight'] = 'Weigth';
      itemMap['amount'] = 'Amount';
      itemMap['link'] = 'Link';
      itemMap['brand'] = 'Brand';
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            child: Text(isNew ? 'Add item' : 'Edit item',
                style: Theme.of(context).textTheme.headline3),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: CustomTextFormField(
                        null,
                        itemMap['title'],
                        null,
                        1,
                        1,
                        TextInputType.text,
                        EdgeInsets.fromLTRB(0.0, 0, 5.0, 0))),
                Expanded(
                    flex: 1,
                    child: CustomTextFormField(
                        null,
                        itemMap['weight'].toString(),
                        null,
                        1,
                        1,
                        TextInputType.number,
                        EdgeInsets.fromLTRB(0.0, 0, 5.0, 0))),
                Expanded(
                    flex: 1,
                    child: CustomTextFormField(
                        null,
                        itemMap['amount'].toString(),
                        null,
                        1,
                        1,
                        TextInputType.number,
                        EdgeInsets.fromLTRB(0.0, 0, 0, 0)))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: CustomTextFormField(
                        null,
                        itemMap['link'],
                        null,
                        1,
                        1,
                        TextInputType.url,
                        EdgeInsets.fromLTRB(0.0, 0, 5.0, 0))),
                Expanded(
                    flex: 1,
                    child: CustomTextFormField(
                        null,
                        itemMap['brand'],
                        null,
                        1,
                        1,
                        TextInputType.text,
                        EdgeInsets.fromLTRB(0.0, 0, 0, 0))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.done_rounded), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.delete_outline_rounded), onPressed: () {})
              ],
            ),
          ),
          Divider(thickness: 1)
        ],
      ),
    );
  }
}
