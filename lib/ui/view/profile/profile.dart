import 'package:app/constants.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "dart:math";

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _random = new Random();

  UserProfile _userProfile;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Initializing state');
    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      String userUid = context.read<AuthenticationService>().user.uid;
      getUserProfile(userUid, userProfileNotifier);
    }
  }

  Widget _buildFirstNameField(UserProfile userProfile) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First name'),
      initialValue: userProfile.firstName ?? '',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please fill in first name';
        } else if (value.length < 2 || value.length > 32) {
          return 'First mame must be more than 2 and less than 32';
        }
        return null;
      },
      onSaved: (String value) {
        _userProfile.firstName = value;
      },
    );
  }

  Widget _buildLastNameField(UserProfile userProfile) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last name'),
      initialValue: userProfile.lastName ?? '',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please fill in last name';
        } else if (value.length < 2 || value.length > 32) {
          return 'Last name must be more than 2 and less than 32';
        }
        return null;
      },
      onSaved: (String value) {
        _userProfile.lastName = value;
      },
    );
  }

  Widget _buildEmailField(UserProfile userProfile) {
    return TextFormField(
      initialValue: userProfile.email ?? '',
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Email',
      ),
    );
  }

  Widget _buildGenderDropDown(UserProfile userProfile) {
    return DropdownButton(
      isExpanded: true,
      value: userProfile.gender ?? 'Male',
      onChanged: (String newValue) {
        setState(() {
          userProfile.gender = newValue;
        });
      },
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildBirthdayField(BuildContext context, UserProfile userProfile) {
    return GestureDetector(
      onTap: () => _selectDate(context, userProfile),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: "Birthday",
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please fill in your birthday';
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

  Widget _profileAvatar(UserProfile userProfile) {}

  _saveUserProfile() {
    print('saveUserProfile Called');
    final _form = _formKey.currentState;
    if (!_form.validate()) {
      return;
    }
    _formKey.currentState.save();
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
    print('Building profile view');
    _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    if (_userProfile == null) {
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text('Profile'),
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

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Profile'),
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
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: profileImageColors[
                        _random.nextInt(profileImageColors.length)],
                    child: Text(
                      _userProfile.firstName[0] + _userProfile.lastName[0],
                      style: TextStyle(fontSize: 40, color: Colors.white),
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
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
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
                                  'Change profile image',
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
                                onTap: () {},
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
                                onTap: () {},
                              ),
                              Divider(thickness: 1),
                              ListTile(
                                title: const Text(
                                  'Delete existing profile picture',
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {},
                              ),
                              Divider(thickness: 1),
                              ListTile(
                                title: const Text(
                                  'Close BottomSheet',
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
                  child: Text("Update"),
                ),
                InkWell(
                  child: Text(
                    "Change password",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () => Navigator.pushNamed(context, unknownRoute),
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
