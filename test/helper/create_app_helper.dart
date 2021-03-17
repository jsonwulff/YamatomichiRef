import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAppHelper {
  static MaterialApp generateBasicApp(Widget widget)
  {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
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
}
