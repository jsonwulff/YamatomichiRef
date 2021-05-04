import 'package:app/constants/constants.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:app/ui/shared/form_fields/date_picker.dart';
import 'package:app/ui/shared/form_fields/region_dropdown.dart';
import 'package:app/ui/shared/loading_screen_with_navigation.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/utils/date_time_formatters.dart';
import 'package:app/ui/utils/form_fields_validators.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/profile/components/profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'components/gender_dropdown.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

// TODO: Don't make writes/update user profile if nothing changed and button is clicked
// TODO: Changing an existing profile picture should delete the old from Firebase storage
class _ProfileViewState extends State<ProfileView> {
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();
  final UserProfileService _profileService = UserProfileService();
  // Stream<UserProfile> userStream;

  final TextEditingController _dateController = TextEditingController();
  File _imageFile;
  File _croppedImageFile;
  bool _isImageUpdated;

  UserProfile _userProfile;
  String userUid;
  List<String> _logInMethods;

  List<String> currentRegions = ['Choose country'];
  bool changedRegion = false;

  @override
  void initState() {
    super.initState();
    userUid = context.read<AuthenticationService>().user.uid;
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      _profileService.getUserProfileAsNotifier(userUid, userProfileNotifier);
    }
    _getLogInMethods();
  }

  _getLogInMethods() async {
    List<String> logInMethods = await context.read<AuthenticationService>().loginMethods();
    setState(() {
      _logInMethods = logInMethods;
    });
  }

  Widget _buildSocialLinkingButton() {
    return SignInButton(
      Buttons.Google,
      text: "Link with Google account",
      onPressed: () async {
        String value = await context.read<AuthenticationService>().linkEmailWithGoogle();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      },
    );
  }

  _saveUserProfile(UserProfile userProfile) async {
    final _form = _formKey.currentState;
    // Show field validation errors
    if (!_form.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_isImageUpdated == true) {
      await _profileService.uploadUserProfileImage(userProfile, _croppedImageFile);
    }
    print(userProfile.toMap().toString());
    _profileService.updateUserProfile(userProfile, _onUserProfileUpdate);
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

  Widget _pofileImagePicker(UserProfile userProfile) {
    return InkWell(
      child: Text(
        "Change profile picture",
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () {
        imagePickerModal(
          context: context,
          modalTitle:
              userProfile.imageUrl == null ? 'Upload profile image' : 'Change profile image',
          cameraButtonText: 'Take profile picture',
          onCameraButtonTap: () async {
            var tempImageFile = await ImageUploader.pickImage(ImageSource.camera);
            var tempCroppedImageFile = await ImageUploader.cropImage(tempImageFile.path);
            _setImagesState(tempImageFile, tempCroppedImageFile);
          },
          photoLibraryButtonText: 'Choose from photo library',
          onPhotoLibraryButtonTap: () async {
            var tempImageFile = await ImageUploader.pickImage(ImageSource.gallery);
            var tempCroppedImageFile = await ImageUploader.cropImage(tempImageFile.path);
            _setImagesState(tempImageFile, tempCroppedImageFile);
          },
          showDeleteButton: userProfile.imageUrl != null,
          deleteButtonText: 'Delete existing profile picture',
          onDeleteButtonTap: () =>
              _profileService.deleteUserProfileImage(userProfile, _onUserProfileUpdate),
        );
      },
    );
  }

  Widget _namesRow(UserProfile userProfile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FirstNameField(context: context, userProfile: userProfile),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: LastNameField(context: context, userProfile: userProfile),
          ),
        ),
      ],
    );
  }

  void _setImagesState(File imageFile, File croppedImageFile) {
    setState(() {
      _imageFile = imageFile;
      _croppedImageFile = croppedImageFile;
      _isImageUpdated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context);
    FormFieldValidators formFieldValidators = FormFieldValidators(texts);
    UserProfile _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    final _names = Row(
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
    );

    if (_userProfile != null) {
      _dateController.text =
          _userProfile.birthday != null ? timestampToDate(_userProfile.birthday) : null;
      // Sets initial current region if already added to profile
      if (_userProfile.country != null && !changedRegion) {
        setState(() {
          currentRegions = countryRegions[_userProfile.country];
        });
      }

      return Scaffold(
        appBar: AppBarCustom.basicAppBarWithContextEmptyStack(
            texts.profile, context, personalProfileRoute),
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
                      onTap: () async {
                        if (_croppedImageFile != null) {
                          var tempCroppedImageFile = await ImageUploader.cropImage(_imageFile.path);
                          setState(() {
                            _croppedImageFile = tempCroppedImageFile;
                          });
                        }
                      },
                      child: ProfileAvatar(_userProfile, 50.0, _croppedImageFile)
                      /*CircleAvatar(
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
                      )*/
                      ,
                    ),
                  ),
                  _pofileImagePicker(_userProfile),
                  _names,
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DescriptionField(context: context, userProfile: _userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: EmailField(context: context, userProfile: _userProfile),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: GenderDropDown(userProfile: _userProfile)),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DatePicker(
                      controller: _dateController,
                      labelText: texts.birthday,
                      validator: (value) => formFieldValidators.userBirthday(value),
                      initialDate: _userProfile.birthday != null
                          ? _userProfile.birthday.toDate()
                          : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      initialDatePickerMode: DatePickerMode.year,
                      initialEntryMode: DatePickerEntryMode.input,
                      onPickedDate: (pickedDate) {
                        setState(() {
                          _userProfile.birthday = dateTimeToTimestamp(pickedDate);
                          _dateController.text = dateTimeToDate(pickedDate);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CountryDropdown(
                      hint: 'Prefered hiking country',
                      onSaved: (value) => _userProfile.country = value,
                      validator: (value) => formFieldValidators.userCountry(value),
                      initialValue: _userProfile.country,
                      onChanged: (value) {
                        setState(() {
                          if (currentRegions != null) {
                            _regionKey.currentState.reset();
                          }
                          currentRegions = countryRegions[value];
                          changedRegion = true;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RegionDropdown(
                      regionKey: _regionKey,
                      hint: 'Please select your prefered hiking region',
                      onSaved: (value) {
                        _userProfile.hikingRegion = value;
                      },
                      validator: (value) => formFieldValidators.userRegion(value),
                      initialValue: currentRegions.contains(_userProfile.hikingRegion)
                          ? _userProfile.hikingRegion
                          : null,
                      currentRegions: currentRegions,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _saveUserProfile(_userProfile),
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
        bottomNavigationBar: BottomNavBar(),
      );
    }

    // Loading screen
    return LoadingScreenWithNavigation(texts.editProfile);
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Flexible(
      child: TextFormField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        maxLength: 500,
        initialValue: userProfile.description ?? '',
        decoration: InputDecoration(
          labelText: texts.description,
        ),
        onSaved: (String value) {
          userProfile.description = value;
        },
        // width: MediaQuery.of(context).size.width / 2.6,
      ),
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
