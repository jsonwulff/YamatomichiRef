import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/loading_screen_with_navigation.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/utils/form_fields_validators.dart';
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

  UserProfileNotifier userProfileNotifier;
  UserProfile userProfile;
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

  void saveUserProfile() async {
    final currentFormState = formKey.currentState;

    if (!currentFormState.validate()) {
      return; // Show validation errors
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
                  ProfileAvatar(),
                  UserNames(
                    userProfile,
                    texts.firstName,
                    texts.lastName,
                    formFieldValidators.userFirstName,
                    formFieldValidators.userLastName,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: userProfile.email ?? '',
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: texts.email,
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
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

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Theme.of(context).primaryColor,
      child: CircleAvatar(
        radius: 47,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 44,
          backgroundColor: Colors.red,
          child: Text(
            'JW',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
