import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserProfile _userProfile;
  User _user;
  TextEditingController _dateController = TextEditingController();
  List<String> _logInMethods;

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
    FirebaseAuth _firebaseAuth =
        context.read<AuthenticationService>().firebaseAuth;
    List<String> logInMethods =
        await _firebaseAuth.fetchSignInMethodsForEmail(_user.email);
    setState(() {
      _logInMethods = logInMethods;
    });
  }

  Widget _buildFirstNameField(UserProfile userProfile) {
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
        _userProfile.firstName = value;
      },
    );
  }

  Widget _buildLastNameField(UserProfile userProfile) {
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
        _userProfile.lastName = value;
      },
    );
  }

  Widget _buildEmailField(UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    return TextFormField(
      initialValue: userProfile.email ?? '',
      enabled: false,
      decoration: InputDecoration(
        labelText: texts.email,
      ),
    );
  }

  Widget _buildGenderDropDown(UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    return DropdownButton(
      isExpanded: true,
      value: userProfile.gender ?? texts.male,
      onChanged: (String newValue) {
        setState(() {
          userProfile.gender = newValue;
        });
      },
      items: <String>[texts.male, texts.female, texts.other]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildBirthdayField(BuildContext context, UserProfile userProfile) {
    var texts = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => _selectDate(context, userProfile),
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
        initialDate: userProfile.birthday != null
            ? userProfile.birthday.toDate()
            : DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        Timestamp timestamp = Timestamp.fromDate(picked);
        userProfile.birthday = timestamp;
        String formattedDate =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString()}";
        _dateController.text = formattedDate;
      });
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
    String value =
        await context.read<AuthenticationService>().linkEmailWithGoogle();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  _saveUserProfile() {
    print('saveUserProfile Called');
    final form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save();
    updateUserProfile(_userProfile, _onUserProfile);
  }

  _onUserProfile(UserProfile userProfile) {
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    userProfileNotifier.userProfile = userProfile;
  }

  _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    if (_userProfile == null) {
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

    _dateController.text = _userProfile.birthday != null
        ? _formatDateTime(_userProfile.birthday.toDate())
        : _formatDateTime(DateTime.now());

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildFirstNameField(_userProfile),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: _buildLastNameField(_userProfile),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildEmailField(_userProfile),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildGenderDropDown(_userProfile),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildBirthdayField(context, _userProfile),
                ),
                ElevatedButton(
                  onPressed: _saveUserProfile,
                  child: Text(texts.update),
                ),
                // Show google account link if not linked already
                if (_logInMethods != null &&
                    !_logInMethods.contains('google.com'))
                  _buildSocialLinkingButton(),
                if (_logInMethods != null &&
                    !_logInMethods.contains('password'))
                  InkWell(
                    child: Text(
                      texts.changePassword,
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, changePasswordRoute),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }
}
