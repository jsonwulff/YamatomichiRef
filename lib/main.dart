import 'package:app/routes.dart';
import 'package:app/ui/view/unknown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: unused_import
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'middleware/firebase/authentication_service_firebase.dart';

FirebaseAnalytics analytics;

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Yamatomichi',
        initialRoute: '/',
        routes: routes,
        onUnknownRoute: (RouteSettings settigns) {
          return MaterialPageRoute(
            settings: settigns,
            builder: (BuildContext context) => UnknownPage(),
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  analytics = FirebaseAnalytics();
  runApp(Main());
}
