import 'package:app/notifiers/navigatiobar_notifier.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'notifiers/event_notifier.dart';
import 'package:app/routes/route_generator.dart';
import 'package:app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  analytics = FirebaseAnalytics();
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (context) => UserProfileNotifier()),
        // TODO: Remove BottomNavigationBarProvider and switch to correct navigation implementation
        ChangeNotifierProvider(create: (context) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (context) => EventNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yamatomichi',
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? (FirebaseAuth.instance.currentUser.emailVerified ? calendarRoute : signInRoute)
            : signInRoute,

        // theme: ThemeData(
        //     brightness: Brightness.dark,
        //     primaryColor: Colors.lightBlue[800],
        //     accentColor: Colors.cyan[600],

        //     // Define the default font family.
        //     fontFamily: 'Georgia',
        //     // Define the default TextTheme. Use this to specify the default
        //     // text styling for headlines, titles, bodies of text, and more.
        //     textTheme: TextTheme(
        //         headline1:
        //             TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //         headline6:
        //             TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //         bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'))),
        onGenerateRoute: RouteGenerator.generateRoute,
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appTitle,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('da', 'DK'), // Danish
          const Locale('ja', '') // Japanese, for all regions
        ],
      ),
    );
  }
}

/// Used for integration testing
Future<Main> testMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  analytics = FirebaseAnalytics();
  return Main();
}
