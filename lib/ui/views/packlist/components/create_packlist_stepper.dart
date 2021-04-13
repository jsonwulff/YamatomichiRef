import 'dart:io';

import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreatePacklistStepperView extends StatefulWidget {
  @override
  _CreatePacklistStepperViewState createState() => _CreatePacklistStepperViewState();
}

class _CreatePacklistStepperViewState extends State<CreatePacklistStepperView> {
  
  // stepper variables
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  // image files uploaded by user
  var images = <File>[];

  // static lists for dropdownmenues
  // TODO : need translation
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

  buildPicturesRow(List<File> data) {
    List<Widget> pictures = [];
    for (var pic in data) {
      pictures.add(Container(
        margin: EdgeInsets.only(right: 10.0),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image:
                DecorationImage(image: FileImage(pic), fit: BoxFit.cover)),
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
      title: Text('Add pictures'),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text('Upload pictures for your packlist'),
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
                            : ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Max 4 images'))); // snackbar informing user that you can't have more than 4 images
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
                  buildAddPicturesStep(),
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
