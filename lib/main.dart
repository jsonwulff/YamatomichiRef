import 'package:app/assets/theme/theme_data_custom.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'middleware/notifiers/event_notifier.dart';
import 'middleware/notifiers/navigatiobar_notifier.dart';
import 'middleware/notifiers/user_profile_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ui/routes/route_generator.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  Main createState() => Main();
  static Main of(BuildContext context) =>
      context.findAncestorStateOfType<Main>();
}

class Main extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale value) {
    setState(() {
      print("Changing language to " + value.languageCode);
      _locale = value;
      SharedPreferences.getInstance().then(
          (prefs) => prefs.setString('language_code', value.languageCode));
    });
  }

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
        ChangeNotifierProvider(create: (context) => UserProfileNotifier()),
        // TODO: Remove BottomNavigationBarProvider and switch to correct navigation implementation
        ChangeNotifierProvider(
            create: (context) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (context) => EventNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yamatomichi',
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? (FirebaseAuth.instance.currentUser.emailVerified
                ? calendarRoute
                : signInRoute)
            : signInRoute,
        theme: ThemeDataCustom.getThemeData(),
        onGenerateRoute: RouteGenerator.generateRoute,
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).appTitle,
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
        locale: _locale,
      ),
    );
  }
}

/// Used for integration testing
Future<MyApp> testMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  analytics = FirebaseAnalytics();
  return MyApp();
}
