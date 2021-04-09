import 'dart:io';

import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalProfileView extends StatefulWidget {
  @override
  _PersonalProfileViewState createState() => _PersonalProfileViewState();
}

class _PersonalProfileViewState extends State<PersonalProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.basicAppBarWithContext('Personal Profile', context),
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.settings),
              tooltip: 'Edit profile',
              onPressed: () {
                setState(() {});
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
