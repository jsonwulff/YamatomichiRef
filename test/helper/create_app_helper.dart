import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/route_generator.dart';
import 'package:app/ui/components/imageUpload/image_uploader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CreateAppHelper {
  static MaterialApp generateSimpleApp(Widget widget) {
    return MaterialApp(
        home: widget
      );
  }

   static Widget generateYamatomichiTestApp(Widget widget) {
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
      ],
      child: MaterialApp(
        home: widget,
        debugShowCheckedModeBanner: false,
        title: 'Yamatomichi',
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
      ),
    );
  }

  static MultiProvider generateYamatomichiTestAppAlertDialog(dynamic widget) {
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
      ],
      child: MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Center(
              child: ElevatedButton(
                key: Key('ButtonToPress'),
                onPressed: () async {
                  await widget(context);
                },
                child: Text('Press Here'),
              ),
            );
          },
        ),
        debugShowCheckedModeBanner: false,
        title: 'Yamatomichi',
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
      ),
    );
  }

  static MultiProvider generateYamatomichiTestAppCallFunction(Function function) {
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
      ],
      child: MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Center(
              child: ElevatedButton(
                key: Key('ButtonToPress'),
                onPressed: () async {
                  function(context);
                },
                child: Text('Press Here'),
              ),
            );
          },
        ),
        debugShowCheckedModeBanner: false,
        title: 'Yamatomichi',
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
      ),
    );
  }
}
