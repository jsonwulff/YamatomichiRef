import 'dart:io';
import 'package:app/constants/countryRegion.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/country_dropdown.dart';
import 'package:app/ui/shared/form_fields/date_picker.dart';
import 'package:app/ui/shared/form_fields/disabled_form_field.dart';
import 'package:app/ui/shared/form_fields/region_dropdown.dart';
import 'package:app/ui/shared/loading_screen_with_navigation.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/utils/date_time_formatters.dart';
import 'package:app/ui/utils/form_fields_validators.dart';
import 'package:app/ui/views/profile/components/description_field.dart';
import 'package:app/ui/views/profile/components/edit_profile_avatar.dart';
import 'package:app/ui/views/profile/components/gender_dropdown.dart';
import 'package:app/ui/views/profile/components/social_link_buttons.dart';
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
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();
  final UserProfileService userProfileService = UserProfileService();
  final TextEditingController _birthdayController = TextEditingController();

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
  }

  void setUploadImage(File image) {
    setState(() {
      imageToBeUploaded = image;
    });
  }

  void deleteUploadImage() {
    userProfileService.deleteUserProfileImage(userProfile, _onUserProfileUpdate);
  }

  void saveUserProfile() async {
    final currentFormState = formKey.currentState;
    // Show validation errors
    if (!currentFormState.validate()) {
      return;
    }
    currentFormState.save();
    if (imageToBeUploaded != null) {
      await userProfileService.uploadUserProfileImage(userProfile, imageToBeUploaded);
    }
    userProfileService.updateUserProfile(userProfile, _onUserProfileUpdate);

    print(userProfile.toMap().toString());
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
        label: texts.selectPrefferedCountry,
        onSaved: (value) => userProfile.country = value,
        validator: (value) => formFieldValidators.userCountry(value),
        initialValue: userProfile.country,
        onChanged: (value) {
          setState(() {
            if (currentRegions != null) {
              _regionKey.currentState.reset();
            }
            currentRegions = getCountriesRegionsTranslated(context)[value];
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
        label: texts.selectPrefferedRegion,
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

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10),
      child: Button(
        label: texts.update,
        width: MediaQuery.of(context).size.width / 2,
        onPressed: () => saveUserProfile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    texts = AppLocalizations.of(context);
    formFieldValidators = FormFieldValidators(texts);
    userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    if (userProfile != null) {
      _birthdayController.text =
          userProfile.birthday != null ? timestampToDate(userProfile.birthday) : null;
      if (userProfile.country != null)
        currentRegions = getCountriesRegionsTranslated(context)[userProfile.country];

      return Scaffold(
        appBar: AppBarCustom.basicAppBar(texts.profile, context),
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
                    deleteUploadImage: deleteUploadImage,
                  ),
                  DescriptionField(
                    userProfile: userProfile,
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
                  GenderDropDown(
                    userProfile: userProfile,
                    validator: formFieldValidators.userGender,
                  ),
                  _buildBirthDayField(),
                  // TODO: Consider compaunding country and region
                  _buildCountryDropdown(),
                  _buildRegionDropdown(),
                  _buildUpdateButton(),
                  SocialLinkButtons(),
                  SizedBox(height: 30),
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
