import 'dart:io';

import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/dialogs/image_picker_modal.dart';
import 'package:app/ui/shared/form_fields/disabled_form_field.dart';
import 'package:app/ui/shared/loading_screen_with_navigation.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/utils/form_fields_validators.dart';
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:app/ui/views/profile/components/edit_profile_avatar.dart';
import 'package:app/ui/views/profile/components/user_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'components/profile_avatar.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserProfileService userProfileService = UserProfileService();

  UserProfileNotifier userProfileNotifier;
  UserProfile userProfile;
  List<String> logInMethods;
  File imageToBeUploaded;

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

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context);
    FormFieldValidators formFieldValidators = FormFieldValidators(texts);

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
