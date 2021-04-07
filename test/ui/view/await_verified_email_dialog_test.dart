import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/route_generator.dart';
import 'package:app/ui/views/auth/await_verified_email_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../middleware/firebase/setup_firebase_auth_mock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserMock extends Mock implements User {}

main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  MultiProvider appCreator({User user}) {
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
                onPressed: () async {
                  await generateNonVerifiedEmailAlert(context, user: user);
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

  final _emailTest = 'test@test.com';

  final alertDialogFinder = find.byKey(Key('EmailNotVerifiedAlertDialog'));
  final mailHasBeenSentTextFinder = find.byKey(Key('NotVerifiedEmail_MailHasBeenSend'));
  final resendMailTextFinder = find.byKey(Key('NotVerifiedEmail_ResendMailText'));
  final resendMailButtonFinder = find.byKey(Key('NotVerifiedEmail_ResendMailButton'));
  final openMailAppButtonFinder = find.byKey(Key('NotVerifiedEmail_OpenMailAppButton'));
  final closeButtonFinder = find.byKey(Key('NotVerifiedEmail_CloseButton'));

  testWidgets('Ensure that the alert is created with all necessary information',
      (WidgetTester tester) async {
    UserMock userMock = UserMock();
    when(userMock.email).thenReturn(_emailTest);

    await tester.pumpWidget(appCreator(user: userMock));

    await tester.tap(find.text('Press Here'));
    await tester.pump();

    expect(alertDialogFinder, findsOneWidget);
    expect(mailHasBeenSentTextFinder, findsOneWidget);
    expect(resendMailTextFinder, findsOneWidget);
    expect(resendMailButtonFinder, findsOneWidget);
    expect(openMailAppButtonFinder, findsOneWidget);
    expect(closeButtonFinder, findsOneWidget);
  });

  testWidgets('Email not verified alert can be closed by pressing the close button',
      (WidgetTester tester) async {
    UserMock userMock = UserMock();
    when(userMock.email).thenReturn(_emailTest);

    await tester.pumpWidget(appCreator(user: userMock));

    await tester.tap(find.text('Press Here'));
    await tester.pump();

    await tester.tap(closeButtonFinder);
    await tester.pump();

    expect(alertDialogFinder, findsNothing);
  });
}
