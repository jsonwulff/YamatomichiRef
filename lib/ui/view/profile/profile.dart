import 'package:app/constants.dart';
import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _regionKey = GlobalKey<FormFieldState>();

  TextEditingController _dateController = TextEditingController();
  List<String> currentRegions = ['Choose country'];
  bool changedRegion = false;

  @override
  void initState() {
    super.initState();
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
        userProfile.firstName = value;
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
        userProfile.lastName = value;
      },
    );
  }

  // TODO: Give this some style of input hint to show that it cant be edited
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
    return DropdownButtonFormField(
      hint: Text('Please select your gender'),
      onSaved: (String value) {
        userProfile.gender = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Please fill in your birthday';
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

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile =
        Provider.of<UserProfileNotifier>(context).userProfile;

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

    _saveUserProfile() {
      final _form = _formKey.currentState;
      // Show field validation errors
      if (!_form.validate()) {
        return;
      }
      _formKey.currentState.save();
      updateUserProfile(userProfile, _onUserProfileUpdate);
    }

    if (userProfile != null) {
      _dateController.text = userProfile.birthday != null
          ? _formatDateTime(userProfile.birthday.toDate())
          : null;
      // Sets initial current region if already added to profile
      if (userProfile.country != null && !changedRegion) {
        setState(() {
          currentRegions = countryRegions[userProfile.country];
        });
      }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _buildFirstNameField(userProfile),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _buildLastNameField(userProfile),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildEmailField(userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildGenderDropDown(userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildBirthdayField(context, userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildCountryDropdown(userProfile),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildHikingRegionDropDown(userProfile),
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
    // Loading screen
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

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }
}
