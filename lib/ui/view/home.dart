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
              icon: Icon(Icons.account_box),
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
                if (await context
                    .read<AuthenticationService>()
                    .signOut(context)) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, signInRoute, (Route<dynamic> route) => false);
                }
              },
              child: Text("Sign out"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, profileRoute);
              },
              child: Text("Profile"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/support');
              },
              child: Text("Support"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
              },
              child: Text("Calendar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createEvent');
              },
              child: Text("Create Event"),
            )
          ],
        ),
      ),
    );
  }
}
