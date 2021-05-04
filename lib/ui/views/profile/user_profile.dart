import 'dart:io';

import 'package:app/constants/constants.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:app/ui/shared/form_fields/date_picker.dart';
import 'package:app/ui/shared/form_fields/disabled_form_field.dart';
import 'package:app/ui/shared/form_fields/region_dropdown.dart';
import 'package:app/ui/shared/loading_screen_with_navigation.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/utils/date_time_formatters.dart';
import 'package:app/ui/utils/form_fields_validators.dart';
import 'package:app/ui/views/profile/components/description_field.dart';
import 'package:app/ui/views/profile/components/edit_profile_avatar.dart';
import 'package:app/ui/views/profile/components/gender_dropdown.dart';
import 'package:app/ui/views/profile/components/user_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserProfileService userProfileService = UserProfileService();
  final TextEditingController _birthdayController = TextEditingController();
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();

  UserProfileNotifier userProfileNotifier;
  UserProfile userProfile;
  AppLocalizations texts;
  FormFieldValidators formFieldValidators;
  File imageToBeUploaded;
  List<String> currentRegions = ['Choose country'];
  bool changedRegion = false;
  List<String> logInMethods;

  @override
  void initState() {
    super.initState();
    String userUID = context.read<AuthenticationService>().user.uid;
    userProfileNotifier = Provider.of(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      userProfileService.getUserProfileAsNotifier(userUID, userProfileNotifier);
    }
    // logInMethods = await context.read<AuthenticationService>().loginMethods();
  }

  void setUploadImage(File image) {
    setState(() {
      imageToBeUploaded = image;
    });
  }

  void saveUserProfile() async {
    final currentFormState = formKey.currentState;

    if (!currentFormState.validate()) {
      return; // Show validation errors
    }
    if (imageToBeUploaded != null) {
      await userProfileService.uploadUserProfileImage(userProfile, imageToBeUploaded);
    }

    currentFormState.save();

    print(userProfile.toMap().toString());
  }

  Widget _buildBirthDayField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DatePicker(
        controller: _birthdayController,
        labelText: texts.birthday,
        validator: (value) => formFieldValidators.userBirthday(value),
        initialDate: userProfile.birthday != null ? userProfile.birthday.toDate() : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        initialDatePickerMode: DatePickerMode.year,
        initialEntryMode: DatePickerEntryMode.input,
        onPickedDate: (pickedDate) {
          setState(() {
            userProfile.birthday = dateTimeToTimestamp(pickedDate);
            _birthdayController.text = dateTimeToDate(pickedDate);
          });
        },
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CountryDropdown(
        hint: 'Prefered hiking country',
        onSaved: (value) => userProfile.country = value,
        validator: (value) => formFieldValidators.userCountry(value),
        initialValue: userProfile.country,
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
    );
  }

  Widget _buildRegionDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RegionDropdown(
        regionKey: _regionKey,
        hint: 'Prefered hiking region',
        onSaved: (value) {
          userProfile.hikingRegion = value;
        },
        validator: (value) => formFieldValidators.userRegion(value),
        initialValue:
            currentRegions.contains(userProfile.hikingRegion) ? userProfile.hikingRegion : null,
        currentRegions: currentRegions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    texts = AppLocalizations.of(context);
    formFieldValidators = FormFieldValidators(texts);
    userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    if (userProfile != null) {
      return Scaffold(
        appBar: AppBarCustom.basicAppBar(texts.profile, context),
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EditProfileAvatar(
                    userProfile: userProfile,
                    setUploadImage: setUploadImage,
                  ),
                  UserNames(
                    userProfile,
                    texts.firstName,
                    texts.lastName,
                    formFieldValidators.userFirstName,
                    formFieldValidators.userLastName,
                  ),
                  DisabledFormField(
                    labelText: texts.email,
                    initialValue: userProfile.email,
                    helperText: 'Email cannot be editted',
                  ),
                  GenderDropDown(userProfile: userProfile),
                  _buildBirthDayField(),
                  // TODO: Consider compaunding country and region
                  _buildCountryDropdown(),
                  _buildRegionDropdown(),
                  // DescriptionField(context: context, userProfile: userProfile),
                  ElevatedButton(
                    onPressed: () => saveUserProfile(),
                    child: Text(texts.update),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    // TODO: Consider showing the loading screen in scaffold instead
    return LoadingScreenWithNavigation(texts.editProfile);
  }
}
