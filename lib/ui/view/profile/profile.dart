import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserProfile _userProfile;
  TextEditingController _dateController = TextEditingController();

  List<String> japanRegions = ['Japan1', 'Japan2'];
  List<String> chinaRegions = ['China1', 'China2'];
  List<String> koreanRegions = ['Korea1', 'Korea2'];
  final List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

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

  Widget _buildRegionAutocomplete(UserProfile userProfile) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        print('You just selected $selection');
      },
    );
  }

  // Widget _buildCountryDropdown(UserProfile userProfile) {
  //   return DropdownButton(
  //     isExpanded: true,
  //     value: userProfile.country ?? 'Japan',
  //     onChanged: (String newValue) {
  //       setState(() {
  //         userProfile.country = newValue;
  //       });
  //     },
  //     items: <String>['Japan', 'Korea', 'China']
  //         .map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   );
  // }

  // Widget _buildHikingRegionDropDown(UserProfile userProfile) {
  //   List<String> regions;
  //   switch (userProfile.country) {
  //     case 'Japan':
  //       regions = japanRegions;
  //       break;
  //     case 'Korea':
  //       regions = koreanRegions;
  //       break;
  //     case 'China':
  //       regions = chinaRegions;
  //       break;
  //     // default:
  //     //   regions = ['Test1', 'Test2'];
  //   }

  //   return DropdownButton(
  //     isExpanded: true,
  //     value: userProfile.hikingRegion ?? regions[0],
  //     onChanged: (String newValue) {
  //       setState(() {
  //         print(newValue);
  //         userProfile.hikingRegion = newValue;
  //         print(userProfile.toMap().toString());
  //       });
  //     },
  //     items: regions.map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   );
  // }

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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildRegionAutocomplete(_userProfile),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8),
                //   child: _buildCountryDropdown(_userProfile),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8),
                //   child: _buildHikingRegionDropDown(_userProfile),
                // ),
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
