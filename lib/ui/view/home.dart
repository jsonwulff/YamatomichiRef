import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(firebaseUser != null
              ? firebaseUser.email
              : "Not Signed In"),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/signup");
            },
            child: Text("Sign up"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/signin");
            },
            child: Text("Sign in"),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthenticationService>().signOut();
            },
            child: Text("Sign out"),
          )
        ],
      )),
    );
  }
}
