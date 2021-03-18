import 'package:app/ui/view/auth/await_verified_email_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../middleware/firebase/setup_firebase_auth_mock.dart';
import 'package:app/routes/route_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserMock extends Mock implements User {}

main() {
  setupFirebaseAuthMocks();

  final _emailTest = 'test@test.com';
  final alertDialogFinder = find.byKey(Key('EmailNotVerifiedAlertDialog'));
  
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  MaterialApp appCreator({User user}) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return Center(
            child: ElevatedButton(onPressed: () async {
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
    );
  }

  final mailHasBeenSentTextFinder = find.byKey(Key('NotVerifiedEmail_MailHasBeenSend'));
  final resendMailTextFinder = find.byKey(Key('NotVerifiedEmail_ResendMailText'));
  final resendMailButtonFinder = find.byKey(Key('NotVerifiedEmail_ResendMailButton'));
  final openMailAppTextFinder = find.byKey(Key('NotVerifiedEmail_OpenMailAppText'));
  final openMailAppButtonFinder = find.byKey(Key('NotVerifiedEmail_OpenMailAppButton'));
  final closeButtonFinder = find.byKey(Key('NotVerifiedEmail_CloseButton'));

  testWidgets('Ensure that the alert is created with all necessary information', (WidgetTester tester) async {
    UserMock userMock = UserMock();
    when(userMock.email).thenReturn(_emailTest);

    await tester
        .pumpWidget(appCreator(user: userMock));

    await tester.tap(find.text('Press Here'));
    await tester.pump();

    expect(alertDialogFinder, findsOneWidget);
    expect(mailHasBeenSentTextFinder, findsOneWidget);
    expect(resendMailTextFinder, findsOneWidget);
    expect(resendMailButtonFinder, findsOneWidget);
    expect(openMailAppTextFinder, findsOneWidget);
    expect(openMailAppButtonFinder, findsOneWidget);
    expect(closeButtonFinder, findsOneWidget);
  });

  testWidgets('Email not verified alert can be closed by pressing the close button', (WidgetTester tester) async {
    UserMock userMock = UserMock();
    when(userMock.email).thenReturn(_emailTest);

    await tester
        .pumpWidget(appCreator(user: userMock));

    await tester.tap(find.text('Press Here'));
    await tester.pump();

    await tester.tap(closeButtonFinder);
    await tester.pump();

    expect(alertDialogFinder, findsNothing);
  });
}
