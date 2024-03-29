import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CreateAppHelper {
  static MaterialApp generateSimpleApp(Widget widget, {Widget appBar, Widget bottomAppBar}) {
    return MaterialApp(
      home: Scaffold(
        appBar: appBar ?? AppBar(),
        body: widget,
        bottomNavigationBar: bottomAppBar ?? BottomAppBar(),
      ),
    );
  }

  static Widget generateYamatomichiTestApp(Widget widget,
      {AuthenticationService authenticationService,
      UserProfileNotifier userProfileNotifier}) {
    return MultiProvider(
      providers: [
        authenticationService != null
            ? Provider<AuthenticationService>(
                create: (_) => authenticationService,
              )
            : Provider<AuthenticationService>(
                create: (_) => AuthenticationService(FirebaseAuth.instance),
              ),
        userProfileNotifier != null
            ? Provider<UserProfileNotifier>(
                create: (_) => userProfileNotifier,
              )
            : Provider<UserProfileNotifier>(
                create: (_) => UserProfileNotifier(),
              ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (context) => UserProfileNotifier()),
        ChangeNotifierProvider(create: (context) => EventNotifier()),
      ],
      child: MaterialApp(
        home: widget,
        debugShowCheckedModeBanner: false,
        title: 'Yamatomichi',
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

  static MultiProvider generateYamatomichiTestAppAlertDialog(dynamic widget) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
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

  static MultiProvider generateYamatomichiTestAppCallFunction(
      Function function) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
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
