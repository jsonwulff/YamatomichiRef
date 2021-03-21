import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/components/global/bottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(texts.home),
      ),
      bottomNavigationBar: bottomNavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(firebaseUser != null ? firebaseUser.email : texts.notSignedIn),
            ElevatedButton(
              onPressed: () async {
                if (await context
                    .read<AuthenticationService>()
                    .signOut(context)) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, signInRoute, (Route<dynamic> route) => false);
                }
              },
              child: Text(texts.signOut),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, profileRoute);
              },
              child: Text(texts.profile),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/support');
              },
              child: Text(texts.support),
              key: Key('SupportButton'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
              },
              child: Text(texts.calendar),
            ),
          ],
        ),
      ),
    );
  }
}
