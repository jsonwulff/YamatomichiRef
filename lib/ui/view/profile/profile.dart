import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userUID = context.read<AuthenticationService>().user.uid;
    DocumentReference user =
        FirebaseFirestore.instance.collection('userProfiles').doc(userUID);

    return StreamBuilder<DocumentSnapshot>(
      stream: user.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: Text('Edit Profile'),
          ),
          body: SafeArea(
            child: Center(child: Text(snapshot.data.get('name'))),
          ),
        );
      },
    );
  }
}
