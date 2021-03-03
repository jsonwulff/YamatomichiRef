import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/view/auth/sign_up.dart';
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

    if (firebaseUser != null) {
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text('Home'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, homeRoute);
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.pushNamed(context, profileRoute);
                },
              ),
            ],
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(firebaseUser != null ? firebaseUser.email : "Not Signed In"),
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
    // TODO: Add the initial login screen with link to signUp
    return SignUpView();
  }
}
