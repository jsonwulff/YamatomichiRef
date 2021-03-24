import 'package:app/constants.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import "dart:math";
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();
  final TextEditingController _dateController = TextEditingController();
  File _imageFile;
  File _croppedImageFile;
  bool _isImageUpdated;

  final _random = new Random();

  UserProfile _userProfile;
  User _user;
  List<String> _logInMethods;

  List<String> currentRegions = ['Choose country'];
  bool changedRegion = false;

  @override
  void initState() {
    super.initState();
    print('Initializing state');
    _user = context.read<AuthenticationService>().user;
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      getUserProfile(_user.uid, userProfileNotifier);
    }
    _getLogInMethods();
  }

  _getLogInMethods() async {
    FirebaseAuth _firebaseAuth = context.read<AuthenticationService>().firebaseAuth;
    List<String> logInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(_user.email);
    setState(() {
      _logInMethods = logInMethods;
    });
  }

  Widget _buildBirthdayField(BuildContext context, UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => _selectDate(context, userProfile),
      // onTap: () {},
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: texts.birthday,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return texts.pleaseFillInYourBirthday;
            }
            return null;
          },
        ),
      ),
    );
  }

  _selectDate(BuildContext context, UserProfile userProfile) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: userProfile.birthday != null ? userProfile.birthday.toDate() : DateTime.now(),
        initialEntryMode: DatePickerEntryMode.input,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        Timestamp timestamp = Timestamp.fromDate(picked);
        userProfile.birthday = timestamp;
        String formattedDate = _formatDateTime(picked);
        _dateController.text = formattedDate;
      });
  }

  _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
  }

  Widget _buildCountryDropdown(UserProfile userProfile) {
    return DropdownButtonFormField(
      hint: Text('Please select your prefered hiking country'),
      onSaved: (String value) {
        userProfile.country = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Please fill in your prefered hiking country';
        }
        return null;
      },
      value: userProfile.country, // Intial value
      onChanged: (value) {
        setState(() {
          if (currentRegions != null) {
            _regionKey.currentState.reset();
          }
          currentRegions = countryRegions[value];
          changedRegion = true;
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
    return DropdownButtonFormField(
      key: _regionKey,
      hint: Text('Please select your prefered hiking region'),
      onSaved: (String value) {
        userProfile.hikingRegion = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Please fill in your prefered hiking region';
        } else if (value == 'Choose country') {
          return 'Please choose a country above and select region next';
        }
        return null;
      },
      value: currentRegions.contains(userProfile.hikingRegion)
          ? userProfile.hikingRegion
          : null, // Intial value
      onChanged: (value) {},
      items: currentRegions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildSocialLinkingButton() {
    return SignInButton(
      Buttons.Google,
      text: "Link with Google account",
      onPressed: () {
        _linkWithGoogle();
      },
    );
  }

  _linkWithGoogle() async {
    String value = await context.read<AuthenticationService>().linkEmailWithGoogle();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  _saveUserProfile(UserProfile userProfile) {
    final _form = _formKey.currentState;
    // Show field validation errors
    if (!_form.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_isImageUpdated == true) {
      String filePath = 'profileImages/${userProfile.id}/${DateTime.now()}.jpg';
      Reference reference = _storage.ref().child(filePath);
      reference.putFile(_croppedImageFile).whenComplete(() async {
        userProfile.imageUrl = (await reference.getDownloadURL());
        updateUserProfile(userProfile, _onUserProfileUpdate);
      });
    } else {
      updateUserProfile(userProfile, _onUserProfileUpdate);
    }
  }

  void _deleteProfileImage(UserProfile userProfile) {
    String filePath = 'profileImages/${userProfile.id}/${DateTime.now()}.jpg';
    Reference reference = _storage.ref().child(filePath);
    reference.delete().whenComplete(() {
      userProfile.imageUrl = null;
      updateUserProfile(userProfile, _onUserProfileUpdate);
    });
  }

  _onUserProfileUpdate(UserProfile userProfile) {
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    userProfileNotifier.userProfile = userProfile;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User profile updated'),
      ),
    );
  }

  _pickImageWithInstanCrop(ImageSource source) async {
    PickedFile selected = await ImagePicker().getImage(source: source);
    File cropped;

    if (selected != null) {
      cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        maxHeight: 256,
        maxWidth: 256,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 40,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop profile image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop profile image',
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
        ),
      );
    }

    if (cropped != null) {
      print('Setting cropped image');
      setState(() {
        _imageFile = File(selected.path);
        _croppedImageFile = cropped;
        _isImageUpdated = true;
      });
    }
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        maxHeight: 256,
        maxWidth: 256,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 40,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white));
    setState(() {
      _croppedImageFile = cropped ?? _imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    if (_userProfile != null) {
      _dateController.text =
          _userProfile.birthday != null ? _formatDateTime(_userProfile.birthday.toDate()) : null;
      // Sets initial current region if already added to profile
      if (_userProfile.country != null && !changedRegion) {
        setState(() {
          currentRegions = countryRegions[_userProfile.country];
        });
      }

      if (_logInMethods != null) {
        print(_logInMethods.toString());
      }

      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(texts.profile),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: GestureDetector(
                      onTap: () {
                        if (_croppedImageFile != null) {
                          _cropImage();
                        }
                      },
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: _croppedImageFile == null
                            ? _userProfile.imageUrl != null
                                ? NetworkImage(_userProfile.imageUrl)
                                : null
                            : FileImage(_croppedImageFile),
                        child: _croppedImageFile == null
                            ? _userProfile.imageUrl != null
                                ? null
                                : Text(
                                    _userProfile.firstName[0] + _userProfile.lastName[0],
                                    style: TextStyle(fontSize: 40, color: Colors.white),
                                  )
                            : Icon(
                                Icons.edit,
                                size: 32,
                                color: Colors.white,
                              ),
                        backgroundColor:
                            profileImageColors[_random.nextInt(profileImageColors.length)],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      "Change profile picture",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                        ),
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              // height: 330,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    _userProfile.imageUrl == null
                                        ? 'Upload profile image'
                                        : 'Change profile image',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(thickness: 1),
                                ListTile(
                                  title: const Text(
                                    'Take profile picture',
                                    textAlign: TextAlign.center,
                                  ),
                                  // dense: true,
                                  onTap: () {
                                    _pickImageWithInstanCrop(ImageSource.camera);
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
                                  onTap: () {
                                    _pickImageWithInstanCrop(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                                if (_userProfile.imageUrl != null) Divider(thickness: 1),
                                if (_userProfile.imageUrl != null)
                                  ListTile(
                                    title: const Text(
                                      'Delete existing profile picture',
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      _deleteProfileImage(_userProfile);
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
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: FirstNameField(context: context, userProfile: _userProfile),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: LastNameField(context: context, userProfile: _userProfile),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: EmailField(context: context, userProfile: _userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GenderDropDown(context: context, userProfile: _userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildBirthdayField(context, _userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildCountryDropdown(_userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildHikingRegionDropDown(_userProfile),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveUserProfile(_userProfile);
                    },
                    child: Text("Update"),
                  ),
                  // Show google account link if not linked already
                  if (_logInMethods != null && !_logInMethods.contains('google.com'))
                    _buildSocialLinkingButton(),
                  if (_logInMethods != null && _logInMethods.contains('password'))
                    InkWell(
                      child: Text(
                        texts.changePassword,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => Navigator.pushNamed(context, changePasswordRoute),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Loading screen
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(texts.profile),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }
}

class GenderDropDown extends StatelessWidget {
  const GenderDropDown({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text('Please select your gender'),
      onSaved: (String value) {
        userProfile.gender = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Please provide your gender';
        }
        return null;
      },
      value: userProfile.gender, // Intial value
      onChanged: (value) {},
      items: gendersList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;
  // TODO: Give this some style of input hint to show that i cant be edited
  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return TextFormField(
      initialValue: userProfile.email ?? '',
      enabled: false,
      decoration: InputDecoration(
        labelText: texts.email,
      ),
    );
  }
}

class LastNameField extends StatelessWidget {
  const LastNameField({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return TextFormField(
      decoration: InputDecoration(labelText: texts.lastName),
      initialValue: userProfile.lastName ?? '',
      validator: (String value) {
        if (value.isEmpty) {
          return texts.pleaseFillInLastName;
        } else if (value.length < 2 || value.length > 32) {
          return texts.lastNameMustBeMoreThan2and32;
        }
        return null;
      },
      onSaved: (String value) {
        userProfile.lastName = value;
      },
    );
  }
}

class FirstNameField extends StatelessWidget {
  const FirstNameField({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return TextFormField(
      decoration: InputDecoration(labelText: texts.firstName),
      initialValue: userProfile.firstName ?? '',
      validator: (String value) {
        if (value.isEmpty) {
          return texts.pleaseFillInFirstName;
        } else if (value.length < 2 || value.length > 32) {
          return texts.firstNameMustBeMoreThan2and32;
        }
        return null;
      },
      onSaved: (String value) {
        userProfile.firstName = value;
      },
    );
  }
}
