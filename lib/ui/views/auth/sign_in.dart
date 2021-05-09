import 'dart:async';

import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:app/middleware/firebase/dynamic_links_service.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/shared/buttons/button.dart';
import 'package:app/ui/shared/form_fields/text_form_field_generator.dart';
import 'package:app/ui/views/auth/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization
import 'await_verified_email_dialog.dart';

class SignInView extends StatefulWidget {
  SignInView({Key key}) : super(key: key);

  final _formKey = new GlobalKey<FormState>();

  formKey() => _formKey;

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> with WidgetsBindingObserver {
  String email, password;
  AuthenticationService authenticationService;
  
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.initDynamicLinks(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _formKey = widget.formKey();
    var isLoading = false;

    UserProfileNotifier userProfileNotifier =
        Provider.of<UserProfileNotifier>(context, listen: false);
    authenticationService = Provider.of<AuthenticationService>(context);
    //final formKey = new GlobalKey<FormState>();

    var texts = AppLocalizations.of(context);

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    var emailField = TextInputFormFieldComponent(
        emailController, AuthenticationValidation.validateEmail, texts.email,
        iconData: Icons.email, key: Key('SignInEmail'));

    var passwordField = TextInputFormFieldComponent(
      passwordController,
      AuthenticationValidation.validatePassword,
      texts.password,
      iconData: Icons.lock,
      isTextObscured: true,
      key: Key('SignInPassword'),
    );

    final signUpHyperlink = InkWell(
      child: Text(
        texts.clickHereToSignUp,
        style: TextStyle(color: Colors.blue, fontSize: 15),
      ),
      onTap: () => Navigator.pushNamed(context, signUpRoute),
    );

    final forgotPasswordHyperlink = InkWell(
      child: Text(
        texts.forgotPassword,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
        ),
      ),
      onTap: () => resetPasswordAlertDialog(context),
    );

    trySignInUser() async {
      var form = _formKey.currentState;

      if (form.validate()) {
        form.save();
        var value = await context
            .read<AuthenticationService>()
            .signInUserWithEmailAndPassword(
                context: context,
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
                userProfileNotifier: userProfileNotifier);
        if (value == 'Success') {
          setState(() {
            isLoading = true;
          });

          var user = await context.read<UserProfileService>().getUserProfile(
              authenticationService.firebaseAuth.currentUser.uid);

          if (user.isBanned) {
            Navigator.pushNamedAndRemoveUntil(
                context, bannedUserRoute, (Route<dynamic> route) => false);
          } else if (_firebaseAuth.currentUser.emailVerified) {
            Navigator.pushNamedAndRemoveUntil(
                context, calendarRoute, (Route<dynamic> route) => false);
          } else {
            generateNonVerifiedEmailAlert(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value), // TODO use localization
            ),
          );
        }
      }

      setState(() {
        isLoading = false;
      });
    }

    trySignInWithGoogle() async {
      String value = await context
          .read<AuthenticationService>()
          .signInWithGoogle(context: context);
      if (value == 'Success') {
        Navigator.pushReplacementNamed(context, calendarRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
        ));
      }
    }

    _buildAppLogoImage() {
      return Container(
        height: 150.0,
        width: 190.0,
        padding: EdgeInsets.only(top: 0, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Center(
          child: Image(image: AssetImage('lib/assets/images/logo_2.png')),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppLogoImage(),
                  emailField,
                  passwordField,
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: forgotPasswordHyperlink,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: isLoading
                        ? SpinKitCircle(
                            color: Theme.of(context).buttonColor,
                          )
                        : Button(
                            width: 150,
                            label: texts.signIn,
                            key: Key('SignInButton'),
                            onPressed: () {
                              _formKey.currentState.save();
                              return FutureBuilder(
                                future: trySignInUser(),
                                initialData: null,
                                // ignore: missing_return
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // Navigates to correct page or sends an error
                                    // message
                                  } else {
                                    SpinKitCircle(
                                      color: Colors.blue,
                                      size: 50.0,
                                    );
                                  }
                                },
                              );
                              // Navigator.pop(context);
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SignInButton(
                      Buttons.Google,
                      elevation: 0.5,
                      text: texts.signInWithGoogle,
                      onPressed: () {
                        trySignInWithGoogle();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: signUpHyperlink,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
