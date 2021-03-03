import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Home'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(firebaseUser != null ? firebaseUser.email : "Not Signed In"),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, signUpRoute);
            },
            child: Text("Sign up"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, signInRoute);
            },
            child: Text("Sign in"),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthenticationService>().signOut();
            },
            child: Text("Sign out"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(profileRoute);
              Navigator.pushNamed(context, profileRoute);
            },
            child: Text("Profile"),
          )
        ],
      )),
    );
  }
}
